//version 2022-01-19
//editor IM SUHYEOK
//edited SM PARK as of 20220120

module SA_ctrl
(
    input   wire                        clk,
    input   wire                        rst_n,
    input   wire                        start_i,        
    input   wire                        data_last_i,
    input   wire                        [1:0] nth_conv_i,
    input   wire                        conv_done_i,
    output  wire                        data_enable_o,          //data setup
    output  wire                        weight_start_o,         //weight buffer
    output  wire                        weight_stop_o,           //SA
    output  wire                        [3:0] cnt2_o
);

    localparam          S_IDLE      = 3'd0,
                        S_CONV      = 3'd1,
                        S_CONV_N    = 3'd2,
                        S_CONV2_N   = 3'd3,
                        S_WAIT      = 3'd4;

    reg                 [2:0] state, state_n;
    reg                 data_enable;
    reg                 [4:0] cnt, cnt_n;
    reg                 [3:0] cnt2, cnt2_n;
    reg                 weight_start;
    reg                 weight_stop;


    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= S_IDLE;
            cnt <= 5'd0;
            cnt2 <= 'd1;
        end
        else begin
            state <= state_n;
            cnt <= cnt_n;
            cnt2 <= cnt2_n;
        end
    end

    always_comb begin
        data_enable = 1'b0;
        state_n = state;
        cnt_n   = cnt;
        cnt2_n  = cnt2;
        weight_start = 1'b0;

        case(state)
            S_IDLE: begin
                cnt_n       = 'd0;
                weight_stop = 1'b0;
                if(start_i) begin
                    state_n = S_CONV;
                    weight_start = 1'b1;
                end
            end
            S_CONV: begin
                cnt_n = cnt + 'd1;
                if(cnt < 'd27) begin
                    weight_stop     = 1'b0;
                end
                else begin
                    weight_stop     = 1'b1;
                end

                if(cnt == 'd28) begin
                    cnt_n = 'd0;
                    data_enable = 1'b1;
                    if (nth_conv_i == 0) begin
                        state_n = S_CONV_N;
                    end 
                    else begin
                        state_n = S_CONV2_N;
                    end
                end
            end
            S_CONV_N: begin
                weight_stop = 1'b1;
                data_enable = 1'b1;
                if(conv_done_i) begin
                    data_enable = 1'b0;
                    state_n = S_WAIT;
                end
            end
            S_CONV2_N : begin
                weight_stop = 1'b1;
                if(!conv_done_i) begin
                    if(data_last_i) begin
                        data_enable = 1'b0;
                        state_n = S_WAIT;
                    end
                    else begin
                        data_enable = 1'b1;
                    end
                end
                else begin
                    data_enable = 1'b0;
                    state_n = S_WAIT;
                end
            end

            S_WAIT: begin
                cnt_n = cnt + 'd1;
                if(nth_conv_i == 'd0) begin
                    if(cnt == 'd5) begin
                        state_n      = S_IDLE;
                        cnt2_n         = 'd1;
                    end
                end
                else if(nth_conv_i == 'd1) begin
                    if(cnt == 'd15) begin
                        cnt_n = 'd0;
                        if(cnt2 == 'd6) begin
                            state_n      = S_IDLE; 
                            cnt2_n       = 'd1;
                        end
                        else begin
                            state_n     = S_CONV;
                            weight_start = 'b1;
                            cnt2_n = cnt2 + 'd1;
                        end
                    end
                end
                
            end
        endcase
    end

    assign data_enable_o        = data_enable;
    assign weight_stop_o        = weight_stop;
    assign weight_start_o       = weight_start;
    assign cnt2_o               = cnt2;

endmodule