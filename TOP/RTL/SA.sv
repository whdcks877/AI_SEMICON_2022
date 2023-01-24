// Systolic Array
// JY Lee
// Version 2023-01-11 1st verified
// 2023-01-12 2nd verified
// 2023-01-13 3rd verified by JY Lee

module SA
(
    input   wire                clk,
    input   wire                rst_n,

    //DATA part interface
    input   wire    [7:0]       data_i[24:0],   //temporary 32bit data, TODO: change size
    // output  wire                dready_o,
    input   wire                d_valid_i,
    input   wire                burst_last_i,

    //Weight part interface(weight buffer)
    input   wire    [7:0]       weight_i[15:0],    //temporary 32bit, 25X16 SA Matrix size

    //ctrl interface
    input   wire                weight_stop,
    input   wire    [1:0]       nth_conv_i,
    //accumulator interface
    output  reg     [15:0]       accu_data_o[15:0],
    output  reg                 accu_valid[15:0]
);
    reg     [15:0]      zero = 'd0;
    wire    [7:0]      data_o[24:0][15:0];
    wire    [15:0]      sum_o[24:0][15:0];
    reg     [7:0]      weight_o[24:0][15:0];
    reg     [4:0]      cnt,     cnt_n;
    reg                accu_valid_n;
//SA Architecture
    //'0'th row
    PE u_pe0_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[0]),
        //Up part
        .weight_i(weight_i[0]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][0]),
        //Down part
        .weight_o(weight_o[0][0]),
        .sum_o(sum_o[0][0])
    );

    PE u_pe0_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][0]),
        //Up part
        .weight_i(weight_i[1]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][1]),
        //Down part
        .weight_o(weight_o[0][1]),
        .sum_o(sum_o[0][1])
    );

    PE u_pe0_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][1]),
        //Up part
        .weight_i(weight_i[2]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][2]),
        //Down part
        .weight_o(weight_o[0][2]),
        .sum_o(sum_o[0][2])
    );

    PE u_pe0_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][2]),
        //Up part
        .weight_i(weight_i[3]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][3]),
        //Down part
        .weight_o(weight_o[0][3]),
        .sum_o(sum_o[0][3])
    );

    PE u_pe0_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][3]),
        //Up part
        .weight_i(weight_i[4]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][4]),
        //Down part
        .weight_o(weight_o[0][4]),
        .sum_o(sum_o[0][4])
    );

    PE u_pe0_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][4]),
        //Up part
        .weight_i(weight_i[5]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][5]),
        //Down part
        .weight_o(weight_o[0][5]),
        .sum_o(sum_o[0][5])
    );

    PE u_pe0_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][5]),
        //Up part
        .weight_i(weight_i[6]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][6]),
        //Down part
        .weight_o(weight_o[0][6]),
        .sum_o(sum_o[0][6])
    );

    PE u_pe0_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][6]),
        //Up part
        .weight_i(weight_i[7]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][7]),
        //Down part
        .weight_o(weight_o[0][7]),
        .sum_o(sum_o[0][7])
    );

    PE u_pe0_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][7]),
        //Up part
        .weight_i(weight_i[8]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][8]),
        //Down part
        .weight_o(weight_o[0][8]),
        .sum_o(sum_o[0][8])
    );

    PE u_pe0_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][8]),
        //Up part
        .weight_i(weight_i[9]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][9]),
        //Down part
        .weight_o(weight_o[0][9]),
        .sum_o(sum_o[0][9])
    );

    PE u_pe0_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][9]),
        //Up part
        .weight_i(weight_i[10]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][10]),
        //Down part
        .weight_o(weight_o[0][10]),
        .sum_o(sum_o[0][10])
    );

    PE u_pe0_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][10]),
        //Up part
        .weight_i(weight_i[11]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][11]),
        //Down part
        .weight_o(weight_o[0][11]),
        .sum_o(sum_o[0][11])
    );

    PE u_pe0_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][11]),
        //Up part
        .weight_i(weight_i[12]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][12]),
        //Down part
        .weight_o(weight_o[0][12]),
        .sum_o(sum_o[0][12])
    );

    PE u_pe0_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][12]),
        //Up part
        .weight_i(weight_i[13]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][13]),
        //Down part
        .weight_o(weight_o[0][13]),
        .sum_o(sum_o[0][13])
    );

    PE u_pe0_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][13]),
        //Up part
        .weight_i(weight_i[14]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][14]),
        //Down part
        .weight_o(weight_o[0][14]),
        .sum_o(sum_o[0][14])
    );

    PE u_pe0_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[0][14]),
        //Up part
        .weight_i(weight_i[15]),
        .sum_i(zero),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[0][15]),
        //Down part
        .weight_o(weight_o[0][15]),
        .sum_o(sum_o[0][15])
    );

    //'1'th row
    PE u_pe1_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[1]),
        //Up part
        .weight_i(weight_o[0][0]),
        .sum_i(sum_o[0][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][0]),
        //Down part
        .weight_o(weight_o[1][0]),
        .sum_o(sum_o[1][0])
    );

    PE u_pe1_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][0]),
        //Up part
        .weight_i(weight_o[0][1]),
        .sum_i(sum_o[0][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][1]),
        //Down part
        .weight_o(weight_o[1][1]),
        .sum_o(sum_o[1][1])
    );

    PE u_pe1_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][1]),
        //Up part
        .weight_i(weight_o[0][2]),
        .sum_i(sum_o[0][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][2]),
        //Down part
        .weight_o(weight_o[1][2]),
        .sum_o(sum_o[1][2])
    );

    PE u_pe1_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][2]),
        //Up part
        .weight_i(weight_o[0][3]),
        .sum_i(sum_o[0][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][3]),
        //Down part
        .weight_o(weight_o[1][3]),
        .sum_o(sum_o[1][3])
    );

    PE u_pe1_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][3]),
        //Up part
        .weight_i(weight_o[0][4]),
        .sum_i(sum_o[0][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][4]),
        //Down part
        .weight_o(weight_o[1][4]),
        .sum_o(sum_o[1][4])
    );

    PE u_pe1_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][4]),
        //Up part
        .weight_i(weight_o[0][5]),
        .sum_i(sum_o[0][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][5]),
        //Down part
        .weight_o(weight_o[1][5]),
        .sum_o(sum_o[1][5])
    );

    PE u_pe1_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][5]),
        //Up part
        .weight_i(weight_o[0][6]),
        .sum_i(sum_o[0][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][6]),
        //Down part
        .weight_o(weight_o[1][6]),
        .sum_o(sum_o[1][6])
    );

    PE u_pe1_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][6]),
        //Up part
        .weight_i(weight_o[0][7]),
        .sum_i(sum_o[0][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][7]),
        //Down part
        .weight_o(weight_o[1][7]),
        .sum_o(sum_o[1][7])
    );

    PE u_pe1_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][7]),
        //Up part
        .weight_i(weight_o[0][8]),
        .sum_i(sum_o[0][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][8]),
        //Down part
        .weight_o(weight_o[1][8]),
        .sum_o(sum_o[1][8])
    );

    PE u_pe1_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][8]),
        //Up part
        .weight_i(weight_o[0][9]),
        .sum_i(sum_o[0][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][9]),
        //Down part
        .weight_o(weight_o[1][9]),
        .sum_o(sum_o[1][9])
    );

    PE u_pe1_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][9]),
        //Up part
        .weight_i(weight_o[0][10]),
        .sum_i(sum_o[0][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][10]),
        //Down part
        .weight_o(weight_o[1][10]),
        .sum_o(sum_o[1][10])
    );

    PE u_pe1_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][10]),
        //Up part
        .weight_i(weight_o[0][11]),
        .sum_i(sum_o[0][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][11]),
        //Down part
        .weight_o(weight_o[1][11]),
        .sum_o(sum_o[1][11])
    );

    PE u_pe1_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][11]),
        //Up part
        .weight_i(weight_o[0][12]),
        .sum_i(sum_o[0][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][12]),
        //Down part
        .weight_o(weight_o[1][12]),
        .sum_o(sum_o[1][12])
    );

    PE u_pe1_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][12]),
        //Up part
        .weight_i(weight_o[0][13]),
        .sum_i(sum_o[0][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][13]),
        //Down part
        .weight_o(weight_o[1][13]),
        .sum_o(sum_o[1][13])
    );

    PE u_pe1_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][13]),
        //Up part
        .weight_i(weight_o[0][14]),
        .sum_i(sum_o[0][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][14]),
        //Down part
        .weight_o(weight_o[1][14]),
        .sum_o(sum_o[1][14])
    );

    PE u_pe1_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[1][14]),
        //Up part
        .weight_i(weight_o[0][15]),
        .sum_i(sum_o[0][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[1][15]),
        //Down part
        .weight_o(weight_o[1][15]),
        .sum_o(sum_o[1][15])
    );

    //'2'th row
    PE u_pe2_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[2]),
        //Up part
        .weight_i(weight_o[1][0]),
        .sum_i(sum_o[1][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][0]),
        //Down part
        .weight_o(weight_o[2][0]),
        .sum_o(sum_o[2][0])
    );

    PE u_pe2_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][0]),
        //Up part
        .weight_i(weight_o[1][1]),
        .sum_i(sum_o[1][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][1]),
        //Down part
        .weight_o(weight_o[2][1]),
        .sum_o(sum_o[2][1])
    );

    PE u_pe2_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][1]),
        //Up part
        .weight_i(weight_o[1][2]),
        .sum_i(sum_o[1][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][2]),
        //Down part
        .weight_o(weight_o[2][2]),
        .sum_o(sum_o[2][2])
    );

    PE u_pe2_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][2]),
        //Up part
        .weight_i(weight_o[1][3]),
        .sum_i(sum_o[1][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][3]),
        //Down part
        .weight_o(weight_o[2][3]),
        .sum_o(sum_o[2][3])
    );

    PE u_pe2_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][3]),
        //Up part
        .weight_i(weight_o[1][4]),
        .sum_i(sum_o[1][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][4]),
        //Down part
        .weight_o(weight_o[2][4]),
        .sum_o(sum_o[2][4])
    );

    PE u_pe2_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][4]),
        //Up part
        .weight_i(weight_o[1][5]),
        .sum_i(sum_o[1][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][5]),
        //Down part
        .weight_o(weight_o[2][5]),
        .sum_o(sum_o[2][5])
    );

    PE u_pe2_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][5]),
        //Up part
        .weight_i(weight_o[1][6]),
        .sum_i(sum_o[1][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][6]),
        //Down part
        .weight_o(weight_o[2][6]),
        .sum_o(sum_o[2][6])
    );

    PE u_pe2_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][6]),
        //Up part
        .weight_i(weight_o[1][7]),
        .sum_i(sum_o[1][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][7]),
        //Down part
        .weight_o(weight_o[2][7]),
        .sum_o(sum_o[2][7])
    );

    PE u_pe2_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][7]),
        //Up part
        .weight_i(weight_o[1][8]),
        .sum_i(sum_o[1][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][8]),
        //Down part
        .weight_o(weight_o[2][8]),
        .sum_o(sum_o[2][8])
    );

    PE u_pe2_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][8]),
        //Up part
        .weight_i(weight_o[1][9]),
        .sum_i(sum_o[1][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][9]),
        //Down part
        .weight_o(weight_o[2][9]),
        .sum_o(sum_o[2][9])
    );

    PE u_pe2_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][9]),
        //Up part
        .weight_i(weight_o[1][10]),
        .sum_i(sum_o[1][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][10]),
        //Down part
        .weight_o(weight_o[2][10]),
        .sum_o(sum_o[2][10])
    );

    PE u_pe2_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][10]),
        //Up part
        .weight_i(weight_o[1][11]),
        .sum_i(sum_o[1][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][11]),
        //Down part
        .weight_o(weight_o[2][11]),
        .sum_o(sum_o[2][11])
    );

    PE u_pe2_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][11]),
        //Up part
        .weight_i(weight_o[1][12]),
        .sum_i(sum_o[1][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][12]),
        //Down part
        .weight_o(weight_o[2][12]),
        .sum_o(sum_o[2][12])
    );

    PE u_pe2_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][12]),
        //Up part
        .weight_i(weight_o[1][13]),
        .sum_i(sum_o[1][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][13]),
        //Down part
        .weight_o(weight_o[2][13]),
        .sum_o(sum_o[2][13])
    );

    PE u_pe2_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][13]),
        //Up part
        .weight_i(weight_o[1][14]),
        .sum_i(sum_o[1][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][14]),
        //Down part
        .weight_o(weight_o[2][14]),
        .sum_o(sum_o[2][14])
    );

    PE u_pe2_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[2][14]),
        //Up part
        .weight_i(weight_o[1][15]),
        .sum_i(sum_o[1][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[2][15]),
        //Down part
        .weight_o(weight_o[2][15]),
        .sum_o(sum_o[2][15])
    );

    //'3'th row
    PE u_pe3_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[3]),
        //Up part
        .weight_i(weight_o[2][0]),
        .sum_i(sum_o[2][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][0]),
        //Down part
        .weight_o(weight_o[3][0]),
        .sum_o(sum_o[3][0])
    );

    PE u_pe3_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][0]),
        //Up part
        .weight_i(weight_o[2][1]),
        .sum_i(sum_o[2][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][1]),
        //Down part
        .weight_o(weight_o[3][1]),
        .sum_o(sum_o[3][1])
    );

    PE u_pe3_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][1]),
        //Up part
        .weight_i(weight_o[2][2]),
        .sum_i(sum_o[2][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][2]),
        //Down part
        .weight_o(weight_o[3][2]),
        .sum_o(sum_o[3][2])
    );

    PE u_pe3_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][2]),
        //Up part
        .weight_i(weight_o[2][3]),
        .sum_i(sum_o[2][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][3]),
        //Down part
        .weight_o(weight_o[3][3]),
        .sum_o(sum_o[3][3])
    );

    PE u_pe3_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][3]),
        //Up part
        .weight_i(weight_o[2][4]),
        .sum_i(sum_o[2][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][4]),
        //Down part
        .weight_o(weight_o[3][4]),
        .sum_o(sum_o[3][4])
    );

    PE u_pe3_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][4]),
        //Up part
        .weight_i(weight_o[2][5]),
        .sum_i(sum_o[2][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][5]),
        //Down part
        .weight_o(weight_o[3][5]),
        .sum_o(sum_o[3][5])
    );

    PE u_pe3_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][5]),
        //Up part
        .weight_i(weight_o[2][6]),
        .sum_i(sum_o[2][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][6]),
        //Down part
        .weight_o(weight_o[3][6]),
        .sum_o(sum_o[3][6])
    );

    PE u_pe3_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][6]),
        //Up part
        .weight_i(weight_o[2][7]),
        .sum_i(sum_o[2][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][7]),
        //Down part
        .weight_o(weight_o[3][7]),
        .sum_o(sum_o[3][7])
    );

    PE u_pe3_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][7]),
        //Up part
        .weight_i(weight_o[2][8]),
        .sum_i(sum_o[2][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][8]),
        //Down part
        .weight_o(weight_o[3][8]),
        .sum_o(sum_o[3][8])
    );

    PE u_pe3_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][8]),
        //Up part
        .weight_i(weight_o[2][9]),
        .sum_i(sum_o[2][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][9]),
        //Down part
        .weight_o(weight_o[3][9]),
        .sum_o(sum_o[3][9])
    );

    PE u_pe3_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][9]),
        //Up part
        .weight_i(weight_o[2][10]),
        .sum_i(sum_o[2][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][10]),
        //Down part
        .weight_o(weight_o[3][10]),
        .sum_o(sum_o[3][10])
    );

    PE u_pe3_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][10]),
        //Up part
        .weight_i(weight_o[2][11]),
        .sum_i(sum_o[2][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][11]),
        //Down part
        .weight_o(weight_o[3][11]),
        .sum_o(sum_o[3][11])
    );

    PE u_pe3_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][11]),
        //Up part
        .weight_i(weight_o[2][12]),
        .sum_i(sum_o[2][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][12]),
        //Down part
        .weight_o(weight_o[3][12]),
        .sum_o(sum_o[3][12])
    );

    PE u_pe3_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][12]),
        //Up part
        .weight_i(weight_o[2][13]),
        .sum_i(sum_o[2][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][13]),
        //Down part
        .weight_o(weight_o[3][13]),
        .sum_o(sum_o[3][13])
    );

    PE u_pe3_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][13]),
        //Up part
        .weight_i(weight_o[2][14]),
        .sum_i(sum_o[2][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][14]),
        //Down part
        .weight_o(weight_o[3][14]),
        .sum_o(sum_o[3][14])
    );

    PE u_pe3_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[3][14]),
        //Up part
        .weight_i(weight_o[2][15]),
        .sum_i(sum_o[2][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[3][15]),
        //Down part
        .weight_o(weight_o[3][15]),
        .sum_o(sum_o[3][15])
    );

    //'4'th row
    PE u_pe4_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[4]),
        //Up part
        .weight_i(weight_o[3][0]),
        .sum_i(sum_o[3][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][0]),
        //Down part
        .weight_o(weight_o[4][0]),
        .sum_o(sum_o[4][0])
    );

    PE u_pe4_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][0]),
        //Up part
        .weight_i(weight_o[3][1]),
        .sum_i(sum_o[3][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][1]),
        //Down part
        .weight_o(weight_o[4][1]),
        .sum_o(sum_o[4][1])
    );

    PE u_pe4_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][1]),
        //Up part
        .weight_i(weight_o[3][2]),
        .sum_i(sum_o[3][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][2]),
        //Down part
        .weight_o(weight_o[4][2]),
        .sum_o(sum_o[4][2])
    );

    PE u_pe4_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][2]),
        //Up part
        .weight_i(weight_o[3][3]),
        .sum_i(sum_o[3][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][3]),
        //Down part
        .weight_o(weight_o[4][3]),
        .sum_o(sum_o[4][3])
    );

    PE u_pe4_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][3]),
        //Up part
        .weight_i(weight_o[3][4]),
        .sum_i(sum_o[3][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][4]),
        //Down part
        .weight_o(weight_o[4][4]),
        .sum_o(sum_o[4][4])
    );

    PE u_pe4_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][4]),
        //Up part
        .weight_i(weight_o[3][5]),
        .sum_i(sum_o[3][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][5]),
        //Down part
        .weight_o(weight_o[4][5]),
        .sum_o(sum_o[4][5])
    );

    PE u_pe4_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][5]),
        //Up part
        .weight_i(weight_o[3][6]),
        .sum_i(sum_o[3][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][6]),
        //Down part
        .weight_o(weight_o[4][6]),
        .sum_o(sum_o[4][6])
    );

    PE u_pe4_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][6]),
        //Up part
        .weight_i(weight_o[3][7]),
        .sum_i(sum_o[3][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][7]),
        //Down part
        .weight_o(weight_o[4][7]),
        .sum_o(sum_o[4][7])
    );

    PE u_pe4_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][7]),
        //Up part
        .weight_i(weight_o[3][8]),
        .sum_i(sum_o[3][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][8]),
        //Down part
        .weight_o(weight_o[4][8]),
        .sum_o(sum_o[4][8])
    );

    PE u_pe4_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][8]),
        //Up part
        .weight_i(weight_o[3][9]),
        .sum_i(sum_o[3][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][9]),
        //Down part
        .weight_o(weight_o[4][9]),
        .sum_o(sum_o[4][9])
    );

    PE u_pe4_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][9]),
        //Up part
        .weight_i(weight_o[3][10]),
        .sum_i(sum_o[3][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][10]),
        //Down part
        .weight_o(weight_o[4][10]),
        .sum_o(sum_o[4][10])
    );

    PE u_pe4_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][10]),
        //Up part
        .weight_i(weight_o[3][11]),
        .sum_i(sum_o[3][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][11]),
        //Down part
        .weight_o(weight_o[4][11]),
        .sum_o(sum_o[4][11])
    );

    PE u_pe4_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][11]),
        //Up part
        .weight_i(weight_o[3][12]),
        .sum_i(sum_o[3][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][12]),
        //Down part
        .weight_o(weight_o[4][12]),
        .sum_o(sum_o[4][12])
    );

    PE u_pe4_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][12]),
        //Up part
        .weight_i(weight_o[3][13]),
        .sum_i(sum_o[3][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][13]),
        //Down part
        .weight_o(weight_o[4][13]),
        .sum_o(sum_o[4][13])
    );

    PE u_pe4_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][13]),
        //Up part
        .weight_i(weight_o[3][14]),
        .sum_i(sum_o[3][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][14]),
        //Down part
        .weight_o(weight_o[4][14]),
        .sum_o(sum_o[4][14])
    );

    PE u_pe4_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[4][14]),
        //Up part
        .weight_i(weight_o[3][15]),
        .sum_i(sum_o[3][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[4][15]),
        //Down part
        .weight_o(weight_o[4][15]),
        .sum_o(sum_o[4][15])
    );

    //'5'th row
    PE u_pe5_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[5]),
        //Up part
        .weight_i(weight_o[4][0]),
        .sum_i(sum_o[4][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][0]),
        //Down part
        .weight_o(weight_o[5][0]),
        .sum_o(sum_o[5][0])
    );

    PE u_pe5_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][0]),
        //Up part
        .weight_i(weight_o[4][1]),
        .sum_i(sum_o[4][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][1]),
        //Down part
        .weight_o(weight_o[5][1]),
        .sum_o(sum_o[5][1])
    );

    PE u_pe5_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][1]),
        //Up part
        .weight_i(weight_o[4][2]),
        .sum_i(sum_o[4][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][2]),
        //Down part
        .weight_o(weight_o[5][2]),
        .sum_o(sum_o[5][2])
    );

    PE u_pe5_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][2]),
        //Up part
        .weight_i(weight_o[4][3]),
        .sum_i(sum_o[4][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][3]),
        //Down part
        .weight_o(weight_o[5][3]),
        .sum_o(sum_o[5][3])
    );

    PE u_pe5_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][3]),
        //Up part
        .weight_i(weight_o[4][4]),
        .sum_i(sum_o[4][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][4]),
        //Down part
        .weight_o(weight_o[5][4]),
        .sum_o(sum_o[5][4])
    );

    PE u_pe5_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][4]),
        //Up part
        .weight_i(weight_o[4][5]),
        .sum_i(sum_o[4][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][5]),
        //Down part
        .weight_o(weight_o[5][5]),
        .sum_o(sum_o[5][5])
    );

    PE u_pe5_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][5]),
        //Up part
        .weight_i(weight_o[4][6]),
        .sum_i(sum_o[4][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][6]),
        //Down part
        .weight_o(weight_o[5][6]),
        .sum_o(sum_o[5][6])
    );

    PE u_pe5_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][6]),
        //Up part
        .weight_i(weight_o[4][7]),
        .sum_i(sum_o[4][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][7]),
        //Down part
        .weight_o(weight_o[5][7]),
        .sum_o(sum_o[5][7])
    );

    PE u_pe5_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][7]),
        //Up part
        .weight_i(weight_o[4][8]),
        .sum_i(sum_o[4][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][8]),
        //Down part
        .weight_o(weight_o[5][8]),
        .sum_o(sum_o[5][8])
    );

    PE u_pe5_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][8]),
        //Up part
        .weight_i(weight_o[4][9]),
        .sum_i(sum_o[4][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][9]),
        //Down part
        .weight_o(weight_o[5][9]),
        .sum_o(sum_o[5][9])
    );

    PE u_pe5_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][9]),
        //Up part
        .weight_i(weight_o[4][10]),
        .sum_i(sum_o[4][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][10]),
        //Down part
        .weight_o(weight_o[5][10]),
        .sum_o(sum_o[5][10])
    );

    PE u_pe5_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][10]),
        //Up part
        .weight_i(weight_o[4][11]),
        .sum_i(sum_o[4][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][11]),
        //Down part
        .weight_o(weight_o[5][11]),
        .sum_o(sum_o[5][11])
    );

    PE u_pe5_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][11]),
        //Up part
        .weight_i(weight_o[4][12]),
        .sum_i(sum_o[4][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][12]),
        //Down part
        .weight_o(weight_o[5][12]),
        .sum_o(sum_o[5][12])
    );

    PE u_pe5_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][12]),
        //Up part
        .weight_i(weight_o[4][13]),
        .sum_i(sum_o[4][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][13]),
        //Down part
        .weight_o(weight_o[5][13]),
        .sum_o(sum_o[5][13])
    );

    PE u_pe5_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][13]),
        //Up part
        .weight_i(weight_o[4][14]),
        .sum_i(sum_o[4][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][14]),
        //Down part
        .weight_o(weight_o[5][14]),
        .sum_o(sum_o[5][14])
    );

    PE u_pe5_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[5][14]),
        //Up part
        .weight_i(weight_o[4][15]),
        .sum_i(sum_o[4][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[5][15]),
        //Down part
        .weight_o(weight_o[5][15]),
        .sum_o(sum_o[5][15])
    );

    //'6'th row
    PE u_pe6_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[6]),
        //Up part
        .weight_i(weight_o[5][0]),
        .sum_i(sum_o[5][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][0]),
        //Down part
        .weight_o(weight_o[6][0]),
        .sum_o(sum_o[6][0])
    );

    PE u_pe6_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][0]),
        //Up part
        .weight_i(weight_o[5][1]),
        .sum_i(sum_o[5][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][1]),
        //Down part
        .weight_o(weight_o[6][1]),
        .sum_o(sum_o[6][1])
    );

    PE u_pe6_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][1]),
        //Up part
        .weight_i(weight_o[5][2]),
        .sum_i(sum_o[5][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][2]),
        //Down part
        .weight_o(weight_o[6][2]),
        .sum_o(sum_o[6][2])
    );

    PE u_pe6_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][2]),
        //Up part
        .weight_i(weight_o[5][3]),
        .sum_i(sum_o[5][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][3]),
        //Down part
        .weight_o(weight_o[6][3]),
        .sum_o(sum_o[6][3])
    );

    PE u_pe6_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][3]),
        //Up part
        .weight_i(weight_o[5][4]),
        .sum_i(sum_o[5][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][4]),
        //Down part
        .weight_o(weight_o[6][4]),
        .sum_o(sum_o[6][4])
    );

    PE u_pe6_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][4]),
        //Up part
        .weight_i(weight_o[5][5]),
        .sum_i(sum_o[5][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][5]),
        //Down part
        .weight_o(weight_o[6][5]),
        .sum_o(sum_o[6][5])
    );

    PE u_pe6_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][5]),
        //Up part
        .weight_i(weight_o[5][6]),
        .sum_i(sum_o[5][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][6]),
        //Down part
        .weight_o(weight_o[6][6]),
        .sum_o(sum_o[6][6])
    );

    PE u_pe6_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][6]),
        //Up part
        .weight_i(weight_o[5][7]),
        .sum_i(sum_o[5][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][7]),
        //Down part
        .weight_o(weight_o[6][7]),
        .sum_o(sum_o[6][7])
    );

    PE u_pe6_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][7]),
        //Up part
        .weight_i(weight_o[5][8]),
        .sum_i(sum_o[5][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][8]),
        //Down part
        .weight_o(weight_o[6][8]),
        .sum_o(sum_o[6][8])
    );

    PE u_pe6_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][8]),
        //Up part
        .weight_i(weight_o[5][9]),
        .sum_i(sum_o[5][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][9]),
        //Down part
        .weight_o(weight_o[6][9]),
        .sum_o(sum_o[6][9])
    );

    PE u_pe6_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][9]),
        //Up part
        .weight_i(weight_o[5][10]),
        .sum_i(sum_o[5][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][10]),
        //Down part
        .weight_o(weight_o[6][10]),
        .sum_o(sum_o[6][10])
    );

    PE u_pe6_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][10]),
        //Up part
        .weight_i(weight_o[5][11]),
        .sum_i(sum_o[5][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][11]),
        //Down part
        .weight_o(weight_o[6][11]),
        .sum_o(sum_o[6][11])
    );

    PE u_pe6_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][11]),
        //Up part
        .weight_i(weight_o[5][12]),
        .sum_i(sum_o[5][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][12]),
        //Down part
        .weight_o(weight_o[6][12]),
        .sum_o(sum_o[6][12])
    );

    PE u_pe6_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][12]),
        //Up part
        .weight_i(weight_o[5][13]),
        .sum_i(sum_o[5][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][13]),
        //Down part
        .weight_o(weight_o[6][13]),
        .sum_o(sum_o[6][13])
    );

    PE u_pe6_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][13]),
        //Up part
        .weight_i(weight_o[5][14]),
        .sum_i(sum_o[5][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][14]),
        //Down part
        .weight_o(weight_o[6][14]),
        .sum_o(sum_o[6][14])
    );

    PE u_pe6_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[6][14]),
        //Up part
        .weight_i(weight_o[5][15]),
        .sum_i(sum_o[5][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[6][15]),
        //Down part
        .weight_o(weight_o[6][15]),
        .sum_o(sum_o[6][15])
    );

    //'7'th row
    PE u_pe7_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[7]),
        //Up part
        .weight_i(weight_o[6][0]),
        .sum_i(sum_o[6][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][0]),
        //Down part
        .weight_o(weight_o[7][0]),
        .sum_o(sum_o[7][0])
    );

    PE u_pe7_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][0]),
        //Up part
        .weight_i(weight_o[6][1]),
        .sum_i(sum_o[6][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][1]),
        //Down part
        .weight_o(weight_o[7][1]),
        .sum_o(sum_o[7][1])
    );

    PE u_pe7_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][1]),
        //Up part
        .weight_i(weight_o[6][2]),
        .sum_i(sum_o[6][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][2]),
        //Down part
        .weight_o(weight_o[7][2]),
        .sum_o(sum_o[7][2])
    );

    PE u_pe7_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][2]),
        //Up part
        .weight_i(weight_o[6][3]),
        .sum_i(sum_o[6][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][3]),
        //Down part
        .weight_o(weight_o[7][3]),
        .sum_o(sum_o[7][3])
    );

    PE u_pe7_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][3]),
        //Up part
        .weight_i(weight_o[6][4]),
        .sum_i(sum_o[6][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][4]),
        //Down part
        .weight_o(weight_o[7][4]),
        .sum_o(sum_o[7][4])
    );

    PE u_pe7_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][4]),
        //Up part
        .weight_i(weight_o[6][5]),
        .sum_i(sum_o[6][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][5]),
        //Down part
        .weight_o(weight_o[7][5]),
        .sum_o(sum_o[7][5])
    );

    PE u_pe7_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][5]),
        //Up part
        .weight_i(weight_o[6][6]),
        .sum_i(sum_o[6][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][6]),
        //Down part
        .weight_o(weight_o[7][6]),
        .sum_o(sum_o[7][6])
    );

    PE u_pe7_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][6]),
        //Up part
        .weight_i(weight_o[6][7]),
        .sum_i(sum_o[6][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][7]),
        //Down part
        .weight_o(weight_o[7][7]),
        .sum_o(sum_o[7][7])
    );

    PE u_pe7_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][7]),
        //Up part
        .weight_i(weight_o[6][8]),
        .sum_i(sum_o[6][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][8]),
        //Down part
        .weight_o(weight_o[7][8]),
        .sum_o(sum_o[7][8])
    );

    PE u_pe7_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][8]),
        //Up part
        .weight_i(weight_o[6][9]),
        .sum_i(sum_o[6][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][9]),
        //Down part
        .weight_o(weight_o[7][9]),
        .sum_o(sum_o[7][9])
    );

    PE u_pe7_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][9]),
        //Up part
        .weight_i(weight_o[6][10]),
        .sum_i(sum_o[6][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][10]),
        //Down part
        .weight_o(weight_o[7][10]),
        .sum_o(sum_o[7][10])
    );

    PE u_pe7_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][10]),
        //Up part
        .weight_i(weight_o[6][11]),
        .sum_i(sum_o[6][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][11]),
        //Down part
        .weight_o(weight_o[7][11]),
        .sum_o(sum_o[7][11])
    );

    PE u_pe7_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][11]),
        //Up part
        .weight_i(weight_o[6][12]),
        .sum_i(sum_o[6][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][12]),
        //Down part
        .weight_o(weight_o[7][12]),
        .sum_o(sum_o[7][12])
    );

    PE u_pe7_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][12]),
        //Up part
        .weight_i(weight_o[6][13]),
        .sum_i(sum_o[6][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][13]),
        //Down part
        .weight_o(weight_o[7][13]),
        .sum_o(sum_o[7][13])
    );

    PE u_pe7_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][13]),
        //Up part
        .weight_i(weight_o[6][14]),
        .sum_i(sum_o[6][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][14]),
        //Down part
        .weight_o(weight_o[7][14]),
        .sum_o(sum_o[7][14])
    );

    PE u_pe7_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[7][14]),
        //Up part
        .weight_i(weight_o[6][15]),
        .sum_i(sum_o[6][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[7][15]),
        //Down part
        .weight_o(weight_o[7][15]),
        .sum_o(sum_o[7][15])
    );

    //'8'th row
    PE u_pe8_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[8]),
        //Up part
        .weight_i(weight_o[7][0]),
        .sum_i(sum_o[7][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][0]),
        //Down part
        .weight_o(weight_o[8][0]),
        .sum_o(sum_o[8][0])
    );

    PE u_pe8_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][0]),
        //Up part
        .weight_i(weight_o[7][1]),
        .sum_i(sum_o[7][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][1]),
        //Down part
        .weight_o(weight_o[8][1]),
        .sum_o(sum_o[8][1])
    );

    PE u_pe8_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][1]),
        //Up part
        .weight_i(weight_o[7][2]),
        .sum_i(sum_o[7][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][2]),
        //Down part
        .weight_o(weight_o[8][2]),
        .sum_o(sum_o[8][2])
    );

    PE u_pe8_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][2]),
        //Up part
        .weight_i(weight_o[7][3]),
        .sum_i(sum_o[7][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][3]),
        //Down part
        .weight_o(weight_o[8][3]),
        .sum_o(sum_o[8][3])
    );

    PE u_pe8_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][3]),
        //Up part
        .weight_i(weight_o[7][4]),
        .sum_i(sum_o[7][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][4]),
        //Down part
        .weight_o(weight_o[8][4]),
        .sum_o(sum_o[8][4])
    );

    PE u_pe8_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][4]),
        //Up part
        .weight_i(weight_o[7][5]),
        .sum_i(sum_o[7][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][5]),
        //Down part
        .weight_o(weight_o[8][5]),
        .sum_o(sum_o[8][5])
    );

    PE u_pe8_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][5]),
        //Up part
        .weight_i(weight_o[7][6]),
        .sum_i(sum_o[7][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][6]),
        //Down part
        .weight_o(weight_o[8][6]),
        .sum_o(sum_o[8][6])
    );

    PE u_pe8_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][6]),
        //Up part
        .weight_i(weight_o[7][7]),
        .sum_i(sum_o[7][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][7]),
        //Down part
        .weight_o(weight_o[8][7]),
        .sum_o(sum_o[8][7])
    );

    PE u_pe8_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][7]),
        //Up part
        .weight_i(weight_o[7][8]),
        .sum_i(sum_o[7][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][8]),
        //Down part
        .weight_o(weight_o[8][8]),
        .sum_o(sum_o[8][8])
    );

    PE u_pe8_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][8]),
        //Up part
        .weight_i(weight_o[7][9]),
        .sum_i(sum_o[7][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][9]),
        //Down part
        .weight_o(weight_o[8][9]),
        .sum_o(sum_o[8][9])
    );

    PE u_pe8_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][9]),
        //Up part
        .weight_i(weight_o[7][10]),
        .sum_i(sum_o[7][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][10]),
        //Down part
        .weight_o(weight_o[8][10]),
        .sum_o(sum_o[8][10])
    );

    PE u_pe8_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][10]),
        //Up part
        .weight_i(weight_o[7][11]),
        .sum_i(sum_o[7][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][11]),
        //Down part
        .weight_o(weight_o[8][11]),
        .sum_o(sum_o[8][11])
    );

    PE u_pe8_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][11]),
        //Up part
        .weight_i(weight_o[7][12]),
        .sum_i(sum_o[7][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][12]),
        //Down part
        .weight_o(weight_o[8][12]),
        .sum_o(sum_o[8][12])
    );

    PE u_pe8_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][12]),
        //Up part
        .weight_i(weight_o[7][13]),
        .sum_i(sum_o[7][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][13]),
        //Down part
        .weight_o(weight_o[8][13]),
        .sum_o(sum_o[8][13])
    );

    PE u_pe8_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][13]),
        //Up part
        .weight_i(weight_o[7][14]),
        .sum_i(sum_o[7][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][14]),
        //Down part
        .weight_o(weight_o[8][14]),
        .sum_o(sum_o[8][14])
    );

    PE u_pe8_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[8][14]),
        //Up part
        .weight_i(weight_o[7][15]),
        .sum_i(sum_o[7][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[8][15]),
        //Down part
        .weight_o(weight_o[8][15]),
        .sum_o(sum_o[8][15])
    );

    //'9'th row
    PE u_pe9_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[9]),
        //Up part
        .weight_i(weight_o[8][0]),
        .sum_i(sum_o[8][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][0]),
        //Down part
        .weight_o(weight_o[9][0]),
        .sum_o(sum_o[9][0])
    );

    PE u_pe9_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][0]),
        //Up part
        .weight_i(weight_o[8][1]),
        .sum_i(sum_o[8][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][1]),
        //Down part
        .weight_o(weight_o[9][1]),
        .sum_o(sum_o[9][1])
    );

    PE u_pe9_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][1]),
        //Up part
        .weight_i(weight_o[8][2]),
        .sum_i(sum_o[8][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][2]),
        //Down part
        .weight_o(weight_o[9][2]),
        .sum_o(sum_o[9][2])
    );

    PE u_pe9_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][2]),
        //Up part
        .weight_i(weight_o[8][3]),
        .sum_i(sum_o[8][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][3]),
        //Down part
        .weight_o(weight_o[9][3]),
        .sum_o(sum_o[9][3])
    );

    PE u_pe9_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][3]),
        //Up part
        .weight_i(weight_o[8][4]),
        .sum_i(sum_o[8][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][4]),
        //Down part
        .weight_o(weight_o[9][4]),
        .sum_o(sum_o[9][4])
    );

    PE u_pe9_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][4]),
        //Up part
        .weight_i(weight_o[8][5]),
        .sum_i(sum_o[8][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][5]),
        //Down part
        .weight_o(weight_o[9][5]),
        .sum_o(sum_o[9][5])
    );

    PE u_pe9_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][5]),
        //Up part
        .weight_i(weight_o[8][6]),
        .sum_i(sum_o[8][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][6]),
        //Down part
        .weight_o(weight_o[9][6]),
        .sum_o(sum_o[9][6])
    );

    PE u_pe9_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][6]),
        //Up part
        .weight_i(weight_o[8][7]),
        .sum_i(sum_o[8][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][7]),
        //Down part
        .weight_o(weight_o[9][7]),
        .sum_o(sum_o[9][7])
    );

    PE u_pe9_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][7]),
        //Up part
        .weight_i(weight_o[8][8]),
        .sum_i(sum_o[8][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][8]),
        //Down part
        .weight_o(weight_o[9][8]),
        .sum_o(sum_o[9][8])
    );

    PE u_pe9_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][8]),
        //Up part
        .weight_i(weight_o[8][9]),
        .sum_i(sum_o[8][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][9]),
        //Down part
        .weight_o(weight_o[9][9]),
        .sum_o(sum_o[9][9])
    );

    PE u_pe9_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][9]),
        //Up part
        .weight_i(weight_o[8][10]),
        .sum_i(sum_o[8][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][10]),
        //Down part
        .weight_o(weight_o[9][10]),
        .sum_o(sum_o[9][10])
    );

    PE u_pe9_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][10]),
        //Up part
        .weight_i(weight_o[8][11]),
        .sum_i(sum_o[8][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][11]),
        //Down part
        .weight_o(weight_o[9][11]),
        .sum_o(sum_o[9][11])
    );

    PE u_pe9_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][11]),
        //Up part
        .weight_i(weight_o[8][12]),
        .sum_i(sum_o[8][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][12]),
        //Down part
        .weight_o(weight_o[9][12]),
        .sum_o(sum_o[9][12])
    );

    PE u_pe9_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][12]),
        //Up part
        .weight_i(weight_o[8][13]),
        .sum_i(sum_o[8][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][13]),
        //Down part
        .weight_o(weight_o[9][13]),
        .sum_o(sum_o[9][13])
    );

    PE u_pe9_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][13]),
        //Up part
        .weight_i(weight_o[8][14]),
        .sum_i(sum_o[8][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][14]),
        //Down part
        .weight_o(weight_o[9][14]),
        .sum_o(sum_o[9][14])
    );

    PE u_pe9_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[9][14]),
        //Up part
        .weight_i(weight_o[8][15]),
        .sum_i(sum_o[8][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[9][15]),
        //Down part
        .weight_o(weight_o[9][15]),
        .sum_o(sum_o[9][15])
    );

    //'10'th row
    PE u_pe10_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[10]),
        //Up part
        .weight_i(weight_o[9][0]),
        .sum_i(sum_o[9][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][0]),
        //Down part
        .weight_o(weight_o[10][0]),
        .sum_o(sum_o[10][0])
    );

    PE u_pe10_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][0]),
        //Up part
        .weight_i(weight_o[9][1]),
        .sum_i(sum_o[9][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][1]),
        //Down part
        .weight_o(weight_o[10][1]),
        .sum_o(sum_o[10][1])
    );

    PE u_pe10_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][1]),
        //Up part
        .weight_i(weight_o[9][2]),
        .sum_i(sum_o[9][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][2]),
        //Down part
        .weight_o(weight_o[10][2]),
        .sum_o(sum_o[10][2])
    );

    PE u_pe10_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][2]),
        //Up part
        .weight_i(weight_o[9][3]),
        .sum_i(sum_o[9][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][3]),
        //Down part
        .weight_o(weight_o[10][3]),
        .sum_o(sum_o[10][3])
    );

    PE u_pe10_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][3]),
        //Up part
        .weight_i(weight_o[9][4]),
        .sum_i(sum_o[9][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][4]),
        //Down part
        .weight_o(weight_o[10][4]),
        .sum_o(sum_o[10][4])
    );

    PE u_pe10_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][4]),
        //Up part
        .weight_i(weight_o[9][5]),
        .sum_i(sum_o[9][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][5]),
        //Down part
        .weight_o(weight_o[10][5]),
        .sum_o(sum_o[10][5])
    );

    PE u_pe10_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][5]),
        //Up part
        .weight_i(weight_o[9][6]),
        .sum_i(sum_o[9][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][6]),
        //Down part
        .weight_o(weight_o[10][6]),
        .sum_o(sum_o[10][6])
    );

    PE u_pe10_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][6]),
        //Up part
        .weight_i(weight_o[9][7]),
        .sum_i(sum_o[9][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][7]),
        //Down part
        .weight_o(weight_o[10][7]),
        .sum_o(sum_o[10][7])
    );

    PE u_pe10_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][7]),
        //Up part
        .weight_i(weight_o[9][8]),
        .sum_i(sum_o[9][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][8]),
        //Down part
        .weight_o(weight_o[10][8]),
        .sum_o(sum_o[10][8])
    );

    PE u_pe10_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][8]),
        //Up part
        .weight_i(weight_o[9][9]),
        .sum_i(sum_o[9][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][9]),
        //Down part
        .weight_o(weight_o[10][9]),
        .sum_o(sum_o[10][9])
    );

    PE u_pe10_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][9]),
        //Up part
        .weight_i(weight_o[9][10]),
        .sum_i(sum_o[9][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][10]),
        //Down part
        .weight_o(weight_o[10][10]),
        .sum_o(sum_o[10][10])
    );

    PE u_pe10_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][10]),
        //Up part
        .weight_i(weight_o[9][11]),
        .sum_i(sum_o[9][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][11]),
        //Down part
        .weight_o(weight_o[10][11]),
        .sum_o(sum_o[10][11])
    );

    PE u_pe10_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][11]),
        //Up part
        .weight_i(weight_o[9][12]),
        .sum_i(sum_o[9][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][12]),
        //Down part
        .weight_o(weight_o[10][12]),
        .sum_o(sum_o[10][12])
    );

    PE u_pe10_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][12]),
        //Up part
        .weight_i(weight_o[9][13]),
        .sum_i(sum_o[9][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][13]),
        //Down part
        .weight_o(weight_o[10][13]),
        .sum_o(sum_o[10][13])
    );

    PE u_pe10_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][13]),
        //Up part
        .weight_i(weight_o[9][14]),
        .sum_i(sum_o[9][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][14]),
        //Down part
        .weight_o(weight_o[10][14]),
        .sum_o(sum_o[10][14])
    );

    PE u_pe10_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[10][14]),
        //Up part
        .weight_i(weight_o[9][15]),
        .sum_i(sum_o[9][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[10][15]),
        //Down part
        .weight_o(weight_o[10][15]),
        .sum_o(sum_o[10][15])
    );

    //'11'th row
    PE u_pe11_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[11]),
        //Up part
        .weight_i(weight_o[10][0]),
        .sum_i(sum_o[10][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][0]),
        //Down part
        .weight_o(weight_o[11][0]),
        .sum_o(sum_o[11][0])
    );

    PE u_pe11_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][0]),
        //Up part
        .weight_i(weight_o[10][1]),
        .sum_i(sum_o[10][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][1]),
        //Down part
        .weight_o(weight_o[11][1]),
        .sum_o(sum_o[11][1])
    );

    PE u_pe11_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][1]),
        //Up part
        .weight_i(weight_o[10][2]),
        .sum_i(sum_o[10][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][2]),
        //Down part
        .weight_o(weight_o[11][2]),
        .sum_o(sum_o[11][2])
    );

    PE u_pe11_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][2]),
        //Up part
        .weight_i(weight_o[10][3]),
        .sum_i(sum_o[10][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][3]),
        //Down part
        .weight_o(weight_o[11][3]),
        .sum_o(sum_o[11][3])
    );

    PE u_pe11_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][3]),
        //Up part
        .weight_i(weight_o[10][4]),
        .sum_i(sum_o[10][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][4]),
        //Down part
        .weight_o(weight_o[11][4]),
        .sum_o(sum_o[11][4])
    );

    PE u_pe11_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][4]),
        //Up part
        .weight_i(weight_o[10][5]),
        .sum_i(sum_o[10][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][5]),
        //Down part
        .weight_o(weight_o[11][5]),
        .sum_o(sum_o[11][5])
    );

    PE u_pe11_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][5]),
        //Up part
        .weight_i(weight_o[10][6]),
        .sum_i(sum_o[10][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][6]),
        //Down part
        .weight_o(weight_o[11][6]),
        .sum_o(sum_o[11][6])
    );

    PE u_pe11_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][6]),
        //Up part
        .weight_i(weight_o[10][7]),
        .sum_i(sum_o[10][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][7]),
        //Down part
        .weight_o(weight_o[11][7]),
        .sum_o(sum_o[11][7])
    );

    PE u_pe11_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][7]),
        //Up part
        .weight_i(weight_o[10][8]),
        .sum_i(sum_o[10][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][8]),
        //Down part
        .weight_o(weight_o[11][8]),
        .sum_o(sum_o[11][8])
    );

    PE u_pe11_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][8]),
        //Up part
        .weight_i(weight_o[10][9]),
        .sum_i(sum_o[10][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][9]),
        //Down part
        .weight_o(weight_o[11][9]),
        .sum_o(sum_o[11][9])
    );

    PE u_pe11_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][9]),
        //Up part
        .weight_i(weight_o[10][10]),
        .sum_i(sum_o[10][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][10]),
        //Down part
        .weight_o(weight_o[11][10]),
        .sum_o(sum_o[11][10])
    );

    PE u_pe11_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][10]),
        //Up part
        .weight_i(weight_o[10][11]),
        .sum_i(sum_o[10][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][11]),
        //Down part
        .weight_o(weight_o[11][11]),
        .sum_o(sum_o[11][11])
    );

    PE u_pe11_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][11]),
        //Up part
        .weight_i(weight_o[10][12]),
        .sum_i(sum_o[10][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][12]),
        //Down part
        .weight_o(weight_o[11][12]),
        .sum_o(sum_o[11][12])
    );

    PE u_pe11_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][12]),
        //Up part
        .weight_i(weight_o[10][13]),
        .sum_i(sum_o[10][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][13]),
        //Down part
        .weight_o(weight_o[11][13]),
        .sum_o(sum_o[11][13])
    );

    PE u_pe11_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][13]),
        //Up part
        .weight_i(weight_o[10][14]),
        .sum_i(sum_o[10][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][14]),
        //Down part
        .weight_o(weight_o[11][14]),
        .sum_o(sum_o[11][14])
    );

    PE u_pe11_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[11][14]),
        //Up part
        .weight_i(weight_o[10][15]),
        .sum_i(sum_o[10][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[11][15]),
        //Down part
        .weight_o(weight_o[11][15]),
        .sum_o(sum_o[11][15])
    );

    //'12'th row
    PE u_pe12_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[12]),
        //Up part
        .weight_i(weight_o[11][0]),
        .sum_i(sum_o[11][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][0]),
        //Down part
        .weight_o(weight_o[12][0]),
        .sum_o(sum_o[12][0])
    );

    PE u_pe12_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][0]),
        //Up part
        .weight_i(weight_o[11][1]),
        .sum_i(sum_o[11][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][1]),
        //Down part
        .weight_o(weight_o[12][1]),
        .sum_o(sum_o[12][1])
    );

    PE u_pe12_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][1]),
        //Up part
        .weight_i(weight_o[11][2]),
        .sum_i(sum_o[11][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][2]),
        //Down part
        .weight_o(weight_o[12][2]),
        .sum_o(sum_o[12][2])
    );

    PE u_pe12_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][2]),
        //Up part
        .weight_i(weight_o[11][3]),
        .sum_i(sum_o[11][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][3]),
        //Down part
        .weight_o(weight_o[12][3]),
        .sum_o(sum_o[12][3])
    );

    PE u_pe12_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][3]),
        //Up part
        .weight_i(weight_o[11][4]),
        .sum_i(sum_o[11][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][4]),
        //Down part
        .weight_o(weight_o[12][4]),
        .sum_o(sum_o[12][4])
    );

    PE u_pe12_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][4]),
        //Up part
        .weight_i(weight_o[11][5]),
        .sum_i(sum_o[11][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][5]),
        //Down part
        .weight_o(weight_o[12][5]),
        .sum_o(sum_o[12][5])
    );

    PE u_pe12_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][5]),
        //Up part
        .weight_i(weight_o[11][6]),
        .sum_i(sum_o[11][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][6]),
        //Down part
        .weight_o(weight_o[12][6]),
        .sum_o(sum_o[12][6])
    );

    PE u_pe12_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][6]),
        //Up part
        .weight_i(weight_o[11][7]),
        .sum_i(sum_o[11][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][7]),
        //Down part
        .weight_o(weight_o[12][7]),
        .sum_o(sum_o[12][7])
    );

    PE u_pe12_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][7]),
        //Up part
        .weight_i(weight_o[11][8]),
        .sum_i(sum_o[11][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][8]),
        //Down part
        .weight_o(weight_o[12][8]),
        .sum_o(sum_o[12][8])
    );

    PE u_pe12_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][8]),
        //Up part
        .weight_i(weight_o[11][9]),
        .sum_i(sum_o[11][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][9]),
        //Down part
        .weight_o(weight_o[12][9]),
        .sum_o(sum_o[12][9])
    );

    PE u_pe12_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][9]),
        //Up part
        .weight_i(weight_o[11][10]),
        .sum_i(sum_o[11][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][10]),
        //Down part
        .weight_o(weight_o[12][10]),
        .sum_o(sum_o[12][10])
    );

    PE u_pe12_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][10]),
        //Up part
        .weight_i(weight_o[11][11]),
        .sum_i(sum_o[11][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][11]),
        //Down part
        .weight_o(weight_o[12][11]),
        .sum_o(sum_o[12][11])
    );

    PE u_pe12_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][11]),
        //Up part
        .weight_i(weight_o[11][12]),
        .sum_i(sum_o[11][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][12]),
        //Down part
        .weight_o(weight_o[12][12]),
        .sum_o(sum_o[12][12])
    );

    PE u_pe12_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][12]),
        //Up part
        .weight_i(weight_o[11][13]),
        .sum_i(sum_o[11][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][13]),
        //Down part
        .weight_o(weight_o[12][13]),
        .sum_o(sum_o[12][13])
    );

    PE u_pe12_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][13]),
        //Up part
        .weight_i(weight_o[11][14]),
        .sum_i(sum_o[11][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][14]),
        //Down part
        .weight_o(weight_o[12][14]),
        .sum_o(sum_o[12][14])
    );

    PE u_pe12_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[12][14]),
        //Up part
        .weight_i(weight_o[11][15]),
        .sum_i(sum_o[11][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[12][15]),
        //Down part
        .weight_o(weight_o[12][15]),
        .sum_o(sum_o[12][15])
    );

    //'13'th row
    PE u_pe13_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[13]),
        //Up part
        .weight_i(weight_o[12][0]),
        .sum_i(sum_o[12][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][0]),
        //Down part
        .weight_o(weight_o[13][0]),
        .sum_o(sum_o[13][0])
    );

    PE u_pe13_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][0]),
        //Up part
        .weight_i(weight_o[12][1]),
        .sum_i(sum_o[12][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][1]),
        //Down part
        .weight_o(weight_o[13][1]),
        .sum_o(sum_o[13][1])
    );

    PE u_pe13_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][1]),
        //Up part
        .weight_i(weight_o[12][2]),
        .sum_i(sum_o[12][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][2]),
        //Down part
        .weight_o(weight_o[13][2]),
        .sum_o(sum_o[13][2])
    );

    PE u_pe13_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][2]),
        //Up part
        .weight_i(weight_o[12][3]),
        .sum_i(sum_o[12][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][3]),
        //Down part
        .weight_o(weight_o[13][3]),
        .sum_o(sum_o[13][3])
    );

    PE u_pe13_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][3]),
        //Up part
        .weight_i(weight_o[12][4]),
        .sum_i(sum_o[12][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][4]),
        //Down part
        .weight_o(weight_o[13][4]),
        .sum_o(sum_o[13][4])
    );

    PE u_pe13_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][4]),
        //Up part
        .weight_i(weight_o[12][5]),
        .sum_i(sum_o[12][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][5]),
        //Down part
        .weight_o(weight_o[13][5]),
        .sum_o(sum_o[13][5])
    );

    PE u_pe13_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][5]),
        //Up part
        .weight_i(weight_o[12][6]),
        .sum_i(sum_o[12][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][6]),
        //Down part
        .weight_o(weight_o[13][6]),
        .sum_o(sum_o[13][6])
    );

    PE u_pe13_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][6]),
        //Up part
        .weight_i(weight_o[12][7]),
        .sum_i(sum_o[12][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][7]),
        //Down part
        .weight_o(weight_o[13][7]),
        .sum_o(sum_o[13][7])
    );

    PE u_pe13_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][7]),
        //Up part
        .weight_i(weight_o[12][8]),
        .sum_i(sum_o[12][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][8]),
        //Down part
        .weight_o(weight_o[13][8]),
        .sum_o(sum_o[13][8])
    );

    PE u_pe13_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][8]),
        //Up part
        .weight_i(weight_o[12][9]),
        .sum_i(sum_o[12][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][9]),
        //Down part
        .weight_o(weight_o[13][9]),
        .sum_o(sum_o[13][9])
    );

    PE u_pe13_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][9]),
        //Up part
        .weight_i(weight_o[12][10]),
        .sum_i(sum_o[12][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][10]),
        //Down part
        .weight_o(weight_o[13][10]),
        .sum_o(sum_o[13][10])
    );

    PE u_pe13_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][10]),
        //Up part
        .weight_i(weight_o[12][11]),
        .sum_i(sum_o[12][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][11]),
        //Down part
        .weight_o(weight_o[13][11]),
        .sum_o(sum_o[13][11])
    );

    PE u_pe13_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][11]),
        //Up part
        .weight_i(weight_o[12][12]),
        .sum_i(sum_o[12][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][12]),
        //Down part
        .weight_o(weight_o[13][12]),
        .sum_o(sum_o[13][12])
    );

    PE u_pe13_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][12]),
        //Up part
        .weight_i(weight_o[12][13]),
        .sum_i(sum_o[12][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][13]),
        //Down part
        .weight_o(weight_o[13][13]),
        .sum_o(sum_o[13][13])
    );

    PE u_pe13_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][13]),
        //Up part
        .weight_i(weight_o[12][14]),
        .sum_i(sum_o[12][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][14]),
        //Down part
        .weight_o(weight_o[13][14]),
        .sum_o(sum_o[13][14])
    );

    PE u_pe13_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[13][14]),
        //Up part
        .weight_i(weight_o[12][15]),
        .sum_i(sum_o[12][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[13][15]),
        //Down part
        .weight_o(weight_o[13][15]),
        .sum_o(sum_o[13][15])
    );

    //'14'th row
    PE u_pe14_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[14]),
        //Up part
        .weight_i(weight_o[13][0]),
        .sum_i(sum_o[13][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][0]),
        //Down part
        .weight_o(weight_o[14][0]),
        .sum_o(sum_o[14][0])
    );

    PE u_pe14_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][0]),
        //Up part
        .weight_i(weight_o[13][1]),
        .sum_i(sum_o[13][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][1]),
        //Down part
        .weight_o(weight_o[14][1]),
        .sum_o(sum_o[14][1])
    );

    PE u_pe14_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][1]),
        //Up part
        .weight_i(weight_o[13][2]),
        .sum_i(sum_o[13][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][2]),
        //Down part
        .weight_o(weight_o[14][2]),
        .sum_o(sum_o[14][2])
    );

    PE u_pe14_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][2]),
        //Up part
        .weight_i(weight_o[13][3]),
        .sum_i(sum_o[13][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][3]),
        //Down part
        .weight_o(weight_o[14][3]),
        .sum_o(sum_o[14][3])
    );

    PE u_pe14_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][3]),
        //Up part
        .weight_i(weight_o[13][4]),
        .sum_i(sum_o[13][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][4]),
        //Down part
        .weight_o(weight_o[14][4]),
        .sum_o(sum_o[14][4])
    );

    PE u_pe14_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][4]),
        //Up part
        .weight_i(weight_o[13][5]),
        .sum_i(sum_o[13][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][5]),
        //Down part
        .weight_o(weight_o[14][5]),
        .sum_o(sum_o[14][5])
    );

    PE u_pe14_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][5]),
        //Up part
        .weight_i(weight_o[13][6]),
        .sum_i(sum_o[13][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][6]),
        //Down part
        .weight_o(weight_o[14][6]),
        .sum_o(sum_o[14][6])
    );

    PE u_pe14_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][6]),
        //Up part
        .weight_i(weight_o[13][7]),
        .sum_i(sum_o[13][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][7]),
        //Down part
        .weight_o(weight_o[14][7]),
        .sum_o(sum_o[14][7])
    );

    PE u_pe14_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][7]),
        //Up part
        .weight_i(weight_o[13][8]),
        .sum_i(sum_o[13][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][8]),
        //Down part
        .weight_o(weight_o[14][8]),
        .sum_o(sum_o[14][8])
    );

    PE u_pe14_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][8]),
        //Up part
        .weight_i(weight_o[13][9]),
        .sum_i(sum_o[13][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][9]),
        //Down part
        .weight_o(weight_o[14][9]),
        .sum_o(sum_o[14][9])
    );

    PE u_pe14_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][9]),
        //Up part
        .weight_i(weight_o[13][10]),
        .sum_i(sum_o[13][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][10]),
        //Down part
        .weight_o(weight_o[14][10]),
        .sum_o(sum_o[14][10])
    );

    PE u_pe14_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][10]),
        //Up part
        .weight_i(weight_o[13][11]),
        .sum_i(sum_o[13][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][11]),
        //Down part
        .weight_o(weight_o[14][11]),
        .sum_o(sum_o[14][11])
    );

    PE u_pe14_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][11]),
        //Up part
        .weight_i(weight_o[13][12]),
        .sum_i(sum_o[13][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][12]),
        //Down part
        .weight_o(weight_o[14][12]),
        .sum_o(sum_o[14][12])
    );

    PE u_pe14_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][12]),
        //Up part
        .weight_i(weight_o[13][13]),
        .sum_i(sum_o[13][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][13]),
        //Down part
        .weight_o(weight_o[14][13]),
        .sum_o(sum_o[14][13])
    );

    PE u_pe14_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][13]),
        //Up part
        .weight_i(weight_o[13][14]),
        .sum_i(sum_o[13][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][14]),
        //Down part
        .weight_o(weight_o[14][14]),
        .sum_o(sum_o[14][14])
    );

    PE u_pe14_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[14][14]),
        //Up part
        .weight_i(weight_o[13][15]),
        .sum_i(sum_o[13][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[14][15]),
        //Down part
        .weight_o(weight_o[14][15]),
        .sum_o(sum_o[14][15])
    );

    //'15'th row
    PE u_pe15_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[15]),
        //Up part
        .weight_i(weight_o[14][0]),
        .sum_i(sum_o[14][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][0]),
        //Down part
        .weight_o(weight_o[15][0]),
        .sum_o(sum_o[15][0])
    );

    PE u_pe15_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][0]),
        //Up part
        .weight_i(weight_o[14][1]),
        .sum_i(sum_o[14][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][1]),
        //Down part
        .weight_o(weight_o[15][1]),
        .sum_o(sum_o[15][1])
    );

    PE u_pe15_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][1]),
        //Up part
        .weight_i(weight_o[14][2]),
        .sum_i(sum_o[14][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][2]),
        //Down part
        .weight_o(weight_o[15][2]),
        .sum_o(sum_o[15][2])
    );

    PE u_pe15_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][2]),
        //Up part
        .weight_i(weight_o[14][3]),
        .sum_i(sum_o[14][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][3]),
        //Down part
        .weight_o(weight_o[15][3]),
        .sum_o(sum_o[15][3])
    );

    PE u_pe15_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][3]),
        //Up part
        .weight_i(weight_o[14][4]),
        .sum_i(sum_o[14][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][4]),
        //Down part
        .weight_o(weight_o[15][4]),
        .sum_o(sum_o[15][4])
    );

    PE u_pe15_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][4]),
        //Up part
        .weight_i(weight_o[14][5]),
        .sum_i(sum_o[14][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][5]),
        //Down part
        .weight_o(weight_o[15][5]),
        .sum_o(sum_o[15][5])
    );

    PE u_pe15_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][5]),
        //Up part
        .weight_i(weight_o[14][6]),
        .sum_i(sum_o[14][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][6]),
        //Down part
        .weight_o(weight_o[15][6]),
        .sum_o(sum_o[15][6])
    );

    PE u_pe15_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][6]),
        //Up part
        .weight_i(weight_o[14][7]),
        .sum_i(sum_o[14][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][7]),
        //Down part
        .weight_o(weight_o[15][7]),
        .sum_o(sum_o[15][7])
    );

    PE u_pe15_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][7]),
        //Up part
        .weight_i(weight_o[14][8]),
        .sum_i(sum_o[14][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][8]),
        //Down part
        .weight_o(weight_o[15][8]),
        .sum_o(sum_o[15][8])
    );

    PE u_pe15_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][8]),
        //Up part
        .weight_i(weight_o[14][9]),
        .sum_i(sum_o[14][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][9]),
        //Down part
        .weight_o(weight_o[15][9]),
        .sum_o(sum_o[15][9])
    );

    PE u_pe15_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][9]),
        //Up part
        .weight_i(weight_o[14][10]),
        .sum_i(sum_o[14][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][10]),
        //Down part
        .weight_o(weight_o[15][10]),
        .sum_o(sum_o[15][10])
    );

    PE u_pe15_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][10]),
        //Up part
        .weight_i(weight_o[14][11]),
        .sum_i(sum_o[14][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][11]),
        //Down part
        .weight_o(weight_o[15][11]),
        .sum_o(sum_o[15][11])
    );

    PE u_pe15_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][11]),
        //Up part
        .weight_i(weight_o[14][12]),
        .sum_i(sum_o[14][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][12]),
        //Down part
        .weight_o(weight_o[15][12]),
        .sum_o(sum_o[15][12])
    );

    PE u_pe15_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][12]),
        //Up part
        .weight_i(weight_o[14][13]),
        .sum_i(sum_o[14][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][13]),
        //Down part
        .weight_o(weight_o[15][13]),
        .sum_o(sum_o[15][13])
    );

    PE u_pe15_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][13]),
        //Up part
        .weight_i(weight_o[14][14]),
        .sum_i(sum_o[14][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][14]),
        //Down part
        .weight_o(weight_o[15][14]),
        .sum_o(sum_o[15][14])
    );

    PE u_pe15_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[15][14]),
        //Up part
        .weight_i(weight_o[14][15]),
        .sum_i(sum_o[14][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[15][15]),
        //Down part
        .weight_o(weight_o[15][15]),
        .sum_o(sum_o[15][15])
    );

    //'16'th row
    PE u_pe16_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[16]),
        //Up part
        .weight_i(weight_o[15][0]),
        .sum_i(sum_o[15][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][0]),
        //Down part
        .weight_o(weight_o[16][0]),
        .sum_o(sum_o[16][0])
    );

    PE u_pe16_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][0]),
        //Up part
        .weight_i(weight_o[15][1]),
        .sum_i(sum_o[15][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][1]),
        //Down part
        .weight_o(weight_o[16][1]),
        .sum_o(sum_o[16][1])
    );

    PE u_pe16_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][1]),
        //Up part
        .weight_i(weight_o[15][2]),
        .sum_i(sum_o[15][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][2]),
        //Down part
        .weight_o(weight_o[16][2]),
        .sum_o(sum_o[16][2])
    );

    PE u_pe16_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][2]),
        //Up part
        .weight_i(weight_o[15][3]),
        .sum_i(sum_o[15][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][3]),
        //Down part
        .weight_o(weight_o[16][3]),
        .sum_o(sum_o[16][3])
    );

    PE u_pe16_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][3]),
        //Up part
        .weight_i(weight_o[15][4]),
        .sum_i(sum_o[15][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][4]),
        //Down part
        .weight_o(weight_o[16][4]),
        .sum_o(sum_o[16][4])
    );

    PE u_pe16_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][4]),
        //Up part
        .weight_i(weight_o[15][5]),
        .sum_i(sum_o[15][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][5]),
        //Down part
        .weight_o(weight_o[16][5]),
        .sum_o(sum_o[16][5])
    );

    PE u_pe16_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][5]),
        //Up part
        .weight_i(weight_o[15][6]),
        .sum_i(sum_o[15][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][6]),
        //Down part
        .weight_o(weight_o[16][6]),
        .sum_o(sum_o[16][6])
    );

    PE u_pe16_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][6]),
        //Up part
        .weight_i(weight_o[15][7]),
        .sum_i(sum_o[15][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][7]),
        //Down part
        .weight_o(weight_o[16][7]),
        .sum_o(sum_o[16][7])
    );

    PE u_pe16_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][7]),
        //Up part
        .weight_i(weight_o[15][8]),
        .sum_i(sum_o[15][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][8]),
        //Down part
        .weight_o(weight_o[16][8]),
        .sum_o(sum_o[16][8])
    );

    PE u_pe16_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][8]),
        //Up part
        .weight_i(weight_o[15][9]),
        .sum_i(sum_o[15][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][9]),
        //Down part
        .weight_o(weight_o[16][9]),
        .sum_o(sum_o[16][9])
    );

    PE u_pe16_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][9]),
        //Up part
        .weight_i(weight_o[15][10]),
        .sum_i(sum_o[15][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][10]),
        //Down part
        .weight_o(weight_o[16][10]),
        .sum_o(sum_o[16][10])
    );

    PE u_pe16_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][10]),
        //Up part
        .weight_i(weight_o[15][11]),
        .sum_i(sum_o[15][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][11]),
        //Down part
        .weight_o(weight_o[16][11]),
        .sum_o(sum_o[16][11])
    );

    PE u_pe16_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][11]),
        //Up part
        .weight_i(weight_o[15][12]),
        .sum_i(sum_o[15][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][12]),
        //Down part
        .weight_o(weight_o[16][12]),
        .sum_o(sum_o[16][12])
    );

    PE u_pe16_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][12]),
        //Up part
        .weight_i(weight_o[15][13]),
        .sum_i(sum_o[15][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][13]),
        //Down part
        .weight_o(weight_o[16][13]),
        .sum_o(sum_o[16][13])
    );

    PE u_pe16_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][13]),
        //Up part
        .weight_i(weight_o[15][14]),
        .sum_i(sum_o[15][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][14]),
        //Down part
        .weight_o(weight_o[16][14]),
        .sum_o(sum_o[16][14])
    );

    PE u_pe16_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[16][14]),
        //Up part
        .weight_i(weight_o[15][15]),
        .sum_i(sum_o[15][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[16][15]),
        //Down part
        .weight_o(weight_o[16][15]),
        .sum_o(sum_o[16][15])
    );

    //'17'th row
    PE u_pe17_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[17]),
        //Up part
        .weight_i(weight_o[16][0]),
        .sum_i(sum_o[16][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][0]),
        //Down part
        .weight_o(weight_o[17][0]),
        .sum_o(sum_o[17][0])
    );

    PE u_pe17_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][0]),
        //Up part
        .weight_i(weight_o[16][1]),
        .sum_i(sum_o[16][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][1]),
        //Down part
        .weight_o(weight_o[17][1]),
        .sum_o(sum_o[17][1])
    );

    PE u_pe17_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][1]),
        //Up part
        .weight_i(weight_o[16][2]),
        .sum_i(sum_o[16][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][2]),
        //Down part
        .weight_o(weight_o[17][2]),
        .sum_o(sum_o[17][2])
    );

    PE u_pe17_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][2]),
        //Up part
        .weight_i(weight_o[16][3]),
        .sum_i(sum_o[16][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][3]),
        //Down part
        .weight_o(weight_o[17][3]),
        .sum_o(sum_o[17][3])
    );

    PE u_pe17_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][3]),
        //Up part
        .weight_i(weight_o[16][4]),
        .sum_i(sum_o[16][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][4]),
        //Down part
        .weight_o(weight_o[17][4]),
        .sum_o(sum_o[17][4])
    );

    PE u_pe17_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][4]),
        //Up part
        .weight_i(weight_o[16][5]),
        .sum_i(sum_o[16][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][5]),
        //Down part
        .weight_o(weight_o[17][5]),
        .sum_o(sum_o[17][5])
    );

    PE u_pe17_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][5]),
        //Up part
        .weight_i(weight_o[16][6]),
        .sum_i(sum_o[16][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][6]),
        //Down part
        .weight_o(weight_o[17][6]),
        .sum_o(sum_o[17][6])
    );

    PE u_pe17_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][6]),
        //Up part
        .weight_i(weight_o[16][7]),
        .sum_i(sum_o[16][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][7]),
        //Down part
        .weight_o(weight_o[17][7]),
        .sum_o(sum_o[17][7])
    );

    PE u_pe17_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][7]),
        //Up part
        .weight_i(weight_o[16][8]),
        .sum_i(sum_o[16][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][8]),
        //Down part
        .weight_o(weight_o[17][8]),
        .sum_o(sum_o[17][8])
    );

    PE u_pe17_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][8]),
        //Up part
        .weight_i(weight_o[16][9]),
        .sum_i(sum_o[16][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][9]),
        //Down part
        .weight_o(weight_o[17][9]),
        .sum_o(sum_o[17][9])
    );

    PE u_pe17_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][9]),
        //Up part
        .weight_i(weight_o[16][10]),
        .sum_i(sum_o[16][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][10]),
        //Down part
        .weight_o(weight_o[17][10]),
        .sum_o(sum_o[17][10])
    );

    PE u_pe17_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][10]),
        //Up part
        .weight_i(weight_o[16][11]),
        .sum_i(sum_o[16][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][11]),
        //Down part
        .weight_o(weight_o[17][11]),
        .sum_o(sum_o[17][11])
    );

    PE u_pe17_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][11]),
        //Up part
        .weight_i(weight_o[16][12]),
        .sum_i(sum_o[16][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][12]),
        //Down part
        .weight_o(weight_o[17][12]),
        .sum_o(sum_o[17][12])
    );

    PE u_pe17_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][12]),
        //Up part
        .weight_i(weight_o[16][13]),
        .sum_i(sum_o[16][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][13]),
        //Down part
        .weight_o(weight_o[17][13]),
        .sum_o(sum_o[17][13])
    );

    PE u_pe17_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][13]),
        //Up part
        .weight_i(weight_o[16][14]),
        .sum_i(sum_o[16][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][14]),
        //Down part
        .weight_o(weight_o[17][14]),
        .sum_o(sum_o[17][14])
    );

    PE u_pe17_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[17][14]),
        //Up part
        .weight_i(weight_o[16][15]),
        .sum_i(sum_o[16][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[17][15]),
        //Down part
        .weight_o(weight_o[17][15]),
        .sum_o(sum_o[17][15])
    );

    //'18'th row
    PE u_pe18_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[18]),
        //Up part
        .weight_i(weight_o[17][0]),
        .sum_i(sum_o[17][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][0]),
        //Down part
        .weight_o(weight_o[18][0]),
        .sum_o(sum_o[18][0])
    );

    PE u_pe18_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][0]),
        //Up part
        .weight_i(weight_o[17][1]),
        .sum_i(sum_o[17][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][1]),
        //Down part
        .weight_o(weight_o[18][1]),
        .sum_o(sum_o[18][1])
    );

    PE u_pe18_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][1]),
        //Up part
        .weight_i(weight_o[17][2]),
        .sum_i(sum_o[17][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][2]),
        //Down part
        .weight_o(weight_o[18][2]),
        .sum_o(sum_o[18][2])
    );

    PE u_pe18_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][2]),
        //Up part
        .weight_i(weight_o[17][3]),
        .sum_i(sum_o[17][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][3]),
        //Down part
        .weight_o(weight_o[18][3]),
        .sum_o(sum_o[18][3])
    );

    PE u_pe18_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][3]),
        //Up part
        .weight_i(weight_o[17][4]),
        .sum_i(sum_o[17][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][4]),
        //Down part
        .weight_o(weight_o[18][4]),
        .sum_o(sum_o[18][4])
    );

    PE u_pe18_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][4]),
        //Up part
        .weight_i(weight_o[17][5]),
        .sum_i(sum_o[17][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][5]),
        //Down part
        .weight_o(weight_o[18][5]),
        .sum_o(sum_o[18][5])
    );

    PE u_pe18_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][5]),
        //Up part
        .weight_i(weight_o[17][6]),
        .sum_i(sum_o[17][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][6]),
        //Down part
        .weight_o(weight_o[18][6]),
        .sum_o(sum_o[18][6])
    );

    PE u_pe18_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][6]),
        //Up part
        .weight_i(weight_o[17][7]),
        .sum_i(sum_o[17][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][7]),
        //Down part
        .weight_o(weight_o[18][7]),
        .sum_o(sum_o[18][7])
    );

    PE u_pe18_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][7]),
        //Up part
        .weight_i(weight_o[17][8]),
        .sum_i(sum_o[17][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][8]),
        //Down part
        .weight_o(weight_o[18][8]),
        .sum_o(sum_o[18][8])
    );

    PE u_pe18_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][8]),
        //Up part
        .weight_i(weight_o[17][9]),
        .sum_i(sum_o[17][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][9]),
        //Down part
        .weight_o(weight_o[18][9]),
        .sum_o(sum_o[18][9])
    );

    PE u_pe18_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][9]),
        //Up part
        .weight_i(weight_o[17][10]),
        .sum_i(sum_o[17][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][10]),
        //Down part
        .weight_o(weight_o[18][10]),
        .sum_o(sum_o[18][10])
    );

    PE u_pe18_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][10]),
        //Up part
        .weight_i(weight_o[17][11]),
        .sum_i(sum_o[17][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][11]),
        //Down part
        .weight_o(weight_o[18][11]),
        .sum_o(sum_o[18][11])
    );

    PE u_pe18_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][11]),
        //Up part
        .weight_i(weight_o[17][12]),
        .sum_i(sum_o[17][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][12]),
        //Down part
        .weight_o(weight_o[18][12]),
        .sum_o(sum_o[18][12])
    );

    PE u_pe18_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][12]),
        //Up part
        .weight_i(weight_o[17][13]),
        .sum_i(sum_o[17][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][13]),
        //Down part
        .weight_o(weight_o[18][13]),
        .sum_o(sum_o[18][13])
    );

    PE u_pe18_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][13]),
        //Up part
        .weight_i(weight_o[17][14]),
        .sum_i(sum_o[17][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][14]),
        //Down part
        .weight_o(weight_o[18][14]),
        .sum_o(sum_o[18][14])
    );

    PE u_pe18_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[18][14]),
        //Up part
        .weight_i(weight_o[17][15]),
        .sum_i(sum_o[17][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[18][15]),
        //Down part
        .weight_o(weight_o[18][15]),
        .sum_o(sum_o[18][15])
    );

    //'19'th row
    PE u_pe19_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[19]),
        //Up part
        .weight_i(weight_o[18][0]),
        .sum_i(sum_o[18][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][0]),
        //Down part
        .weight_o(weight_o[19][0]),
        .sum_o(sum_o[19][0])
    );

    PE u_pe19_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][0]),
        //Up part
        .weight_i(weight_o[18][1]),
        .sum_i(sum_o[18][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][1]),
        //Down part
        .weight_o(weight_o[19][1]),
        .sum_o(sum_o[19][1])
    );

    PE u_pe19_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][1]),
        //Up part
        .weight_i(weight_o[18][2]),
        .sum_i(sum_o[18][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][2]),
        //Down part
        .weight_o(weight_o[19][2]),
        .sum_o(sum_o[19][2])
    );

    PE u_pe19_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][2]),
        //Up part
        .weight_i(weight_o[18][3]),
        .sum_i(sum_o[18][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][3]),
        //Down part
        .weight_o(weight_o[19][3]),
        .sum_o(sum_o[19][3])
    );

    PE u_pe19_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][3]),
        //Up part
        .weight_i(weight_o[18][4]),
        .sum_i(sum_o[18][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][4]),
        //Down part
        .weight_o(weight_o[19][4]),
        .sum_o(sum_o[19][4])
    );

    PE u_pe19_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][4]),
        //Up part
        .weight_i(weight_o[18][5]),
        .sum_i(sum_o[18][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][5]),
        //Down part
        .weight_o(weight_o[19][5]),
        .sum_o(sum_o[19][5])
    );

    PE u_pe19_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][5]),
        //Up part
        .weight_i(weight_o[18][6]),
        .sum_i(sum_o[18][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][6]),
        //Down part
        .weight_o(weight_o[19][6]),
        .sum_o(sum_o[19][6])
    );

    PE u_pe19_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][6]),
        //Up part
        .weight_i(weight_o[18][7]),
        .sum_i(sum_o[18][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][7]),
        //Down part
        .weight_o(weight_o[19][7]),
        .sum_o(sum_o[19][7])
    );

    PE u_pe19_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][7]),
        //Up part
        .weight_i(weight_o[18][8]),
        .sum_i(sum_o[18][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][8]),
        //Down part
        .weight_o(weight_o[19][8]),
        .sum_o(sum_o[19][8])
    );

    PE u_pe19_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][8]),
        //Up part
        .weight_i(weight_o[18][9]),
        .sum_i(sum_o[18][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][9]),
        //Down part
        .weight_o(weight_o[19][9]),
        .sum_o(sum_o[19][9])
    );

    PE u_pe19_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][9]),
        //Up part
        .weight_i(weight_o[18][10]),
        .sum_i(sum_o[18][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][10]),
        //Down part
        .weight_o(weight_o[19][10]),
        .sum_o(sum_o[19][10])
    );

    PE u_pe19_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][10]),
        //Up part
        .weight_i(weight_o[18][11]),
        .sum_i(sum_o[18][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][11]),
        //Down part
        .weight_o(weight_o[19][11]),
        .sum_o(sum_o[19][11])
    );

    PE u_pe19_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][11]),
        //Up part
        .weight_i(weight_o[18][12]),
        .sum_i(sum_o[18][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][12]),
        //Down part
        .weight_o(weight_o[19][12]),
        .sum_o(sum_o[19][12])
    );

    PE u_pe19_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][12]),
        //Up part
        .weight_i(weight_o[18][13]),
        .sum_i(sum_o[18][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][13]),
        //Down part
        .weight_o(weight_o[19][13]),
        .sum_o(sum_o[19][13])
    );

    PE u_pe19_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][13]),
        //Up part
        .weight_i(weight_o[18][14]),
        .sum_i(sum_o[18][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][14]),
        //Down part
        .weight_o(weight_o[19][14]),
        .sum_o(sum_o[19][14])
    );

    PE u_pe19_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[19][14]),
        //Up part
        .weight_i(weight_o[18][15]),
        .sum_i(sum_o[18][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[19][15]),
        //Down part
        .weight_o(weight_o[19][15]),
        .sum_o(sum_o[19][15])
    );

    //'20'th row
    PE u_pe20_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[20]),
        //Up part
        .weight_i(weight_o[19][0]),
        .sum_i(sum_o[19][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][0]),
        //Down part
        .weight_o(weight_o[20][0]),
        .sum_o(sum_o[20][0])
    );

    PE u_pe20_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][0]),
        //Up part
        .weight_i(weight_o[19][1]),
        .sum_i(sum_o[19][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][1]),
        //Down part
        .weight_o(weight_o[20][1]),
        .sum_o(sum_o[20][1])
    );

    PE u_pe20_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][1]),
        //Up part
        .weight_i(weight_o[19][2]),
        .sum_i(sum_o[19][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][2]),
        //Down part
        .weight_o(weight_o[20][2]),
        .sum_o(sum_o[20][2])
    );

    PE u_pe20_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][2]),
        //Up part
        .weight_i(weight_o[19][3]),
        .sum_i(sum_o[19][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][3]),
        //Down part
        .weight_o(weight_o[20][3]),
        .sum_o(sum_o[20][3])
    );

    PE u_pe20_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][3]),
        //Up part
        .weight_i(weight_o[19][4]),
        .sum_i(sum_o[19][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][4]),
        //Down part
        .weight_o(weight_o[20][4]),
        .sum_o(sum_o[20][4])
    );

    PE u_pe20_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][4]),
        //Up part
        .weight_i(weight_o[19][5]),
        .sum_i(sum_o[19][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][5]),
        //Down part
        .weight_o(weight_o[20][5]),
        .sum_o(sum_o[20][5])
    );

    PE u_pe20_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][5]),
        //Up part
        .weight_i(weight_o[19][6]),
        .sum_i(sum_o[19][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][6]),
        //Down part
        .weight_o(weight_o[20][6]),
        .sum_o(sum_o[20][6])
    );

    PE u_pe20_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][6]),
        //Up part
        .weight_i(weight_o[19][7]),
        .sum_i(sum_o[19][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][7]),
        //Down part
        .weight_o(weight_o[20][7]),
        .sum_o(sum_o[20][7])
    );

    PE u_pe20_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][7]),
        //Up part
        .weight_i(weight_o[19][8]),
        .sum_i(sum_o[19][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][8]),
        //Down part
        .weight_o(weight_o[20][8]),
        .sum_o(sum_o[20][8])
    );

    PE u_pe20_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][8]),
        //Up part
        .weight_i(weight_o[19][9]),
        .sum_i(sum_o[19][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][9]),
        //Down part
        .weight_o(weight_o[20][9]),
        .sum_o(sum_o[20][9])
    );

    PE u_pe20_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][9]),
        //Up part
        .weight_i(weight_o[19][10]),
        .sum_i(sum_o[19][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][10]),
        //Down part
        .weight_o(weight_o[20][10]),
        .sum_o(sum_o[20][10])
    );

    PE u_pe20_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][10]),
        //Up part
        .weight_i(weight_o[19][11]),
        .sum_i(sum_o[19][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][11]),
        //Down part
        .weight_o(weight_o[20][11]),
        .sum_o(sum_o[20][11])
    );

    PE u_pe20_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][11]),
        //Up part
        .weight_i(weight_o[19][12]),
        .sum_i(sum_o[19][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][12]),
        //Down part
        .weight_o(weight_o[20][12]),
        .sum_o(sum_o[20][12])
    );

    PE u_pe20_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][12]),
        //Up part
        .weight_i(weight_o[19][13]),
        .sum_i(sum_o[19][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][13]),
        //Down part
        .weight_o(weight_o[20][13]),
        .sum_o(sum_o[20][13])
    );

    PE u_pe20_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][13]),
        //Up part
        .weight_i(weight_o[19][14]),
        .sum_i(sum_o[19][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][14]),
        //Down part
        .weight_o(weight_o[20][14]),
        .sum_o(sum_o[20][14])
    );

    PE u_pe20_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[20][14]),
        //Up part
        .weight_i(weight_o[19][15]),
        .sum_i(sum_o[19][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[20][15]),
        //Down part
        .weight_o(weight_o[20][15]),
        .sum_o(sum_o[20][15])
    );

    //'21'th row
    PE u_pe21_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[21]),
        //Up part
        .weight_i(weight_o[20][0]),
        .sum_i(sum_o[20][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][0]),
        //Down part
        .weight_o(weight_o[21][0]),
        .sum_o(sum_o[21][0])
    );

    PE u_pe21_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][0]),
        //Up part
        .weight_i(weight_o[20][1]),
        .sum_i(sum_o[20][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][1]),
        //Down part
        .weight_o(weight_o[21][1]),
        .sum_o(sum_o[21][1])
    );

    PE u_pe21_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][1]),
        //Up part
        .weight_i(weight_o[20][2]),
        .sum_i(sum_o[20][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][2]),
        //Down part
        .weight_o(weight_o[21][2]),
        .sum_o(sum_o[21][2])
    );

    PE u_pe21_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][2]),
        //Up part
        .weight_i(weight_o[20][3]),
        .sum_i(sum_o[20][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][3]),
        //Down part
        .weight_o(weight_o[21][3]),
        .sum_o(sum_o[21][3])
    );

    PE u_pe21_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][3]),
        //Up part
        .weight_i(weight_o[20][4]),
        .sum_i(sum_o[20][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][4]),
        //Down part
        .weight_o(weight_o[21][4]),
        .sum_o(sum_o[21][4])
    );

    PE u_pe21_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][4]),
        //Up part
        .weight_i(weight_o[20][5]),
        .sum_i(sum_o[20][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][5]),
        //Down part
        .weight_o(weight_o[21][5]),
        .sum_o(sum_o[21][5])
    );

    PE u_pe21_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][5]),
        //Up part
        .weight_i(weight_o[20][6]),
        .sum_i(sum_o[20][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][6]),
        //Down part
        .weight_o(weight_o[21][6]),
        .sum_o(sum_o[21][6])
    );

    PE u_pe21_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][6]),
        //Up part
        .weight_i(weight_o[20][7]),
        .sum_i(sum_o[20][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][7]),
        //Down part
        .weight_o(weight_o[21][7]),
        .sum_o(sum_o[21][7])
    );

    PE u_pe21_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][7]),
        //Up part
        .weight_i(weight_o[20][8]),
        .sum_i(sum_o[20][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][8]),
        //Down part
        .weight_o(weight_o[21][8]),
        .sum_o(sum_o[21][8])
    );

    PE u_pe21_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][8]),
        //Up part
        .weight_i(weight_o[20][9]),
        .sum_i(sum_o[20][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][9]),
        //Down part
        .weight_o(weight_o[21][9]),
        .sum_o(sum_o[21][9])
    );

    PE u_pe21_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][9]),
        //Up part
        .weight_i(weight_o[20][10]),
        .sum_i(sum_o[20][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][10]),
        //Down part
        .weight_o(weight_o[21][10]),
        .sum_o(sum_o[21][10])
    );

    PE u_pe21_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][10]),
        //Up part
        .weight_i(weight_o[20][11]),
        .sum_i(sum_o[20][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][11]),
        //Down part
        .weight_o(weight_o[21][11]),
        .sum_o(sum_o[21][11])
    );

    PE u_pe21_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][11]),
        //Up part
        .weight_i(weight_o[20][12]),
        .sum_i(sum_o[20][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][12]),
        //Down part
        .weight_o(weight_o[21][12]),
        .sum_o(sum_o[21][12])
    );

    PE u_pe21_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][12]),
        //Up part
        .weight_i(weight_o[20][13]),
        .sum_i(sum_o[20][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][13]),
        //Down part
        .weight_o(weight_o[21][13]),
        .sum_o(sum_o[21][13])
    );

    PE u_pe21_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][13]),
        //Up part
        .weight_i(weight_o[20][14]),
        .sum_i(sum_o[20][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][14]),
        //Down part
        .weight_o(weight_o[21][14]),
        .sum_o(sum_o[21][14])
    );

    PE u_pe21_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[21][14]),
        //Up part
        .weight_i(weight_o[20][15]),
        .sum_i(sum_o[20][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[21][15]),
        //Down part
        .weight_o(weight_o[21][15]),
        .sum_o(sum_o[21][15])
    );

    //'22'th row
    PE u_pe22_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[22]),
        //Up part
        .weight_i(weight_o[21][0]),
        .sum_i(sum_o[21][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][0]),
        //Down part
        .weight_o(weight_o[22][0]),
        .sum_o(sum_o[22][0])
    );

    PE u_pe22_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][0]),
        //Up part
        .weight_i(weight_o[21][1]),
        .sum_i(sum_o[21][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][1]),
        //Down part
        .weight_o(weight_o[22][1]),
        .sum_o(sum_o[22][1])
    );

    PE u_pe22_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][1]),
        //Up part
        .weight_i(weight_o[21][2]),
        .sum_i(sum_o[21][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][2]),
        //Down part
        .weight_o(weight_o[22][2]),
        .sum_o(sum_o[22][2])
    );

    PE u_pe22_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][2]),
        //Up part
        .weight_i(weight_o[21][3]),
        .sum_i(sum_o[21][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][3]),
        //Down part
        .weight_o(weight_o[22][3]),
        .sum_o(sum_o[22][3])
    );

    PE u_pe22_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][3]),
        //Up part
        .weight_i(weight_o[21][4]),
        .sum_i(sum_o[21][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][4]),
        //Down part
        .weight_o(weight_o[22][4]),
        .sum_o(sum_o[22][4])
    );

    PE u_pe22_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][4]),
        //Up part
        .weight_i(weight_o[21][5]),
        .sum_i(sum_o[21][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][5]),
        //Down part
        .weight_o(weight_o[22][5]),
        .sum_o(sum_o[22][5])
    );

    PE u_pe22_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][5]),
        //Up part
        .weight_i(weight_o[21][6]),
        .sum_i(sum_o[21][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][6]),
        //Down part
        .weight_o(weight_o[22][6]),
        .sum_o(sum_o[22][6])
    );

    PE u_pe22_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][6]),
        //Up part
        .weight_i(weight_o[21][7]),
        .sum_i(sum_o[21][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][7]),
        //Down part
        .weight_o(weight_o[22][7]),
        .sum_o(sum_o[22][7])
    );

    PE u_pe22_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][7]),
        //Up part
        .weight_i(weight_o[21][8]),
        .sum_i(sum_o[21][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][8]),
        //Down part
        .weight_o(weight_o[22][8]),
        .sum_o(sum_o[22][8])
    );

    PE u_pe22_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][8]),
        //Up part
        .weight_i(weight_o[21][9]),
        .sum_i(sum_o[21][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][9]),
        //Down part
        .weight_o(weight_o[22][9]),
        .sum_o(sum_o[22][9])
    );

    PE u_pe22_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][9]),
        //Up part
        .weight_i(weight_o[21][10]),
        .sum_i(sum_o[21][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][10]),
        //Down part
        .weight_o(weight_o[22][10]),
        .sum_o(sum_o[22][10])
    );

    PE u_pe22_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][10]),
        //Up part
        .weight_i(weight_o[21][11]),
        .sum_i(sum_o[21][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][11]),
        //Down part
        .weight_o(weight_o[22][11]),
        .sum_o(sum_o[22][11])
    );

    PE u_pe22_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][11]),
        //Up part
        .weight_i(weight_o[21][12]),
        .sum_i(sum_o[21][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][12]),
        //Down part
        .weight_o(weight_o[22][12]),
        .sum_o(sum_o[22][12])
    );

    PE u_pe22_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][12]),
        //Up part
        .weight_i(weight_o[21][13]),
        .sum_i(sum_o[21][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][13]),
        //Down part
        .weight_o(weight_o[22][13]),
        .sum_o(sum_o[22][13])
    );

    PE u_pe22_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][13]),
        //Up part
        .weight_i(weight_o[21][14]),
        .sum_i(sum_o[21][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][14]),
        //Down part
        .weight_o(weight_o[22][14]),
        .sum_o(sum_o[22][14])
    );

    PE u_pe22_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[22][14]),
        //Up part
        .weight_i(weight_o[21][15]),
        .sum_i(sum_o[21][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[22][15]),
        //Down part
        .weight_o(weight_o[22][15]),
        .sum_o(sum_o[22][15])
    );

    //'23'th row
    PE u_pe23_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[23]),
        //Up part
        .weight_i(weight_o[22][0]),
        .sum_i(sum_o[22][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][0]),
        //Down part
        .weight_o(weight_o[23][0]),
        .sum_o(sum_o[23][0])
    );

    PE u_pe23_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][0]),
        //Up part
        .weight_i(weight_o[22][1]),
        .sum_i(sum_o[22][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][1]),
        //Down part
        .weight_o(weight_o[23][1]),
        .sum_o(sum_o[23][1])
    );

    PE u_pe23_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][1]),
        //Up part
        .weight_i(weight_o[22][2]),
        .sum_i(sum_o[22][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][2]),
        //Down part
        .weight_o(weight_o[23][2]),
        .sum_o(sum_o[23][2])
    );

    PE u_pe23_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][2]),
        //Up part
        .weight_i(weight_o[22][3]),
        .sum_i(sum_o[22][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][3]),
        //Down part
        .weight_o(weight_o[23][3]),
        .sum_o(sum_o[23][3])
    );

    PE u_pe23_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][3]),
        //Up part
        .weight_i(weight_o[22][4]),
        .sum_i(sum_o[22][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][4]),
        //Down part
        .weight_o(weight_o[23][4]),
        .sum_o(sum_o[23][4])
    );

    PE u_pe23_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][4]),
        //Up part
        .weight_i(weight_o[22][5]),
        .sum_i(sum_o[22][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][5]),
        //Down part
        .weight_o(weight_o[23][5]),
        .sum_o(sum_o[23][5])
    );

    PE u_pe23_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][5]),
        //Up part
        .weight_i(weight_o[22][6]),
        .sum_i(sum_o[22][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][6]),
        //Down part
        .weight_o(weight_o[23][6]),
        .sum_o(sum_o[23][6])
    );

    PE u_pe23_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][6]),
        //Up part
        .weight_i(weight_o[22][7]),
        .sum_i(sum_o[22][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][7]),
        //Down part
        .weight_o(weight_o[23][7]),
        .sum_o(sum_o[23][7])
    );

    PE u_pe23_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][7]),
        //Up part
        .weight_i(weight_o[22][8]),
        .sum_i(sum_o[22][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][8]),
        //Down part
        .weight_o(weight_o[23][8]),
        .sum_o(sum_o[23][8])
    );

    PE u_pe23_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][8]),
        //Up part
        .weight_i(weight_o[22][9]),
        .sum_i(sum_o[22][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][9]),
        //Down part
        .weight_o(weight_o[23][9]),
        .sum_o(sum_o[23][9])
    );

    PE u_pe23_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][9]),
        //Up part
        .weight_i(weight_o[22][10]),
        .sum_i(sum_o[22][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][10]),
        //Down part
        .weight_o(weight_o[23][10]),
        .sum_o(sum_o[23][10])
    );

    PE u_pe23_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][10]),
        //Up part
        .weight_i(weight_o[22][11]),
        .sum_i(sum_o[22][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][11]),
        //Down part
        .weight_o(weight_o[23][11]),
        .sum_o(sum_o[23][11])
    );

    PE u_pe23_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][11]),
        //Up part
        .weight_i(weight_o[22][12]),
        .sum_i(sum_o[22][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][12]),
        //Down part
        .weight_o(weight_o[23][12]),
        .sum_o(sum_o[23][12])
    );

    PE u_pe23_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][12]),
        //Up part
        .weight_i(weight_o[22][13]),
        .sum_i(sum_o[22][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][13]),
        //Down part
        .weight_o(weight_o[23][13]),
        .sum_o(sum_o[23][13])
    );

    PE u_pe23_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][13]),
        //Up part
        .weight_i(weight_o[22][14]),
        .sum_i(sum_o[22][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][14]),
        //Down part
        .weight_o(weight_o[23][14]),
        .sum_o(sum_o[23][14])
    );

    PE u_pe23_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[23][14]),
        //Up part
        .weight_i(weight_o[22][15]),
        .sum_i(sum_o[22][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[23][15]),
        //Down part
        .weight_o(weight_o[23][15]),
        .sum_o(sum_o[23][15])
    );

    //'24'th row
    PE u_pe24_0(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_i[24]),
        //Up part
        .weight_i(weight_o[23][0]),
        .sum_i(sum_o[23][0]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][0]),
        //Down part
        .weight_o(weight_o[24][0]),
        .sum_o(sum_o[24][0])
    );

    PE u_pe24_1(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][0]),
        //Up part
        .weight_i(weight_o[23][1]),
        .sum_i(sum_o[23][1]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][1]),
        //Down part
        .weight_o(weight_o[24][1]),
        .sum_o(sum_o[24][1])
    );

    PE u_pe24_2(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][1]),
        //Up part
        .weight_i(weight_o[23][2]),
        .sum_i(sum_o[23][2]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][2]),
        //Down part
        .weight_o(weight_o[24][2]),
        .sum_o(sum_o[24][2])
    );

    PE u_pe24_3(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][2]),
        //Up part
        .weight_i(weight_o[23][3]),
        .sum_i(sum_o[23][3]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][3]),
        //Down part
        .weight_o(weight_o[24][3]),
        .sum_o(sum_o[24][3])
    );

    PE u_pe24_4(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][3]),
        //Up part
        .weight_i(weight_o[23][4]),
        .sum_i(sum_o[23][4]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][4]),
        //Down part
        .weight_o(weight_o[24][4]),
        .sum_o(sum_o[24][4])
    );

    PE u_pe24_5(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][4]),
        //Up part
        .weight_i(weight_o[23][5]),
        .sum_i(sum_o[23][5]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][5]),
        //Down part
        .weight_o(weight_o[24][5]),
        .sum_o(sum_o[24][5])
    );

    PE u_pe24_6(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][5]),
        //Up part
        .weight_i(weight_o[23][6]),
        .sum_i(sum_o[23][6]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][6]),
        //Down part
        .weight_o(weight_o[24][6]),
        .sum_o(sum_o[24][6])
    );

    PE u_pe24_7(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][6]),
        //Up part
        .weight_i(weight_o[23][7]),
        .sum_i(sum_o[23][7]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][7]),
        //Down part
        .weight_o(weight_o[24][7]),
        .sum_o(sum_o[24][7])
    );

    PE u_pe24_8(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][7]),
        //Up part
        .weight_i(weight_o[23][8]),
        .sum_i(sum_o[23][8]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][8]),
        //Down part
        .weight_o(weight_o[24][8]),
        .sum_o(sum_o[24][8])
    );

    PE u_pe24_9(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][8]),
        //Up part
        .weight_i(weight_o[23][9]),
        .sum_i(sum_o[23][9]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][9]),
        //Down part
        .weight_o(weight_o[24][9]),
        .sum_o(sum_o[24][9])
    );

    PE u_pe24_10(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][9]),
        //Up part
        .weight_i(weight_o[23][10]),
        .sum_i(sum_o[23][10]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][10]),
        //Down part
        .weight_o(weight_o[24][10]),
        .sum_o(sum_o[24][10])
    );

    PE u_pe24_11(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][10]),
        //Up part
        .weight_i(weight_o[23][11]),
        .sum_i(sum_o[23][11]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][11]),
        //Down part
        .weight_o(weight_o[24][11]),
        .sum_o(sum_o[24][11])
    );

    PE u_pe24_12(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][11]),
        //Up part
        .weight_i(weight_o[23][12]),
        .sum_i(sum_o[23][12]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][12]),
        //Down part
        .weight_o(weight_o[24][12]),
        .sum_o(sum_o[24][12])
    );

    PE u_pe24_13(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][12]),
        //Up part
        .weight_i(weight_o[23][13]),
        .sum_i(sum_o[23][13]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][13]),
        //Down part
        .weight_o(weight_o[24][13]),
        .sum_o(sum_o[24][13])
    );

    PE u_pe24_14(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][13]),
        //Up part
        .weight_i(weight_o[23][14]),
        .sum_i(sum_o[23][14]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][14]),
        //Down part
        .weight_o(weight_o[24][14]),
        .sum_o(sum_o[24][14])
    );

    PE u_pe24_15(
        .clk(clk),
        .rst_n(rst_n),
        //Left part
        .data_i(data_o[24][14]),
        //Up part
        .weight_i(weight_o[23][15]),
        .sum_i(sum_o[23][15]),
        .weight_stop(weight_stop),
        //Right part
        .data_o(data_o[24][15]),
        //Down part
        .weight_o(weight_o[24][15]),
        .sum_o(sum_o[24][15])
    );
//


    always_ff @(posedge clk) begin
        if(!rst_n) begin
            cnt <= 'd0;
            accu_valid[0] <= 'd0;
            accu_valid[1] <= 'd0;
            accu_valid[2] <= 'd0;
            accu_valid[3] <= 'd0;
            accu_valid[4] <= 'd0;
            accu_valid[5] <= 'd0;
            accu_valid[6] <= 'd0;
            accu_valid[7] <= 'd0;
            accu_valid[8] <= 'd0;
            accu_valid[9] <= 'd0;
            accu_valid[10] <= 'd0;
            accu_valid[11] <= 'd0;
            accu_valid[12] <= 'd0;
            accu_valid[13] <= 'd0;
            accu_valid[14] <= 'd0;
            accu_valid[15] <= 'd0;

        end
        else begin
            cnt <= cnt_n;
            accu_valid[0] <= accu_valid_n;
            accu_valid[1] <= accu_valid[0];
            accu_valid[2] <= accu_valid[1];
            accu_valid[3] <= accu_valid[2];
            accu_valid[4] <= accu_valid[3];
            accu_valid[5] <= accu_valid[4];
            if(nth_conv_i == 2'b1) begin
                accu_valid[6] <= accu_valid[5];
                accu_valid[7] <= accu_valid[6];
                accu_valid[8] <= accu_valid[7];
                accu_valid[9] <= accu_valid[8];
                accu_valid[10] <= accu_valid[9];
                accu_valid[11] <= accu_valid[10];
                accu_valid[12] <= accu_valid[11];
                accu_valid[13] <= accu_valid[12];
                accu_valid[14] <= accu_valid[13];
                accu_valid[15] <= accu_valid[14];
            end
        end
    end
    reg burst_last_d;
    always_ff @(posedge clk) begin
        if(!rst_n)
            burst_last_d <= 1'b0;
        else
            burst_last_d <= burst_last_i;  
    end

    always_comb begin
        cnt_n = cnt;
        accu_valid_n = accu_valid[0];
        accu_data_o <= sum_o[24];
        
        if(d_valid_i) begin
            cnt_n = cnt + 'd1;
            if(cnt == 'd24) begin
                accu_valid_n = 1'b1;
            end
            end
            if(burst_last_d) begin
                accu_valid_n = 1'b0;
                cnt_n = 'd0;
            end
        
    end


endmodule