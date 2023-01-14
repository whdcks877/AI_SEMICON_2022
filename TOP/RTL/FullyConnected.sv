`include "fc_controller.sv"
`include "FC_weight_buf.sv"
`include "ifmap_buf.sv"
`include "pe_1x120.sv"

module FullyConnected (
    input wire          clk,
    input wire          rst_n,

    input wire          start_i, //input after buffers are filled, FC operate start
    input wire [6:0]    in_node_num_i, //number of input node, 1~128
    input wire [6:0]    out_node_num_i, //number of output node, 1~84

    //write port  for weight buffer
    input wire          wbuf_wren_i,
    input wire [6:0]    wbuf_wrptr_i [`FC_SIZE],
    input wire [7:0]    wbuf_wdata_i [`FC_SIZE],

    //write port for ifmap buffer
    input wire          ifmap_wren_i,
    input wire [6:0]    ifmap_wrptr_i,
    input wire [7:0]    ifmap_wdata_i,

    //interface with activation
    output wire [7:0]   psum_o, //output node
    output wire         valid_o, //output node data is valiad
    output wire         last_o  //last data of output node

);
    wire        ifmap_rden;
    wire [6:0]  ifmap_rdptr;

    wire        wbuf_rden;
    wire [6:0]  wbuf_rdptr;
    wire        rst_buf_n;

    wire [7:0]  weight [`FC_SIZE];
    wire [7:0]  ifmap;

    wire        pe_load;

    fc_controller u_ctrl(
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i), 
        .in_node_num_i(in_node_num_i), 
        .out_node_num_i(out_node_num_i), 
        .ifmap_rden_o(ifmap_rden),
        .ifmap_rdptr_o(ifmap_rdptr),
        .wbuf_rden_o(wbuf_rden),
        .wbuf_rdptr_o(wbuf_rdptr),
        .rst_buf_n_o(rst_buf_n),
        .pe_load_o(pe_load),
        .valid_o(valid_o),
        .last_o(last_o)
    );

    fc_weight_buf u_wbuf(
        .clk(clk),
        .rst_n(rst_buf_n),
        .rst_all(rst_n),
        .rdptr_i(wbuf_rdptr),
        .wrptr_i(wbuf_wrptr_i),
        .rden_i(wbuf_rden),
        .wren_i(wbuf_wren_i),
        .weight_i(wbuf_wdata_i),
        .weight_o(weight)
    );

    ifmap_buf u_ifbuf(
        .clk(clk),
        .rst_n(rst_n),
        .rden_i(ifmap_rden),
        .wren_i(ifmap_wren_i),
        .rdptr_i(ifmap_rdptr),
        .wrptr_i(ifmap_wrptr_i),
        .ifmap_i(ifmap_wdata_i),
        .ifmap_o(ifmap)
    );

    pe_1x120 u_pe_arr(
        .clk(clk),
        .rst_n(rst_n),
        .weight_i(weight),
        .pe_load_i(ifmap_rden),
        .ifmap_i(ifmap),
        .psum_o(psum_o),
        .ifmap_o()
    );

endmodule