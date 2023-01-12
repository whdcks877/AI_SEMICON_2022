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
                S_POOL         = 3'd1,
                S_POOL1        = 3'd2,
                S_POOL2        = 3'd3,
                S_POOL3        = 3'd4;

    reg                         pool_valid;
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
    pool_valid = 1'b0;
    pool_result = 'b0;
    pool_result_address = 'b0;
        case(state)
            S_INIT: begin
                if(act_valid_i) begin
                    a1 = act_result_i;
                    a2 = act_result_address_i;
                    state_n = S_POOL;
                end
                else begin
                    state_n = S_INIT;
                end
            end
            S_POOL: begin
                if(act_valid_i) begin
                    a1 = act_result_i;
                    a2 = act_result_address_i;
                    state_n = S_POOL1;
                end
                else begin
                    state_n = S_INIT;
                end
            end
            S_POOL1: begin
                if(act_valid_i) begin
                    if (act_result_i > a1) begin
                        a1 = act_result_i;
                        a2 = act_result_address_i;
                    end
                    state_n = S_POOL2;
                end
                else begin
                    state_n = S_INIT;
                end
            end
            S_POOL2 : begin
                if(act_valid_i) begin
                    if (act_result_i > a1) begin
                        a1 = act_result_i;
                        a2 = act_result_address_i;
                    end
                    state_n = S_POOL3;
                end
                else begin
                    state_n = S_INIT;
                end
            end
            S_POOL3 : begin
                state_n = S_POOL;
                if(act_valid_i) begin
                pool_valid = 1'b1;
                    if (act_result_i > a1) begin
                        pool_result = act_result_i;
                        pool_result_address = act_result_address_i;
                    end
                    else begin
                        pool_result = a1;
                        pool_result_address = a2; 
                    end
                end
            end
        endcase
    end

    assign pool_last_o                  = act_last_i;
    assign pool_valid_o                 = pool_valid;
    assign pool_result_o                = pool_result;
    assign pool_result_address_o        = pool_result_address;

endmodule
