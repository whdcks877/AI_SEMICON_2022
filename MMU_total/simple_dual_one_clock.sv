// Simple Dual-Port Block RAM with One Clock\
// File: simple_dual_one_clock.v

module simple_dual_one_clock #
(
    parameter SRAM_DEPTH=1024,
    parameter DATA_WIDTH=  8
)
(
    input wire  clk,
    input wire  wea,
    input wire  enb,
    input wire  [$clog2(SRAM_DEPTH)-1:0] addra,
    input wire  [$clog2(SRAM_DEPTH)-1:0] addrb,
    
    input reg   [DATA_WIDTH-1:0]  dia,
    output reg  [DATA_WIDTH-1:0]  dob
);

reg [DATA_WIDTH-1:0] ram [SRAM_DEPTH];

always @(posedge clk) begin
    if (wea)
        ram[addra] <= dia;
end

always @(posedge clk) begin
    if(enb)
        dob <= ram[addrb];
end
endmodule