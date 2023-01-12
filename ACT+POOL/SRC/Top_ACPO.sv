//version 2022-01-13
//editor IM SUHYEOK

module Top_ACPO #(
    parameter       ACC_NUM             = 16,
    parameter       POOL_NUM            = 16,
    parameter       FA_NUM              = 1,
    parameter       ADDRESS_WIDTH       = 10,
    parameter       DATA_WIDTH          = 8
)
(
    input                       clk,
    input                       rst,
    
    input                       acc_last_i [ACC_NUM + FA_NUM], 
    input                       acc_valid_i [ACC_NUM + FA_NUM],
    input                       [DATA_WIDTH-1:0] acc_result_i [ACC_NUM + FA_NUM],
    input                       [ADDRESS_WIDTH-1:0] acc_result_address_i [ACC_NUM],

    output                      act_last_o,
    output                      act_valid_o,
    output                      act_result_o,

    output                      pool_last_o [POOL_NUM],
    output                      pool_valid_o [POOL_NUM],
    output                      [DATA_WIDTH-1:0] pool_result_o [POOL_NUM],
    output                      [ADDRESS_WIDTH-1:0] pool_result_address_o [POOL_NUM]
);

    wire                        act_last [ACC_NUM + FA_NUM];
    wire                        act_valid [ACC_NUM + FA_NUM];
    wire                        [DATA_WIDTH-1:0] act_result [ACC_NUM + FA_NUM];
    wire                        [ADDRESS_WIDTH-1:0] act_result_address [ACC_NUM];

    wire                        act_last_16 [ACC_NUM];
    wire                        act_valid_16 [ACC_NUM];
    wire                        [DATA_WIDTH-1:0] act_result_16 [ACC_NUM];
    
    Activation_x17  u_AC(
            .clk(clk),
            .rst(rst),  
            .acc_last_i(acc_last_i), 
            .acc_valid_i(acc_valid_i),
            .acc_result_i(acc_result_i),
            .acc_result_address_i(acc_result_address_i),
            .act_last_o(act_last),
            .act_valid_o(act_valid),
            .act_result_o(act_result),
            .act_result_address_o(act_result_address) 
        );
    
    Pooling_x16 u_POOL(
            .clk(clk),                                  
            .rst(rst),                                  
            .act_last_i(act_last_16),                                
            .act_valid_i(act_valid_16),                               
            .act_result_i(act_result_16),                               
            .act_result_address_i(act_result_address),                               
            .pool_last_o(pool_last_o),                               
            .pool_valid_o(pool_valid_o),                               
            .pool_result_o(pool_result_o),                               
            .pool_result_address_o(pool_result_address_o)
        );

    assign act_last_16                  = act_last[0:15];  
    assign act_valid_16                 = act_valid[0:15];    
    assign act_result_16                = act_result[0:15];       

    assign act_last_o                   = act_last[16];                
    assign act_valid_o                  = act_valid[16]; 
    assign act_result_o                 = act_result[16];
endmodule