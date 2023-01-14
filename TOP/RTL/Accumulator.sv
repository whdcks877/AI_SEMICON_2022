`include "simple_dual_one_clock.sv"

module Accumulator(
    input wire clk,
    input wire rst_n,

    //interface with one colum of systolic array
    input wire [7:0] psum_i, //output of last row of pe
    input wire pvalid_i, 
    output wire pready_o, 

    input wire [4:0] ofmap_size_i, // size of output size :: actual size of result is ofmap_size^2
    input wire [5:0] ifmap_ch_i, 

    //interface with activation
    output wire conv_valid_o, 
    output wire last_o,
    output wire [7:0] conv_result_o,
    output wire [9:0] addr_o
);

    localparam  S_INIT  = 'd0,
                S_ACC   = 'd1,
                S_WRITE  = 'd2,
                S_OUT   = 'd3,
                S_POOL_OUT = 'd4,
                S_LAST_OUT = 'd5;

    wire [31:0] acc_ram_o;

    wire [9:0]  pool1, pool2, pool3, pool4; 

    reg [7:0]   psum;
    reg [2:0]   state, state_n;
    reg [4:0]   ps_cnt, ps_cnt_n,ps_cnt2, ps_cnt2_n; //counter for partial sum
    reg [5:0]   ch_cnt, ch_cnt_n, ch_cnt_d; //counter for channel
    reg [9:0]   rdptr, rdptr_n, wrptr, wrptr_n, pool_offset, pool_offset_n; 
    reg [4:0]   ofmap_size, ofmap_size_n;
    reg [5:0]   ifmap_ch, ifmap_ch_n;
 
    reg [31:0]  adder_i;
    reg [31:0]  adder_o;
    reg [31:0]  sign_extended; //8bit input -> 32bit
    reg         rden_acc, wren_acc;
    reg         pready;
    reg         conv_valid;
    reg [7:0]   truncated_data;
    reg         last;
    reg         pvalid_d;
    reg [9:0]   addr_d;

    assign pool1 = pool_offset; 
    assign pool2 = pool1 + 1;
    assign pool3 = pool_offset + (ofmap_size + 1);
    assign pool4 = pool3 + 1;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= S_INIT;
            ps_cnt <= 'b0;
            ps_cnt2 <= 'b0;
            ch_cnt <= 'b0;
            ch_cnt_d <= 'b0;
            rdptr <= 'b0;
            wrptr <='b0;
            ofmap_size <= 5'b0;
            ifmap_ch <= 6'b0;
            psum <= 'b0;
            pvalid_d <= 'b0;
        end else begin
            state <= state_n;
            ps_cnt <= ps_cnt_n;
            ps_cnt2 <= ps_cnt2_n;
            ch_cnt <= ch_cnt_n;
            rdptr <= rdptr_n;
            wrptr <= wrptr_n;
            ofmap_size <= ofmap_size_n;
            ifmap_ch <= ifmap_ch_n;
            psum <= psum_i;
            ch_cnt_d <= ch_cnt;
            pvalid_d <= pvalid_i;
        end
    end

    //for one clk delay to rdptr
    always_ff @(posedge clk) begin
        if(!rst_n)
            addr_d <=  'b0;
        else
            addr_d <= rdptr;
    end

    always_comb begin
        state_n = state;

        ps_cnt_n = ps_cnt;  
        ps_cnt2_n = ps_cnt2;  
        ch_cnt_n = ch_cnt; 

        ofmap_size_n = ofmap_size;
        ifmap_ch_n = ifmap_ch;

        rdptr_n = rdptr;
        wrptr_n = wrptr;

        rden_acc = 'b0;
        wren_acc = 'b0;
        
        pready = 1'b0;
        conv_valid = 1'b0;
        last = 1'b0;
        //pool_offset_n = pool_offset;

        pool_offset = (ps_cnt<<1) + ((ps_cnt2<<1) *(ofmap_size+1));
        case(state)
            S_INIT: begin
                pready = 1'b1;

                if(pvalid_i) begin
                    state_n = S_ACC;
                    rdptr_n = rdptr + 1;
                    ps_cnt_n = ps_cnt + 1;

                    //capture convolution layer information
                    ofmap_size_n = ofmap_size_i-1;
                    ifmap_ch_n = ifmap_ch_i-1;
                end
            end
            S_ACC: begin
                pready = 1'b1;

                if(pvalid_d) begin
                    //read sram and write back after addition
                    rden_acc = 1'b1;
                    wren_acc = 1'b1;
                    rdptr_n = rdptr + 1;
                    wrptr_n = rdptr;

                    if(ps_cnt == ofmap_size) begin
                        ps_cnt_n = 4'b0;
                        if(ps_cnt2 == ofmap_size) begin
                            ps_cnt2_n = 'b0;
                            rdptr_n = 'b0;
                            if(ch_cnt == ifmap_ch) begin
                               state_n = S_WRITE; 
                               ch_cnt_n = 0;
                            end else begin
                                ch_cnt_n = ch_cnt + 1;
                            end    
                        end else begin
                            ps_cnt2_n = ps_cnt2 + 1;
                        end
                    end else begin
                        ps_cnt_n = ps_cnt + 1;
                    end
                end
            end
            S_WRITE: begin
                state_n = S_POOL_OUT;
                wren_acc = 1'b1; // Write last data

                //start read data for output
                rden_acc = 1'b1;
                rdptr_n = rdptr + 1;

                ch_cnt_n = ch_cnt + 1; // ch_cnt is used for pooling index
            end
            S_OUT: begin
                //output result from sram
                conv_valid = 1'b1;
                rden_acc = 1'b1;
                if(rdptr == (ofmap_size_i*ofmap_size_i)) begin
                    rden_acc = 1'b0;
                    state_n = S_INIT;
                    last = 1'b1;

                    rdptr_n = 'b0;
                    ch_cnt_n = 'b0;
                end else begin
                    rdptr_n = rdptr + 1;
                end
            end
            S_POOL_OUT : begin
                rden_acc = 1'b1;
                conv_valid = 1'b1;
                
                case(ch_cnt)
                    6'd0: begin
                        rdptr_n = pool2;
                        ch_cnt_n = ch_cnt + 1;
                    end
                    6'd1: begin
                        rdptr_n = pool3;
                        ch_cnt_n = ch_cnt + 1;
                    end
                    6'd2: begin
                        rdptr_n = pool4;
                        ch_cnt_n = ch_cnt + 1;

                    end
                    6'd3: begin
                        ch_cnt_n = 0;
                        rdptr_n = pool1;
                        
                        if(ps_cnt == (ofmap_size>>1)) begin
                            ps_cnt_n = 0;
                            if(ps_cnt2 == (ofmap_size>>1)) begin
                                ps_cnt2_n = 0;
                                rdptr_n = 0;
                                state_n = S_LAST_OUT;
                            end else begin
                                ps_cnt2_n = ps_cnt2 + 1;
                            end  
                        end else begin
                            ps_cnt_n = ps_cnt + 1;
                        end
                        pool_offset = (ps_cnt_n<<1) + ((ps_cnt2_n<<1) *(ofmap_size+1));
                    end
                endcase
            end
            S_LAST_OUT : begin
                last = 1'b1;
                conv_valid = 1'b1;

                state_n = S_INIT;
            end
        endcase
    end

   //adder
    always_comb begin
        if(ch_cnt_d == 'b0) begin
            adder_i = 32'b0;
        end else begin
            adder_i = acc_ram_o;
        end
        
        sign_extended = {{24{psum[7]}},psum[7:0]};
        adder_o = sign_extended + adder_i;
    end

    //saturation
    always_comb begin
        if(acc_ram_o[31] == 1'b0) begin
            if(|acc_ram_o[31:7] == 1'b1)
                truncated_data = 8'b01111111;
           else
                truncated_data = acc_ram_o[7:0];
            
        end else begin
            if(&acc_ram_o[31:7] == 1'b0)
                truncated_data = 8'b10000000;
            else
                truncated_data = acc_ram_o[7:0];
        end
    end

    simple_dual_one_clock #(.SRAM_DEPTH(1024), .DATA_WIDTH(32)) acc_sram(
        .clk(clk),
        .wea(wren_acc),
        .enb(rden_acc),
        .addra(wrptr),
        .addrb(rdptr),
        .dia(adder_o),
        .dob(acc_ram_o)
    );

    assign pready_o = pready;
    assign conv_valid_o = conv_valid;
    assign conv_result_o = truncated_data;
    assign last_o = last;
    assign addr_o = addr_d;
endmodule