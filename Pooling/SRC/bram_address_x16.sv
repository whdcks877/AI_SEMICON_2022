
module bram_address_counter_x16 #
(
    parameter SRAM_DEPTH=1024,
    parameter BAND_WIDTH=16,
    parameter DATA_WIDTH=10
)
(
    input     wire  clk,
    input     wire  rst,
    input     wire  enable[BAND_WIDTH],                                                                                  
    output    reg   [$clog2(SRAM_DEPTH)-1:0] address[BAND_WIDTH]
);

    genvar  i;
    generate
        for (i=0; i<BAND_WIDTH; i++) begin:  channel
            bram_address_counter #(
                .SRAM_DEPTH(SRAM_DEPTH),
                .DATA_WIDTH(DATA_WIDTH)
            )
            bram_address_counter
            (
                .clk                    (clk),
                .rst                    (rst),
                .enable                 (enable[i]),
                .address                (address[i])
            );
        end
    endgenerate
endmodule