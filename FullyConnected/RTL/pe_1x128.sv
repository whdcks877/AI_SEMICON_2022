`include "pe.sv"

`define FC_SIZE 128

module pe_1x128(
    input wire clk,
    input wire rst_n,

    input wire [7:0] weight_i [`FC_SIZE],
    input wire pe_load_i,
    input wire [7:0] ifmap_i,

    output wire [7:0] psum_o,
    output wire [7:0] ifmap_o
);
    
    wire [7:0] psum [`FC_SIZE+1];
    wire [7:0] ifmap [`FC_SIZE+1];

    assign psum[0] = 8'b0;
    assign ifmap[0] = ifmap_i;
    assign psum_o = psum[`FC_SIZE];
    assign ifmap_o = ifmap[`FC_SIZE];

    genvar i;
    generate
        for(i=0; i<`FC_SIZE; i++) begin
            pe u_pe (
                .clk(clk),
                .rst_n(rst_n),
                .pe_load(pe_load_i),
                .psum_i(psum[i]),
                .weight_i(weight_i[i]),
                .ifmap_i(ifmap[i]),
                .psum_o(psum[i+1]),
                .ifmap_o(ifmap[i+1])
            );
        end
    endgenerate
endmodule