// Input Data Buff Unit
// 1 write port, multi read ports
// dual write-read

// Authors:
// - Sangmin Park
// v1.1
// Version Updated:
// - 20220106

module weight_bram #
(
    parameter SRAM_DEPTH=50,
    parameter BAND_WIDTH=16,
    parameter DATA_WIDTH=8
)
(
    input   wire  clk,
    input   wire  wea,
    input   wire  enb[BAND_WIDTH],
    input   wire  [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addra,         // MSB[$clog2(SRAM_DEPTH)+4:$clog2(SRAM_DEPTH)]: selecting which block among 25 BRAMs
    input   wire  [$clog2(SRAM_DEPTH)-1:0] addrb[BAND_WIDTH],                // LSB[$clog2(SRAM_DEPTH)-1:0]: selecting in one BRAM
    
    input   reg   [DATA_WIDTH-1:0]  dia,
    output  reg   [DATA_WIDTH-1:0]  dob[BAND_WIDTH]
);

    wire        [$clog2(BAND_WIDTH)-1:0]   BLOCK_NUMa = addra[$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:$clog2(SRAM_DEPTH)];

    genvar  i;
    generate
        for (i=0; i<BAND_WIDTH; i++) begin: channel
            simple_dual_one_clock #(
                .SRAM_DEPTH(SRAM_DEPTH),
                .DATA_WIDTH(DATA_WIDTH)
            )
            u_ram
            (
                .clk                    (clk),
                .wea                    (wea && (BLOCK_NUMa == i)),
        
                .enb                    (enb[i]),
                .addra                  (addra[$clog2(SRAM_DEPTH)-1:0]),
                .addrb                  (addrb[i]),

                .dia                    (dia),
                .dob                    (dob[i])
            );
        end
    endgenerate

endmodule