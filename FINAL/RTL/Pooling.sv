//version 2022-01-13
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

    output  reg                 [ADDRESS_WIDTH-1:0] addra_o,
    output  reg                 pool_last_o,
    output  reg                 pool_valid_o,
    output  reg                 [DATA_WIDTH-1:0] pool_result_o,
    output  reg                 [ADDRESS_WIDTH-1:0] pool_result_address_o
);

    localparam  S_INIT         = 3'd0,
                S_POOL         = 3'd1,
                S_POOL1        = 3'd2,
                S_POOL2        = 3'd3,
                S_POOL3        = 3'd4;

    reg                         [ADDRESS_WIDTH-1:0] addra;
    reg                         pool_valid;
    reg                         act_last;
    reg                         [DATA_WIDTH-1:0] a1; // 2x2 pooling data reg
    reg                         [ADDRESS_WIDTH-1:0] a2; // pooling address reg
    reg                         [DATA_WIDTH-1:0] pool_result;
    reg                         [ADDRESS_WIDTH-1:0] pool_result_address;
    reg                         [2:0] state, state_n;

    always_ff @(posedge clk) begin
        if(!rst) begin    
            state                   <= S_INIT;
            pool_last_o             <= 'b0;
            pool_valid_o            <= 'b0;
            pool_result_o           <= 'd0;
            pool_result_address_o   <= 'd0;
            addra_o                 <= 'hFFFFFFFF;

        end else begin
            state                   <= state_n;
            pool_last_o             <= act_last_i;
            pool_valid_o            <= pool_valid;
            pool_result_o           <= pool_result;
            pool_result_address_o   <= pool_result_address;
            addra_o                 <= addra;
        end
    end

    always_comb begin
        pool_valid = pool_valid_o;
        pool_result = pool_result_o;
        pool_result_address = pool_result_address_o;
        addra = addra_o;
        case(state)
            S_INIT: begin
                if(act_valid_i) begin
                    a1 = act_result_i;
                    a2 = act_result_address_i;
                    state_n = S_POOL1;
                end
                else begin
                    state_n = S_INIT;
                    pool_valid  = 'b0;
                    pool_result = 'd0;
                    pool_result_address = 'd0;
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
                state_n = S_INIT;
                if(act_valid_i) begin
                    pool_valid = 1'b1;
                    addra = (addra == 'd195) ? 'd0 : (addra_o + 'd1);
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



endmodule
