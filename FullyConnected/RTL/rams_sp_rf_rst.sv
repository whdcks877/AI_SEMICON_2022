module rams_sp_rf_rst#(
    parameter SRAM_DEPTH=1024,
    parameter DATA_WIDTH=  32
)
(
    input wire  clk,
    input wire  en,
    input wire  we,
    input wire rst_n,
    input wire  [$clog2(SRAM_DEPTH)-1:0] addr,
    input wire   [DATA_WIDTH-1:0]  di,
    output reg  [DATA_WIDTH-1:0]  dout
);

    reg [DATA_WIDTH-1:0] ram [SRAM_DEPTH];

always @(posedge clk) begin
    if(!rst_n) begin
        dout <= 0;
    end else if(en) begin
        dout <= ram[addr];
    end else if(we) begin
        ram[addr] <= di;
    end 
end
endmodule