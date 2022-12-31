`include "rams_sp_rf_rst.sv"

module ifmap_buf(
    input wire clk,
    input wire rst_n,

    input wire rden_i,
    input wire wren_i,
    input wire [6:0] rdptr_i,
    input wire [6:0] wrptr_i,

    input wire [7:0] ifmap_i,
    output wire [7:0] ifmap_o
);

    reg [6:0] addr;

    always_comb begin
        if(rden_i)
            addr = rdptr_i;
        else
            addr = wrptr_i;
    end
    
    rams_sp_rf_rst #(.SRAM_DEPTH(128), .DATA_WIDTH(8)) u_buf(
                .clk(clk),
                .en(rden_i),
                .we(wren_i),
                .rst_n(rst_n),
                .addr(addr),
                .di(ifmap_i),
                .dout(ifmap_o)
            );
endmodule