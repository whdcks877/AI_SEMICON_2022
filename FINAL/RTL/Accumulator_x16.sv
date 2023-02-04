`include "Accumulator.sv"

module Accumulator_x16(
    input clk,
    input rst_n,

    //interface with Systolic array
    input [31:0]     psum_i  [16],
    input           pvalid_i [16],
    output          pready_o [16],

    //interface with controller
    input [4:0]     ofmap_size_i, //size of output feature map, actual size of result is ofmap_size^2
    input [5:0]     ifmap_ch_i, //size of input feature map or input image

    //interface with activation
    output wire         conv_valid_o [16],
    output wire         conv_last_o [16],
    output wire [7:0]   conv_result_o [16], //final accumulation result 
    output wire [9:0]   addr_o  [16] //index of output result
);

    localparam N_COL = 16; //setting number of systolic array row

    wire [31:0]  psum [N_COL];
    wire        pvalid [N_COL];
    wire        pready [N_COL];
    wire        conv_valid [N_COL];
    wire [7:0]  conv_result [N_COL];
    wire [4:0]  ofmap_size;
    wire [5:0]  ifmap_ch;
    wire [9:0]  addr [N_COL];

    assign ofmap_size = ofmap_size_i;
    assign ifmap_ch = ifmap_ch_i;

    genvar col;
    generate
        for (col=0; col<N_COL; col++) begin
           Accumulator u_acc(
                .clk(clk),
                .rst_n(rst_n),
                .psum_i(psum[col]),
                .pvalid_i(pvalid[col]),
                .pready_o(pready[col]),
                .ofmap_size_i(ofmap_size_i),
                .ifmap_ch_i(ifmap_ch_i),
                .conv_valid_o(conv_valid[col]),
                .last_o(conv_last_o[col]),
                .conv_result_o(conv_result[col]),
                .addr_o(addr[col])
            );
        end
    endgenerate

    assign psum = psum_i;
    assign pvalid = pvalid_i;
    assign pready_o = pready;
    assign conv_valid_o = conv_valid;
    assign conv_result_o = conv_result;
    assign addr_o = addr;
endmodule