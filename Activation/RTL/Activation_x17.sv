//version 2022-01-13
//editor IM SUHYEOK
`include "Activation_fc.sv"
`include "Activation_sa.sv"
module Activation_x17 #(
    parameter       ACC_NUM             = 16,
    parameter       FA_NUM              = 1,
    parameter       ADDRESS_WIDTH       = 10,
    parameter       DATA_WIDTH          = 8
)
(
    input                       clk,
    input                       rst,
    
    input                       acc_last_i [ACC_NUM + FA_NUM], 
    input                       acc_valid_i [ACC_NUM + FA_NUM],
    //output  wire                act_ready_o [ACC_NUM],
    input                       [DATA_WIDTH-1:0] acc_result_i [ACC_NUM + FA_NUM],
    input                       [ADDRESS_WIDTH-1:0] acc_result_address_i [ACC_NUM], //FA address not use

    output                      act_last_o [ACC_NUM  + FA_NUM],
    output                      act_valid_o [ACC_NUM  + FA_NUM],
    //input   wire                pool_ready_i [ACC_NUM],
    output                      [DATA_WIDTH-1:0] act_result_o [ACC_NUM  + FA_NUM],
    output                      [ADDRESS_WIDTH-1:0] act_result_address_o [ACC_NUM]
);
    wire                        acc_last [ACC_NUM + FA_NUM];
    wire                        acc_valid [ACC_NUM + FA_NUM];
    wire                        [DATA_WIDTH-1:0] acc_result [ACC_NUM + FA_NUM];
    wire                        [ADDRESS_WIDTH-1:0] acc_result_address [ACC_NUM];
    wire                        act_last [ACC_NUM + FA_NUM];
    wire                        act_valid [ACC_NUM + FA_NUM];
    wire                        [DATA_WIDTH-1:0] act_result [ACC_NUM + FA_NUM];
    wire                        [ADDRESS_WIDTH-1:0] act_result_address [ACC_NUM];
    
   genvar index;
    generate
        for (index=0; index<ACC_NUM; index++) begin
            Activation_sa u_act_sa(
                .clk(clk),
                .rst(rst),
                .acc_last_i(acc_last[index]),
                .acc_valid_i(acc_valid[index]),
                .acc_result_i(acc_result[index]),
                .acc_result_address_i(acc_result_address[index]),
                .act_last_o(act_last[index]),
                .act_valid_o(act_valid[index]),
                .act_result_o(act_result[index]),
                .act_result_address_o(act_result_address[index])
            );
        end
    endgenerate

    Activation_fc u_act_fc(
        .clk(clk),
        .rst(rst),
        .acc_last_i(acc_last[ACC_NUM]),
        .acc_valid_i(acc_valid[ACC_NUM]),
        .acc_result_i(acc_result[ACC_NUM]),
        .act_last_o(act_last[ACC_NUM]),
        .act_valid_o(act_valid[ACC_NUM]),
        .act_result_o(act_result[ACC_NUM])
    );

    assign acc_last                             = acc_last_i;
    assign acc_valid                            = acc_valid_i;
    assign acc_result                           = acc_result_i;
    assign acc_result_address                   = acc_result_address_i;
    assign act_last_o                           = act_last;
    assign act_valid_o                          = act_valid;
    assign act_result_o                         = act_result;
    assign act_result_address_o                 = act_result_address;

endmodule