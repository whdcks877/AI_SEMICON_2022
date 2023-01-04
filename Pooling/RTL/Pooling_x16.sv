module Pooling_x16 #(
    parameter       POOL_NUM            = 16,
    parameter       DATA_WIDTH          = 8
)
(
    input                       clk,
    input                       rst,
    
    input                       act_last_i [POOL_NUM], 
    input                       act_valid_i [POOL_NUM],
    //output  wire                act_ready_o [POOL_NUM],
    input                       [DATA_WIDTH-1:0] act_result_i [POOL_NUM],

    output                      pool_last_o [POOL_NUM],
    output                      pool_valid_o [POOL_NUM],
    //input   wire                pool_ready_i [POOL_NUM],
    output                      [DATA_WIDTH-1:0] pool_result_o [POOL_NUM]
);
    wire                        act_last [POOL_NUM];
    wire                        act_valid [POOL_NUM];
    wire                        [DATA_WIDTH-1:0] act_result [POOL_NUM];
    wire                        pool_last [POOL_NUM];
    wire                        pool_valid [POOL_NUM];
    wire                        [DATA_WIDTH-1:0] pool_result [POOL_NUM];
    
   genvar index;
    generate
        for (index=0; index<POOL_NUM; index++) begin
            Pooling u_pool(
                .clk(clk),
                .rst(rst),
                .act_last_i(act_last[index]),
                .act_valid_i(act_valid[index]),
                .act_result_i(act_result[index]),
                .pool_last_o(pool_last[index]),
                .pool_valid_o(pool_valid[index]),
                .pool_result_o(pool_result[index])
            );
        end
    endgenerate

    assign act_last             = act_last_i;
    assign act_valid            = act_valid_i;
    assign act_result           = act_result_i;
    assign pool_last_o           = pool_last;
    assign pool_valid_o          = pool_valid;
    assign pool_result_o         = pool_result;

endmodule