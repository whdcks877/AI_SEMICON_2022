`include "pe_fc.sv"

`define FC_SIZE 120

module pe_1x120(
    input wire          clk,
    input wire          rst_n,

    input wire [7:0]    weight_i [`FC_SIZE],
    input wire          pe_load_i,
    input wire [7:0]    ifmap_i,

    output wire [31:0]   psum_o,
    output wire [7:0]   ifmap_o
);
    
    wire [31:0] psum [`FC_SIZE+1];
    wire [7:0] ifmap [`FC_SIZE+1];

    reg pe_load_d;

    always_ff @(posedge clk) begin
        pe_load_d <= pe_load_i;
    end

    assign psum[0] = 32'b0;
    assign ifmap[0] = ifmap_i;
    assign psum_o = psum[`FC_SIZE];
    assign ifmap_o = ifmap[`FC_SIZE];

    genvar i;
    generate
        for(i=0; i<`FC_SIZE; i++) begin
            pe_fc u_pe (
                .clk(clk),
                .rst_n(rst_n),
                .pe_load(pe_load_d),
                .psum_i(psum[i]),
                .weight_i(weight_i[i]),
                .ifmap_i(ifmap[i]),
                .psum_o(psum[i+1]),
                .ifmap_o(ifmap[i+1])
            );
        end
    endgenerate
endmodule