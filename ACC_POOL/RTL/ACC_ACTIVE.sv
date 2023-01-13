`include "..\..\Accumulator\SRC\Accumulator_x16.sv"
`include "..\..\FullyConnected\RTL\FullyConnected.sv"

`define ACC_NUM 16
`define FA_NUM 1
`define ADDRESS_WIDTH 10
`define DATA_WIDTH 8

module ACC_ACTIVE(
    input wire                          clk,
    input wire                          rst_n,

    input wire  [7:0]                   psum_i [16],
    input wire                          pvalid_i [16],
    input wire  [4:0]                   ofmap_size_i,
    input wire  [5:0]                   ifmap_ch_i,

    input wire                          start_fc_i,
    input wire  [6:0]                   in_node_num_i,
    input wire  [6:0]                   out_node_num_i,

    input wire                          wbuf_wren_i,
    input wire  [6:0]                   wbuf_wrptr_i [`FC_SIZE],
    input wire  [7:0]                   wbuf_wdata_i [`FC_SIZE],

    input wire                          ifmap_wren_i,
    input wire  [6:0]                   ifmap_wrptr_i,
    input wire  [7:0]                   ifmap_wdata_i,

    output wire                          act_last_o [`ACC_NUM  + `FA_NUM],
    output wire                          act_valid_o [`ACC_NUM  + `FA_NUM],
    output wire  [`DATA_WIDTH-1:0]        act_result_o [`ACC_NUM  + `FA_NUM],
    output wire  [`ADDRESS_WIDTH-1:0]     act_result_address_o [`ACC_NUM]
);

    wire conv_valid [16];
    wire conv_last [16];
    wire [7:0] conv_result [16];
    wire [9:0] conv_addr [16];

    wire [7:0] psum_fc;
    wire valid_fc;
    wire last_fc;



    Accumulator_x16 u_acc16(
        .clk(clk),
        .rst_n(rst_n),    
        .psum_i (psum_i),
        .pvalid_i(pvalid_i),
        .pready_o(), //nc
        .ofmap_size_i(ofmap_size_i), 
        .ifmap_ch_i(ifmap_ch_i), 
        .conv_valid_o(conv_valid),
        .conv_last_o(conv_last),
        .conv_result_o(conv_result), 
        .addr_o(conv_addr)
    );

    FullyConnected u_fc (
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_fc_i), 
        .in_node_num_i(in_node_num_i), 
        .out_node_num_i(out_node_num_i), 
        .wbuf_wren_i(wbuf_wren_i),
        .wbuf_wrptr_i(wbuf_wrptr_i),
        .wbuf_wdata_i(wbuf_wdata_i),
        .ifmap_wren_i(ifmap_wren_i),
        .ifmap_wrptr_i(ifmap_wrptr_i),
        .ifmap_wdata_i(ifmap_wdata_i),
        .psum_o(psum_fc), 
        .valid_o(valid_fc), 
        .last_o(last_fc)  
    );

    Activation_x17 #( .ACC_NUM(`ACC_NUM), .FA_NUM(`FA_NUM), .ADDRESS_WIDTH(`ADDRESS_WIDTH), .DATA_WIDTH(`DATA_WIDTH)) 
        u_active (
        .clk(clk),
        .rst(rst_n),
        .acc_last_i({conv_last,last_fc}), 
        .acc_valid_i({conv_valid,valid_fc}),
        .acc_result_i({conv_result,psum_fc}),
        .acc_result_address_i(conv_addr),
        .act_last_o(act_last_o),
        .act_valid_o(act_valid_o),
        .act_result_o(act_result_o),
        .act_result_address_o(act_result_address_o) 
    ); 


endmodule