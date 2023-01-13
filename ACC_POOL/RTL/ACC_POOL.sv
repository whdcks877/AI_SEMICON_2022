`include "ACC_ACTIVE.sv"
`include "Top_ACPO.sv"

`define ACC_NUM              16
`define POOL_NUM             16
`define FA_NUM               1
`define ADDRESS_WIDTH        10
`define DATA_WIDTH           8
module ACC_POOL(
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

    output wire                         fc_last_o,
    output wire                         fc_valid_o,
    output wire [`DATA_WIDTH-1:0]        fc_result_o,

    output wire                         pool_last_o [`POOL_NUM],
    output wire                         pool_valid_o [`POOL_NUM],
    output wire [`DATA_WIDTH-1:0]        pool_result_o [`POOL_NUM],
    output wire [`ADDRESS_WIDTH-1:0]     pool_result_address_o [`POOL_NUM]
);

    wire                           act_last [`ACC_NUM  + `FA_NUM];
    wire                           act_valid [`ACC_NUM  + `FA_NUM];
    wire  [`DATA_WIDTH-1:0]        act_result [`ACC_NUM  + `FA_NUM];
    wire  [`ADDRESS_WIDTH-1:0]     act_result_address [`ACC_NUM];

 ACC_ACTIVE u_acc_active(
    .clk(clk),
    .rst_n(rst_n),
    .psum_i(psum_i),
    .pvalid_i(pvalid_i),
    .ofmap_size_i(ofmap_size_i),
    .ifmap_ch_i(ifmap_ch_i),
    .start_fc_i(start_fc_i),
    .in_node_num_i(in_node_num_i),
    .out_node_num_i(out_node_num_i),
    .wbuf_wren_i(wbuf_wren_i),
    .wbuf_wrptr_i(wbuf_wrptr_i),
    .wbuf_wdata_i(wbuf_wdata_i),
    .ifmap_wren_i(ifmap_wren_i),
    .ifmap_wrptr_i(ifmap_wrptr_i),
    .ifmap_wdata_i(ifmap_wdata_i),
    .act_last_o(act_last),
    .act_valid_o(act_valid),
    .act_result_o(act_result),
    .act_result_address_o(act_result_address)
    );

    Top_ACPO #(
        .ACC_NUM (16),
        .POOL_NUM (16),
        .FA_NUM (1),
        .ADDRESS_WIDTH (10),
        .DATA_WIDTH (8)
    ) u_acc_pool
    (
        .clk(clk),
        .rst(rst_n),
        .acc_last_i(act_last), 
        .acc_valid_i(act_valid),
        .acc_result_i(act_result),
        .acc_result_address_i(act_result_address),
        .act_last_o(fc_last_o),
        .act_valid_o(fc_valid_o),
        .act_result_o(fc_result_o),
        .pool_last_o(pool_last_o),
        .pool_valid_o(pool_valid_o),
        .pool_result_o(pool_result_o),
        .pool_result_address_o(pool_result_address_o)
    );

endmodule