module Activation_x16 #(
    parameter       ACC_NUM             = 16,
    parameter       DATA_WIDTH          = 8
)
(
    input                       clk,
    input                       rst,
    
    input                       acc_last_i [ACC_NUM], 
    input                       acc_valid_i [ACC_NUM],
    //output  wire                act_ready_o [ACC_NUM],
    input                       [DATA_WIDTH-1:0] acc_result_i [ACC_NUM],

    output                      act_last_o [ACC_NUM],
    output                      act_valid_o [ACC_NUM],
    //input   wire                pool_ready_i [ACC_NUM],
    output                      [DATA_WIDTH-1:0] act_result_o [ACC_NUM]
);
    wire                        acc_last [ACC_NUM];
    wire                        acc_valid [ACC_NUM];
    wire                        [DATA_WIDTH-1:0] acc_result [ACC_NUM];
    wire                        act_last [ACC_NUM];
    wire                        act_valid [ACC_NUM];
    wire                        [DATA_WIDTH-1:0] act_result [ACC_NUM];
    
   genvar index;
    generate
        for (index=0; index<ACC_NUM; index++) begin
            Activation u_act(
                .clk(clk),
                .rst(rst),
                .acc_last_i(acc_last[index]),
                .acc_valid_i(acc_valid[index]),
                .acc_result_i(acc_result[index]),
                .act_last_o(act_last[index]),
                .act_valid_o(act_valid[index]),
                .act_result_o(act_result[index])
            );
        end
    endgenerate

    assign acc_last             = acc_last_i;
    assign acc_valid            = acc_valid_i;
    assign acc_result           = acc_result_i;
    assign act_last_o           = act_last;
    assign act_valid_o          = act_valid;
    assign act_result_o         = act_result;

endmodule