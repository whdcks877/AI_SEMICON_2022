`include "simple_dual_one_clock.sv"

module Accmulator(
    input wire clk,
    input wire rst_n,

    //PE와 통신하는 포트
    input wire [7:0] psum_i, //한 colum에서 나온 결과
    input wire pvaild_i, //pvalid가 1일때 psum_i가 유효
    output wire pready_o, //acc가 데이터를 출력 중일때는 pready가 0

    input wire [9:0] ofmap_size, // convoultion 결과물의 사이즈
    input wire [5:0] ifmap_ch, // 입력과 커널의 채널 사이즈

    output wire conv_valid_o, //accumulate가 완료 되고 결과값이 출력 됨을 알리는 신호
    output wire [7:0] conv_result_o //accumulate 결과값
);

    localparam  S_INIT  = 2'd0,
                S_ACC   = 2'd1,
                S_OUT   = 2'd2;

    //

    wire [31:0] acc_ram_o;
    wire first;

    reg [1:0]   state, state_n;
    reg [9:0]   ps_cnt, ps_cnt_n; 
    reg [5:0]   ch_cnt, ch_cnt_n;
    reg [9:0]   rdptr, rdptr_n, wrptr, wrptr_n;
 
    reg [31:0]  adder_i;
    reg [31:0]  adder_o;
    reg [31:0]  sign_extended;
    reg rden_acc, wren_acc;
    reg pready;
    reg conv_valid;
    reg [7:0]   truncated_data;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= S_INIT;
            ps_cnt <= 'b0;
            ch_cnt <= 'b0;
            rdptr <= 'b0;
            wrptr <='b0;
        end else begin
            state <= state_n;
            ps_cnt <= ps_cnt_n;
            ch_cnt <= ch_cnt_n;
            rdptr <= rdptr_n;
            wrptr <= wrptr_n;
        end
    end

    always_comb begin
        state_n = state;

        ps_cnt_n = ps_cnt;  
        ch_cnt_n = ch_cnt; 

        rdptr_n = rdptr;
        wrptr_n = wrptr;

        rden_acc = 'b0;
        wren_acc = 'b0;
        
        pready = 1'b0;
        conv_valid = 1'b0;
        
        case(state)
            S_INIT: begin
                state_n = S_ACC;
                rden_acc = 1'b1;
                rdptr_n  = rdptr + 1;
            end
            S_ACC: begin
                pready = 1'b1;
                if(pvaild_i) begin
                    rden_acc = 1'b1;
                    wren_acc = 1'b1;
                    if(ps_cnt == ofmap_size) begin
                        ps_cnt_n = 'b0;
                        if(ch_cnt == ifmap_ch) begin
                           state_n = S_OUT; 
                           rdptr_n = 'b0;
                        end else begin
                            ch_cnt_n = ch_cnt + 1;
                        end
                    end else begin
                        ps_cnt_n = ps_cnt + 1;
                    end

                    if(rdptr == ofmap_size )
                        rdptr_n = 'b0;
                    else
                        rdptr_n = rdptr + 1;
                end
            end
            S_OUT: begin
                conv_valid = 1'b1;
                rden_acc = 1'b1;
                if(rdptr == ofmap_size) begin
                    state_n = S_INIT;
                end else begin
                    rdptr_n = rdptr + 1;
                end
            end
        endcase
    end

   //adder
    always_comb begin
        if(ch_cnt == 'b0) begin
            adder_i = 32'b0;
        end else begin
            adder_i = acc_ram_o;
        end
        
        sign_extended = {{24{psum_i[7]}},psum_i[7:0]};
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
        .addra(ps_cnt),
        .addrb(rdptr),
        .dia(adder_o),
        .dob(acc_ram_o)
    );

    assign pready_o = pready;
    assign conv_valid_o = conv_valid;
    assign conv_result_o = truncated_data;
endmodule