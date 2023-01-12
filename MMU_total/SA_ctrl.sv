// SA Controller
// JY Lee
// Version 2023-01-10 1st verified
// 2023-01-12 2nd verified

module SA_ctrl
(
    input   wire        clk,
    input   wire        rst_n,
    //config
    input   wire        start,
    input   wire        nth_conv_i,
    //data setup
    input   wire        data_last,
    input   wire        d_valid_i,
    output  reg         data_enable,
    //weight buffer
    output  reg         nth_conv_o,       //0=1th conv(6 filters), 1=2nd conv(16th filter)
    output  reg         weight_start,
    //SA
    output  reg         weight_stop
);
    reg     [1:0]       state,      state_n;
    reg                 wieght_stop_n;
    reg                 data_enable_n;
    reg                 nth_conv_n;
    reg     [4:0]       cnt,        cnt_n;
    reg                 weight_start_n;
    reg                 weight_stop_n;

    localparam          S_IDLE      =   2'd0,
                        S_1th_Conv  =   2'd1,
                        S_2nd_Conv  =   2'd2;
    //FSM IDLE, 1th Conv, 2nd Conv

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= S_IDLE;
            data_enable <= 1'b0;
            weight_stop <= 1'b1;
            nth_conv_o <= 1'b0;
            cnt <= 5'd0;
            weight_start <= 1'b0;
        end
        else begin
            state <= state_n;
            data_enable <= data_enable_n;
            weight_stop <= weight_stop_n;
            nth_conv_o <= nth_conv_n;
            cnt <= cnt_n;
            weight_start <= weight_start_n;
        end
    end

    always_comb begin
        state_n = state;
        weight_stop_n = weight_stop;
        data_enable_n = data_enable;
        nth_conv_n = nth_conv_i;
        cnt_n = cnt;
        weight_start_n = weight_start;

        case(state)
            S_IDLE: begin
                if(start) begin
                    state_n = nth_conv_i ? S_2nd_Conv : S_1th_Conv;
                    weight_stop_n = 1'b0;
                    weight_start_n = 1'b1;
                    data_enable_n = 1'b0;
                end
            end
            S_1th_Conv: begin
                //6 filters     
                if(!data_enable)
                    cnt_n = cnt + 'd1;
                else begin
                    state_n = data_last ? S_IDLE : S_1th_Conv;
                    data_enable_n = data_last ? 1'b0 : 1'b1;
                end
                if(cnt == 'd26) begin
                    weight_start_n = 1'b0;
                end

                if(cnt == 'd28) begin   //cnt can change by BRAM RL, maybe 26 or 27
                    weight_stop_n = 1'b1;
                    
                end
                if(cnt == 'd29) begin
                    cnt_n = 'd0;
                    data_enable_n = 1'b1;
                end

            end
            S_2nd_Conv: begin
                //16 filters     
                if(!data_enable)
                    cnt_n = cnt + 'd1;
                else begin
                    state_n = data_last ? S_IDLE : S_1th_Conv;
                    data_enable_n = data_last ? 1'b0 : 1'b1;
                end
                if(cnt == 'd26) begin
                    weight_start_n = 1'b0;
                end

                if(cnt == 'd28) begin   //cnt can change by BRAM RL, maybe 26 or 27
                    weight_stop_n = 1'b1;
                    
                end
                if(cnt == 'd29) begin
                    cnt_n = 'd0;
                    data_enable_n = 1'b1;
                end
            end
        endcase
    end


endmodule