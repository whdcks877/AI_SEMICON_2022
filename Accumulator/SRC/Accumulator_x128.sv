`include "Accumulator.sv"

module Accumulator_x128(
    input clk,
    input rst_n,

    input [7:0] psum_i [128],
    input pvalid_i [128],
    output pready_o [128],

    input [9:0] ofmap_size_i,
    input [5:0] ifmap_ch_i,

    output wire conv_valid_o [128],
    output wire [7:0] conv_result_o [128]
);

    localparam N_COL = 128;

    wire [7:0] psum [N_COL];
    wire pvalid [N_COL];
    wire pready [N_COL];
    wire conv_valid [N_COL];
    wire [7:0] conv_result [N_COL];
    wire [9:0] ofmap_size;
    wire [5:0] ifmap_ch;

    assign ofmap_size = ofmap_size_i;
    assign ifmap_ch = ifmap_ch_i;

    genvar col;
    generate
        for (col=0; col<N_COL; col++) begin
           Accmulator u_acc(
                .clk(clk),
                .rst_n(rst_n),
                .psum_i(psum[col]),
                .pvaild_i(pvalid[col]),
                .pready_o(pready[col]),
                .ofmap_size(ofmap_size_i),
                .ifmap_ch(ifmap_ch_i),
                .conv_valid_o(conv_valid[col]),
                .conv_result_o(conv_result[col])
            );
        end
    endgenerate

    assign psum = psum_i;
    assign pvalid = pvalid_i;
    assign pready_o = pready;
    assign conv_valid_o = conv_valid;
    assign conv_result_o = conv_result;
endmodule