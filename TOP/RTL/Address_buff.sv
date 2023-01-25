
module Address_buff #
(
    parameter SRAM_DEPTH=1024,
    parameter BAND_WIDTH=16,
    parameter DATA_WIDTH=10
)
(
    input   wire  clk,
    input   wire  wea[BAND_WIDTH],
    input   wire  enb,
    input   wire  [$clog2(SRAM_DEPTH)-1:0] addra[BAND_WIDTH],                    
    input   wire  [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addrb,          
    
    input   reg   [DATA_WIDTH-1:0]  dia[BAND_WIDTH],
    output  reg   [DATA_WIDTH-1:0]  dob
);

    wire        [$clog2(BAND_WIDTH)-1:0]   BLOCK_NUMa = addrb[$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:$clog2(SRAM_DEPTH)];
    wire        nc;
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
                .wea                    (wea[i]),
                .enb                    (enb && (BLOCK_NUMa == i)),
                .addra                  (addra[i]),
                .addrb                  (addrb[$clog2(SRAM_DEPTH)-1:0]),

                .dia                    (dia[i]),
                .dob                    (nc)
            );
        end
    endgenerate

    assign dob = 10'b0;
endmodule