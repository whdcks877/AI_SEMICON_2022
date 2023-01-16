
module Data_fc_buff #
(
    parameter SRAM_DEPTH=1024,
    parameter BAND_WIDTH=1,
    parameter DATA_WIDTH=8
)
(
    input   wire  clk,
    input   wire  wea,                                      //write
    input   wire  enb,                                                  //read
    input   wire  [$clog2(SRAM_DEPTH)-1:0] addra,           //write   
    input   wire  [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addrb,    //read
    
    input   reg   [DATA_WIDTH-1:0]  dia,                    //write
    output  reg   [DATA_WIDTH-1:0]  dob                                 //read
);

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
                .wea                    (wea),
                .enb                    (enb),
                .addra                  (addra),
                .addrb                  (addrb[$clog2(SRAM_DEPTH)-1:0]),

                .dia                    (dia),
                .dob                    (dob)
            );
        end
    endgenerate
endmodule