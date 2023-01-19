`include "simple_dual_one_clock.sv"

module fc_accumulator(
    input wire clk,
    input wire rst_n,

    //interface with one colum of systolic array
    input wire [7:0] psum_i, //output of last row of pe
    input wire pvalid_i, 

    input wire [6:0] out_node_num_i,
    input wire [3:0] tile_num_i,

    //interface with activation
    output wire fc_valid_o, 
    output wire last_o,
    output wire [7:0] fc_result_o
);

    localparam  S_INIT  = 'd0,
                S_ACC   = 'd1,
                S_WRITE  = 'd2,
                S_OUT   = 'd3,
                S_LAST_OUT = 'd4;

    wire [31:0] acc_ram_o;

    reg [7:0]   psum;
    reg [2:0]   state, state_n;
    reg [6:0]   ps_cnt, ps_cnt_n; //counter for partial sum
    reg [3:0]   ch_cnt, ch_cnt_n, ch_cnt_d; //counter for channel

    reg [9:0]   rdptr, rdptr_n, wrptr, wrptr_n;
    reg [6:0]   out_node_num, out_node_num_n;
    reg [3:0]   tile_num, tile_num_n;
 
    reg [31:0]  adder_i;
    reg [31:0]  adder_o;

    reg [31:0]  sign_extended; //8bit input -> 32bit
    reg         rden_acc, wren_acc;
    reg         conv_valid;
    reg [7:0]   truncated_data;
    reg         last;
    reg         pvalid_d;
    reg [9:0]   addr_d;



    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= S_INIT;
            ps_cnt <= 'b0;
            ch_cnt <= 'b0;
            ch_cnt_d <= 'b0;
            rdptr <= 'b0;
            wrptr <='b0;
            out_node_num <= 6'b0;
            tile_num <= 4'b0;
            psum <= 'b0;
            pvalid_d <= 'b0;
        end else begin
            state <= state_n;
            ps_cnt <= ps_cnt_n;
            ch_cnt <= ch_cnt_n;
            rdptr <= rdptr_n;
            wrptr <= wrptr_n;
            out_node_num <= out_node_num_n;
            tile_num <= tile_num_n;
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
        ch_cnt_n = ch_cnt; 

        out_node_num_n = out_node_num;
        tile_num_n = tile_num;

        rdptr_n = rdptr;
        wrptr_n = wrptr;

        rden_acc = 'b0;
        wren_acc = 'b0;

        conv_valid = 1'b0;
        last = 1'b0;

        case(state)
            S_INIT: begin

                if(pvalid_i) begin
                    state_n = S_ACC;
                    rdptr_n = rdptr + 1;
                    ps_cnt_n = ps_cnt + 1;

                    //capture convolution layer information
                    out_node_num_n = out_node_num_i-1;
                    tile_num_n = tile_num_i-1;
                end
            end
            S_ACC: begin
                rden_acc = 1'b1;
                wrptr_n = rdptr;

                if(pvalid_i || pvalid_d) begin
                    rdptr_n = rdptr + 1;
                end

                if(pvalid_d) begin
                    //read sram and write back after addition
                    wren_acc = 1'b1;

                    if(ps_cnt == out_node_num) begin
                        ps_cnt_n = 'b0;
                        rdptr_n = 'b0;
                        if(ch_cnt == tile_num) begin
                            state_n = S_WRITE; 
                            ch_cnt_n = 0;
                        end else begin
                            ch_cnt_n = ch_cnt + 1;
                        end    
                    end else begin
                        ps_cnt_n = ps_cnt + 1;
                    end
                end
            end
            S_WRITE: begin
                state_n = S_OUT;
                wrptr_n = 'b0;
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
                if(rdptr == (out_node_num)) begin
                    state_n = S_LAST_OUT;
                    
                end else begin
                    rdptr_n = rdptr + 1;
                end
            end
            
            S_LAST_OUT : begin
                last = 1'b1;
                conv_valid = 1'b1;

                state_n = S_INIT;
                
                wrptr_n = 'b0;
                rdptr_n = 'b0;
                ch_cnt_n = 'b0;
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

    assign fc_valid_o = conv_valid;
    assign fc_result_o = truncated_data;
    assign last_o = last;
endmodule