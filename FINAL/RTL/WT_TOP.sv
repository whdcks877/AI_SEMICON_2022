//version 2022-01-19
//editor IM SUHYEOK

module WT_TOP #(
    parameter SRAM_DEPTH        = 256,
    parameter BAND_DT_WIDTH     = 25,
    parameter BAND_WT_WIDTH     = 16,
    parameter DATA_WIDTH        = 8
)
(
    input   wire                        clk,
    input   wire                        rst_n,
    input   wire                        start_i,
    input   wire                        [1:0] nth_conv_i,
    input   wire                        burst_last_i,
    input   wire                        [DATA_WIDTH-1:0] data_i[BAND_DT_WIDTH-1:0],
    input   wire                        wea,
    input   wire                        [DATA_WIDTH-1:0] dia,
    input   wire                        [11:0] addra,
    input   wire                        data_valid_i[BAND_DT_WIDTH-1:0],
    input   wire                        conv_done_i,

    output  wire                        data_enable_o,
    output  wire                        [31:0] accu_data_o[BAND_WT_WIDTH-1:0],
    output  wire                        accu_valid_o [BAND_WT_WIDTH-1:0]
);

    wire            weight_start;
    wire            weight_stop;
    wire            w_enable[BAND_WT_WIDTH-1:0];
    wire            [DATA_WIDTH-1:0] w_addr[BAND_WT_WIDTH-1:0];
    wire            [DATA_WIDTH-1:0] w_data_1[BAND_WT_WIDTH-1:0];
    wire            [DATA_WIDTH-1:0] w_data_2[BAND_WT_WIDTH-1:0];
    wire            [3:0] cnt2;


    SA_ctrl u_sa_ctrl(
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i),
        .data_last_i(burst_last_i),
        .nth_conv_i(nth_conv_i),
        .conv_done_i(conv_done_i),
        .data_enable_o(data_enable_o),
        .weight_start_o(weight_start),
        .weight_stop_o(weight_stop),
        .cnt2_o(cnt2)
    );
    
    SA u_sa(
        .clk(clk),
        .rst_n(rst_n),
        .data_i(data_i),
        .d_valid_i(data_valid_i[0]||data_valid_i[24]),
        .burst_last_i(burst_last_i),
        .weight_i(w_data_2),
        .nth_conv_i(nth_conv_i),
        .weight_stop(weight_stop),
        .accu_data_o(accu_data_o),
        .accu_valid(accu_valid_o)
    );

    weight_buffer u_weight_buffer(
        .clk(clk),
        .rst_n(rst_n),
        .burst_last_i(burst_last_i),
        .nth_conv_i(nth_conv_i),
        .weight_start_i(weight_start),
        .w_data_i(w_data_1),
        .conv_done_i(conv_done_i),
        .w_enable_o(w_enable),
        .w_addr_o(w_addr),
        .w_data_o(w_data_2),
        .cnt2(cnt2)
    );
    //MSB 4bit => column, LSB 8bit => row
    weight_bram u_weight_bram(
        .clk(clk),
        .wea(wea),
        .enb(w_enable),
        .addra(addra[11:0]),
        .addrb(w_addr),
        .dia(dia),
        .dob(w_data_1)
    );
endmodule