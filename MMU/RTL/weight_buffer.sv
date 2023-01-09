// Weight Buffer 
// JY Lee
// Version 2023-01-08

module weight_buffer
(
    input   wire        clk,
    input   wire        rst_n,

    //SActrl-Weight_buffer interface
    input   wire        nth_conv_i,     //low mean 1th conv, high mean 2nd conv
    input   wire        weight_start,

    //BRAM-Weight_buffer interface
    output  reg                 w_enable[15:0],
    output  reg     [5:0]       w_addr[15:0],
    input   wire    [7:0]       w_data_i[15:0],
    

    //Weight_buffer-SA interface
    output  reg     [7:0]       w_data_o[15:0]
);
    reg     [1:0]               state,      state_n;
    reg                         w_enable_n[15:0];
    reg     [5:0]               w_addr_n[15:0];
    reg     [4:0]               cnt,    cnt_n;

    //TODO: FSM
    localparam                  S_IDLE      =   2'd0,
                                S_1th_Conv  =   2'd1,
                                S_2nd_Conv  =   2'd2;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= S_IDLE;
            w_data_o <= 'd0;
            cnt <= 'd0;
        end
        state <= state_n;
        w_data_o <= w_data_i;       //1clk BRAM RL
        w_enable <= w_enable_n;
        w_addr <= w_addr_n;
        cnt <= cnt_n;
    end

    always_comb begin
        state_n = state;
        w_enable_n = w_enable;
        w_addr_n = w_addr;
        cnt_n = cnt;

        case(state)
            S_IDLE: begin
                w_enable_n = 'd0;
                if( weight_start ) begin
                    state_n = nth_conv_i ? S_2nd_Conv : S_1th_Conv;
                    cnt_n = 'd0;
                end
            end
            //TODO: STATE CLEAR
            S_1th_Conv: begin
                cnt_n = cnt + 'd1;
                if(cnt == 'd25) begin
                    state_n = S_IDLE;
                end
                else begin
                    w_addr_n[0] = {1'b0, cnt};
                    w_addr_n[1] = {1'b0, cnt};
                    w_addr_n[2] = {1'b0, cnt};
                    w_addr_n[3] = {1'b0, cnt};
                    w_addr_n[4] = {1'b0, cnt};
                    w_addr_n[5] = {1'b0, cnt};
                    w_enable_n[0] = 1'b1;
                    w_enable_n[1] = 1'b1;
                    w_enable_n[2] = 1'b1;
                    w_enable_n[3] = 1'b1;
                    w_enable_n[4] = 1'b1;
                    w_enable_n[5] = 1'b1;
                end

            end

            S_2nd_Conv: begin
                if(cnt == 'd26) begin
                    state_n = S_IDLE;
                end
                else begin
                    w_addr_n[0] = cnt + 'd25;
                    w_addr_n[1] = cnt + 'd25;
                    w_addr_n[2] = cnt + 'd25;
                    w_addr_n[3] = cnt + 'd25;
                    w_addr_n[4] = cnt + 'd25;
                    w_addr_n[5] = cnt + 'd25;
                    w_addr_n[6] = cnt + 'd25;
                    w_addr_n[7] = cnt + 'd25;
                    w_addr_n[8] = cnt + 'd25;
                    w_addr_n[9] = cnt + 'd25;
                    w_addr_n[10] = cnt + 'd25;
                    w_addr_n[11] = cnt + 'd25;
                    w_addr_n[12] = cnt + 'd25;
                    w_addr_n[13] = cnt + 'd25;
                    w_addr_n[14] = cnt + 'd25;
                    w_addr_n[15] = cnt + 'd25;

                    w_enable_n[0] = 1'b1;
                    w_enable_n[1] = 1'b1;
                    w_enable_n[2] = 1'b1;
                    w_enable_n[3] = 1'b1;
                    w_enable_n[4] = 1'b1;
                    w_enable_n[5] = 1'b1;
                    w_enable_n[6] = 1'b1;
                    w_enable_n[7] = 1'b1;
                    w_enable_n[8] = 1'b1;
                    w_enable_n[9] = 1'b1;
                    w_enable_n[10] = 1'b1;
                    w_enable_n[11] = 1'b1;
                    w_enable_n[12] = 1'b1;
                    w_enable_n[13] = 1'b1;
                    w_enable_n[14] = 1'b1;
                    w_enable_n[15] = 1'b1;

                end
            end

        endcase
    end


endmodule