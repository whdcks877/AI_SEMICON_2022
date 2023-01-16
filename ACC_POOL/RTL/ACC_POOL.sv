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

    input wire                          sa_data_rden_i,
    input wire  [13:0]                  sa_data_rdptr_i,

    input wire                          fc_data_rden_i,
    input wire  [9:0]                   fc_data_rdptr_i,

    input wire                          pool_address_rden_i,
    input wire  [13:0]                  pool_address_rdptr_i,

    output wire [`DATA_WIDTH-1:0]       sa_data_rdata_o,
    output wire [`DATA_WIDTH-1:0]       fc_data_rdata_o,
    output wire [9:0]                   pool_address_rdata_o
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
        .enb_d_sa(sa_data_rden_i),                                                     //data(sa) bram read enable
        .addrb_d_sa(sa_data_rdptr_i),       //data(sa) bram read address
        .enb_d_fc(fc_data_rden_i),                                                     //data(fc) bram read enable
        .addrb_d_fc(fc_data_rdptr_i),                          //data(fc) bram read address
        .enb_a(pool_address_rden_i),                                                         //address bram read enable
        .addrb_a(pool_address_rdptr_i),           //address bram read address
        .dob_d_sa(sa_data_rdata_o),                                     //data(sa) bram output
        .dob_d_fc(fc_data_rdata_o),                                     //data(fc) bram output
        .dob_a(pool_address_rdata_o)                                         //address bram output
    );

endmodule