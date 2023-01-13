// DATA_INPUT_TOP Unit
// include BUFF_INPUT.sv, DATA_SETUP.sv

// Authors:
// - Sangmin Park
// v2.1
// Version Updated:
// - 20220114

module DATAINPUT_TOP #
(
    parameter SRAM_DEPTH=1176,
    parameter BAND_WIDTH=25,
    parameter DATA_WIDTH=8
)
(
    input   wire                clk,
    input   wire                rst,

    //BUFFER write
    input   wire                wea,
    input   wire    [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addra,         // LSB[$clog2(SRAM_DEPTH)-1:0]: selecting in one BRAM
    input   wire    [DATA_WIDTH-1:0]  dia,

    //DATA Setup
    input   wire        [10:0]              BURST_SIZE,
    input   wire        [4:0]               ofmap_size_i,
    input   wire                            weight_ready_i,
    output  wire                            data_valid_o[BAND_WIDTH],   // SETUP >> SA valid
    output  wire        [DATA_WIDTH-1:0]    sa_data_o[BAND_WIDTH],      // SETUP >> SA data
    output  wire                            burst_last_o    
);

    wire            [DATA_WIDTH-1:0]        dob[BAND_WIDTH];
    wire                                    enb[BAND_WIDTH];
    wire            [$clog2(SRAM_DEPTH)-1:0] addrb[BAND_WIDTH];


    BUFF_INPUT #
    (
        .SRAM_DEPTH(SRAM_DEPTH)
    )
    u_buff(
        .clk                        (clk),
        .wea                        (wea),
        .enb                        (enb),
        .addra                      (addra),
        .addrb                      (addrb),
        .dia                        (dia),
        .dob                        (dob)
    );


    DATA_SETUP #
    (
        .SRAM_DEPTH(SRAM_DEPTH)
    )
    u_setup(
        .clk                        (clk),
        .rst                        (rst),
        .BURST_SIZE                 (BURST_SIZE),
        .ofmap_size_i               (ofmap_size_i),
        .buff_data_i                (dob),
        .setup_ready_o              (enb),
        .buff_addr_o                (addrb),

        .weight_ready_i             (weight_ready_i),
        .data_valid_o               (data_valid_o),
        .sa_data_o                  (sa_data_o),
        .burst_last_o               (burst_last_o)
    );




endmodule
