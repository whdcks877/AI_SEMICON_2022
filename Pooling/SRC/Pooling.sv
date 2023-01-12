//version 2022-01-12
//editor IM SUHYEOK

module Pooling #(
    parameter       DATA_WIDTH          = 8,
    parameter       ADDRESS_WIDTH       = 10
)
(
    input   wire                clk,
    input   wire                rst,
    
    input   wire                act_last_i, 
    input   wire                act_valid_i,
    input   wire                [DATA_WIDTH-1:0] act_result_i,
    input   wire                [ADDRESS_WIDTH-1:0] act_result_address_i,

    output                      pool_last_o,
    output                      pool_valid_o,
    output                      [DATA_WIDTH-1:0] pool_result_o,
    output                      [ADDRESS_WIDTH-1:0] pool_result_address_o
);

    localparam  S_INIT         = 3'd0,
                S_POOL1        = 3'd1,
                S_POOL2        = 3'd2,
                S_POOL3        = 3'd3,
                S_POOL4        = 3'd4,
                S_POOL         = 3'd5;

    reg                         pool_valid;
    reg                         pool_last;
    reg                         [DATA_WIDTH-1:0] a1; // 2x2 pooling data reg
    reg                         [ADDRESS_WIDTH-1:0] a2; // pooling address reg
    reg                         [DATA_WIDTH-1:0] pool_result;
    reg                         [ADDRESS_WIDTH-1:0] pool_result_address;
    reg                         [2:0] state, state_n;

    always_ff @(posedge clk) begin
        if(!rst) begin    
            state <= S_INIT;
        end else begin
            state <= state_n;
        end
    end


     always_comb begin
        state_n = state;
        pool_valid = 1'b0;
        pool_last = 1'b0;
    
        case(state)
            S_INIT: begin
                if(act_valid_i) begin
                    state_n = S_POOL;
                    pool_result = 'b0;
                    pool_result_address = 'b0;
                    a1 = 'd0;
                    a2 = 'd0;
                    if(act_last_i) begin
                        pool_last = 1'b1;
                    end
                end
            end
            S_POOL: begin
                if(act_valid_i) begin
                    if (!act_last_i) begin
                        if (act_result_i > a1) begin
                            a1 = act_result_i;
                            a2 = act_result_address_i;
                        end
                        state_n = S_POOL2;
                    end
                    else begin
                        pool_last = 1'b1;
                        state_n = S_INIT;
                    end
                    pool_valid = 1'b0;
                end
                else state_n = S_INIT;
            end
            S_POOL1: begin
                if(act_valid_i) begin
                    if (!act_last_i) begin
                        if (act_result_i > a1) begin
                            a1 = act_result_i;
                            a2 = act_result_address_i;
                        end
                        state_n = S_POOL2;
                    end
                    else begin
                        pool_last = 1'b1;
                        state_n = S_INIT;
                    end
                    pool_result = a1;
                    pool_result_address = a2;
                    pool_valid = 1'b1;
                    a1 = 'd0;
                    a2 = 'd0;
                end
                else state_n = S_INIT;
            end
            S_POOL2 : begin
                if(act_valid_i) begin
                    if (!act_last_i) begin
                        if (act_result_i > a1) begin
                            a1 = act_result_i;
                            a2 = act_result_address_i;
                        end
                        state_n = S_POOL3;
                        end
                    else begin
                        pool_last = 1'b1;
                        state_n = S_INIT;
                    end
                    pool_valid = 1'b0;
                end
                else state_n = S_INIT;
            end
            S_POOL3 : begin
                if(act_valid_i) begin
                    if (!act_last_i) begin
                        if (act_result_i > a1) begin
                            a1 = act_result_i;
                            a2 = act_result_address_i;
                        end
                        state_n = S_POOL4;
                        end
                    else begin
                        pool_last = 1'b1;
                        state_n = S_INIT;
                    end
                    pool_valid = 1'b0;
                end
                else state_n = S_INIT;
            end
            S_POOL4 : begin
                if(act_valid_i) begin
                    if (!act_last_i) begin
                        if (act_result_i > a1) begin
                            a1 = act_result_i;
                            a2 = act_result_address_i;
                        end
                        state_n = S_POOL1; 
                    end
                    else begin
                        pool_last = 1'b1;
                        state_n = S_INIT;
                    end
                    pool_valid = 1'b0;
                end
                else state_n = S_INIT;
            end
        endcase
    end

    assign pool_last_o                  = pool_last;
    assign pool_valid_o                 = pool_valid;
    assign pool_result_o                = pool_result;
    assign pool_result_address_o        = pool_result_address;

endmodule
