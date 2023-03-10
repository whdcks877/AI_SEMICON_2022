// 2023-01-12 2nd verified by JY Lee
// 2023-01-13 3rd verified by JY Lee

`define     CH_SIZE         1      //setting input channel size
`define     OFMAP_SIZE      28*28     //setting ouput feature map size
`define     OFMAP_SIZE_SQRT 28
`define     FC_SIZE         120
`define     N_COL           16

`define     TIMEOUT_CYCLE           10000000

module TB_TOP();
    reg            clk;
    reg            rst_n;
    

    logic    [1:0]   start; 
    logic    [1:0]   nth_conv_i;

    logic  [4:0]                   ofmap_size_i;
    logic  [5:0]                   ifmap_ch_i;

    logic    [6:0]   in_node_num_i; 
    logic    [6:0]   out_node_num_i;

    logic            wea;
    logic    [16:0]  addra;
    logic    [7:0]   dia;

    logic                         sa_data_rden_i;
    logic [13:0]                  sa_data_rdptr_i;
    logic                         fc_data_rden_i;
    logic [9:0]                   fc_data_rdptr_i;
    logic                         pool_address_rden_i;
    logic [13:0]                  pool_address_rdptr_i;
    logic [7:0]                     sa_data_rdata_o;
    logic [7:0]                  fc_data_rdata_o;
    logic [9:0]                   pool_address_rdata_o;

    logic [15:0]                  pool_last_o,
    logic                         act_last_o



    logic [`DATA_WIDTH-1:0] img [1024] = {55, -109, 89, 125, 123, 76, 56, -106, 107, -66, 54, -72, -128, -77, 97, -106, -44, -48, 73, -96, -23, -56, -124, 21, -48, -3, -27, -102, 62, -32, 93, -87, -75, -93, 17, 124, 19, -102, -13, 35, -10, 44, 119, -21, -76, -100, 43, -93, -10, -73, 77, -36, 81, -77, -13, -54, -15, -49, -123, 2, 76, -94, -78, -108, -71, 24, -56, 31, 67, -48, -51, 31, -34, -76, -108, -19, 53, -34, -105, -27, 103, -36, 115, 109, -4, 88, 126, 38, 80, -41, 73, -33, 33, 4, -62, -44, 47, -117, 123, -128, 36, 57, -118, 4, 87, -117, -113, -36, -11, 56, -102, 89, -5, 123, 31, 106, -112, 26, 109, -63, -100, 18, -45, -53, -43, 10, 48, -92, -63, 125, -4, 66, -31, 108, -60, 60, -94, -22, -77, 19, -43, -120, -11, -44, -3, 74, 45, 0, -14, -34, -104, 18, 56, -2, -72, -123, -61, -45, -45, -27, 67, 77, -106, 84, -86, -114, 87, 123, -97, -30, -32, 108, 84, -28, -50, 27, 9, 1, -19, 8, -2, -84, 47, -97, -73, 68, -87, -96, 110, 86, 6, 90, 5, 73, -104, -42, 32, -65, -31, -123, -121, -32, 12, 77, -31, -80, -114, 93, -105, 126, 94, -13, 26, 35, 49, 22, -67, -70, 18, -128, 74, -98, -74, -56, 96, -11, -3, -24, 54, -88, 68, -26, 90, 3, -54, -126, -74, 6, 22, -29, 19, 20, 124, 44, -83, 56, -93, 19, -69, 75, 126, 108, 74, -79, -2, 125, -114, 66, 98, 33, -85, 21, -117, 8, 45, -91, -58, -84, -8, -75, 68, -98, 63, -18, -49, -28, -5, -87, 42, -8, 124, 60, -83, -70, 110, 111, 93, 70, 78, -92, 81, -127, 90, -5, 45, -1, 47, 25, -27, -92, 82, 87, -116, -101, -91, -80, -2, 105, -88, 54, -30, -109, 96, 121, 45, 104, -2, -54, -67, -2, -50, 59, 22, 78, -63, 49, -96, 13, -90, 126, -60, -111, 110, 3, 100, 112, 14, 35, 67, -56, -101, 29, -48, 102, 118, -67, 40, -105, -8, -124, 119, -3, 78, -64, -48, 106, 77, -49, 107, -91, 52, 43, 33, -93, -18, 49, 94, 31, -11, 7, -49, 83, 19, 41, 19, -58, -123, 56, 44, -58, 114, 84, 20, 90, -45, -41, 98, -79, 125, 57, 42, -66, -45, 49, -57, -79, -14, 113, -82, -33, 37, 5, -113, 43, -81, 3, 90, 19, -14, -112, 111, 14, -11, 89, -58, 22, -119, -95, -67, -83, 75, -84, 42, -54, 111, -121, -119, 47, -79, -104, 120, 105, -31, 9, -56, 16, 122, 118, 94, -101, 71, 57, 43, -36, 89, 60, -101, -116, 91, 31, 66, -1, -48, 98, -22, -125, 91, 44, -69, -10, -38, 54, -50, -127, 45, 8, 42, 48, 26, 59, -115, 72, -121, -28, 126, -87, 89, -1, -46, -3, 46, -11, 26, 72, 21, 101, 78, 87, -7, -2, 70, -66, 78, -126, -19, -117, 71, -69, -3, -122, 2, 62, 116, -118, -111, 66, -93, 51, 11, -20, -75, -18, 84, 118, 118, -88, 20, -52, -20, 2, 15, -66, 71, 14, -111, 17, 98, 96, 40, 99, 95, -80, -28, 23, 96, -98, -74, 14, -80, 43, -103, -12, 74, -3, 27, -87, -28, -67, -29, -77, 42, 21, -116, -59, 53, -45, -8, 21, -11, 103, 105, -31, 26, 44, -59, 93, 80, 66, 51, 10, -117, 18, -82, 4, 83, -110, -67, -19, 80, -68, -83, 125, -50, 97, -11, -48, 82, 121, 119, -125, 82, -45, -48, 100, 49, 100, 80, 88, -87, 55, -73, 58, -51, 96, 60, -105, -27, 17, 64, -80, -94, 77, -114, 31, 29, -97, -71, -118, 113, 22, 99, -98, -87, -3, 90, 9, -84, -60, 4, 83, 4, -107, 121, 87, -125, -51, 125, 119, 60, 40, -109, 21, -58, -26, -10, 79, 123, -44, -86, 121, 89, -108, 38, 57, -79, 95, 7, 10, 93, -8, -82, -29, -101, 80, -122, -56, -47, 102, 6, 41, 111, -24, -50, -84, 60, -7, -111, 9, -115, 91, 8, 117, -17, 104, -30, -113, 57, -17, 104, 9, 72, 28, 64, 42, 89, 116, 110, -97, -51, 54, -123, 25, 109, 19, -88, -120, -118, -91, -26, -78, 21, -127, -99, -117, 48, -7, -27, -94, -51, 70, -107, 91, -115, 106, 121, -83, -32, 114, 30, 2, 23, 69, 115, -16, -26, -44, 4, -43, 85, 72, 126, 100, 104, -72, 119, -1, 12, -46, -112, -63, -105, 79, 66, -31, -4, 2, -86, 33, 56, -74, 3, 33, -112, -103, 33, 92, -21, 32, -111, 56, 106, 126, -90, 113, 9, -4, 111, 126, -55, -117, -126, -13, -108, 20, 33, -108, -58, -109, 10, -70, 97, 126, 105, -115, -66, -123, -69, 19, -40, -90, -77, 73, -97, 77, -44, -61, -59, 59, 65, -75, 11, 105, 103, -68, -27, 56, -128, 120, 10, 13, 77, 20, 109, 114, 98, -54, -14, -116, -79, 65, 9, -67, 83, 20, -74, 83, -100, -70, 62, -16, -52, -104, -27, 107, 105, 73, 14, -67, -67, 93, -65, -4, -87, 79, -103, -10, -16, -47, 26, -85, 60, 122, 119, -81, 27, -45, 81, 89, 94, 36, -23, -66, -107, 32, 11, -75, -43, 50, 63, 39, 55, -25, 94, 63, -32, 25, 112, 18, -117, -23, 64, -8, 76, -100, 78, 26, 22, 71, -128, -105, -36, -60, 13, -111, -22, 59, -7, -88, 42, 38, -47, -60, 104, 52, -17, 119, -105, -126, 122, 84, 20, -19, 15, -116, 50, -41, -11, -71, -81, -90, 113, 65, -97, -69, -75, 52, -116, -44, -69, -66, 33, 87, -81, 48, 69, 101, 19, 71, 21, -26, 53, 34, 45, 76, -43, 109, -27, 74, 42, 5, -60, -62, 95, -85, 20, 92, -52, 16, -55, -5, -4, -80, 23, -68, -86, 70, 43, -43, -41, -5, 22, -26, 103, 38, -42, -82, 82, -54, -82, -70, 13, -45, 13, 87, -88, -115, 123, -54, 28, -108, -61, 121, 9, 78, 112, 75, -108, -41, -50, 118, -89, -22, 92, 92, 81, 81, -121, -13, -57, 44, 97, -25, 60, 30};
    logic [`DATA_WIDTH-1:0] filter [6][25] ='{  '{3, 82, -37, 43, 86, 117, -76, -19, 57, 54, -4, -117, 68, 52, -8, 28, 107, -81, 2, 27, 125, -63, 81, 95, -6},
                            '{48, 88, -86, 29, 44, -45, -99, -46, -48, -113, -116, -122, 126, -48, -101, 107, -127, 7, -30, -35, -95, 122, -48, 113, -104},
                            '{-53, -122, -86, -44, -59, 33, 44, -58, 22, 28, -85, 98, 80, -70, 59, 50, -87, 123, -66, 92, -79, 115, -20, -98, 70},
                            '{125, -26, -57, 91, 88, 112, 81, 80, -97, 73, -107, 2, 60, 31, 117, -92, -32, -35, 34, -68, 13, -28, 42, 91, 25},
                            '{-68, -61, 23, -97, 8, 124, -20, -84, -7, 55, 109, -53, -57, 75, -127, -83, 81, -57, 95, 19, -125, -81, 5, -11, -86},
                           ' {92, 104, 103, 41, 87, -70, 66, -94, 29, 50, 82, -18, -113, -114, 15, 102, 113, -88, -16, -79, -15, 55, -82, 81, 108}};

    logic [`DATA_WIDTH-1:0] output_ref[6][196] = '{ '{69, 115, 69, 97, 121, 55, 72, 77, 95, 49, 120, 94, 59, 108, 120, 111, 40, 121, 123, 30, 82, 92, 100, 98, 24, 67, 0, 115, 125, 108, 77, 120, 77, 91, 0, 126, 13, 32, 119, 106, 23, 93, 0, 113, 91, 70, 110, 105, 61, 76, 105, 102, 75, 52, 123, 0, 36, 123, 85, 95, 71, 125, 96, 95, 0, 54, 69, 73, 112, 84, 0, 42, 126, 67, 124, 27, 4, 42, 87, 118, 64, 19, 84, 127, 112, 108, 119, 110, 108, 31, 28, 115, 69, 117, 110, 102, 72, 121, 112, 91, 22, 56, 97, 127, 0, 16, 85, 16, 92, 103, 77, 118, 93, 43, 81, 106, 94, 45, 114, 0, 0, 98, 55, 124, 59, 118, 40, 63, 68, 123, 0, 76, 41, 72, 83, 59, 121, 95, 104, 63, 58, 109, 101, 106, 93, 127, 101, 127, 76, 95, 72, 123, 33, 110, 98, 99, 46, 58, 115, 111, 75, 113, 103, 94, 120, 36, 30, 127, 76, 97, 114, 36, 120, 62, 76, 3, 70, 74, 13, 80, 90, 15, 82, 85, 67, 14, 98, 127, 109, 123, 82, 111, 65, 119, 116, 25},
                                '{112, 82, 122, 113, 50, 60, 116, 89, 0, 66, 103, 0, 84, 114, 107, 101, 99, 83, 126, 19, 0, 82, 72, 103, 92, 94, 92, 40, 30, 122, 92, 84, 0, 119, 72, 34, 43, 110, 95, 108, 68, 118, 85, 33, 83, 17, 118, 120, 122, 42, 84, 107, 50, 90, 114, 71, 19, 88, 0, 0, 54, 76, 89, 104, 96, 93, 31, 113, 87, 127, 46, 69, 101, 118, 110, 81, 26, 110, 64, 15, 98, 113, 92, 117, 123, 0, 101, 98, 6, 74, 127, 89, 126, 117, 126, 94, 89, 103, 95, 108, 94, 99, 118, 53, 77, 113, 7, 124, 83, 82, 91, 0, 17, 124, 59, 107, 127, 127, 121, 30, 37, 70, 102, 96, 0, 115, 127, 50, 53, 83, 84, 63, 93, 75, 104, 84, 21, 124, 73, 107, 82, 82, 58, 82, 123, 85, 18, 11, 125, 61, 114, 80, 62, 50, 108, 98, 105, 116, 62, 94, 118, 75, 104, 104, 40, 34, 111, 116, 44, 127, 51, 65, 88, 85, 116, 80, 108, 104, 126, 61, 45, 82, 79, 89, 5, 59, 96, 88, 52, 101, 76, 124, 10, 32, 99, 64},
                                '{109, 120, 68, 121, 123, 11, 43, 116, 87, 106, 109, 106, 96, 48, 109, 69, 99, 112, 113, 37, 118, 55, 112, 118, 104, 31, 11, 10, 91, 0, 97, 112, 85, 117, 0, 110, 127, 116, 20, 26, 85, 11, 38, 86, 62, 100, 93, 34, 78, 107, 5, 35, 105, 100, 101, 106, 30, 125, 71, 91, 24, 69, 108, 32, 118, 75, 54, 112, 96, 124, 0, 122, 44, 34, 75, 89, 12, 99, 20, 24, 89, 49, 81, 126, 118, 101, 95, 82, 122, 78, 91, 96, 0, 125, 91, 121, 91, 81, 96, 96, 120, 85, 93, 122, 0, 81, 113, 0, 89, 30, 39, 52, 118, 87, 69, 112, 86, 119, 2, 88, 124, 82, 99, 118, 44, 67, 113, 0, 97, 97, 11, 0, 70, 94, 51, 69, 43, 0, 82, 119, 122, 124, 120, 67, 104, 22, 44, 32, 119, 102, 100, 127, 112, 90, 108, 121, 74, 103, 88, 30, 94, 94, 119, 107, 109, 57, 87, 117, 99, 37, 27, 126, 121, 0, 115, 99, 88, 109, 96, 110, 55, 96, 59, 85, 0, 72, 94, 59, 111, 76, 7, 112, 125, 108, 84, 119},
                                '{0, 60, 33, 109, 127, 79, 84, 78, 53, 97, 120, 109, 123, 33, 122, 118, 117, 0, 73, 112, 55, 0, 18, 79, 62, 110, 69, 109, 94, 90, 0, 54, 115, 123, 87, 95, 114, 42, 87, 122, 34, 104, 108, 72, 51, 8, 95, 88, 84, 80, 80, 78, 13, 56, 0, 43, 100, 120, 24, 62, 84, 46, 115, 117, 78, 93, 122, 120, 121, 101, 83, 61, 125, 53, 59, 91, 95, 32, 94, 118, 78, 116, 0, 116, 127, 99, 85, 124, 70, 113, 58, 43, 6, 72, 102, 73, 87, 94, 126, 11, 101, 93, 101, 120, 105, 93, 93, 41, 64, 115, 82, 69, 62, 37, 44, 43, 79, 67, 96, 91, 92, 96, 90, 20, 120, 68, 96, 109, 113, 99, 108, 115, 0, 93, 77, 90, 48, 72, 93, 53, 112, 125, 51, 112, 77, 99, 65, 117, 122, 46, 109, 98, 21, 101, 58, 66, 0, 6, 23, 6, 30, 0, 100, 0, 38, 19, 81, 93, 107, 97, 92, 124, 57, 78, 117, 86, 74, 87, 59, 84, 117, 92, 97, 35, 127, 122, 0, 91, 115, 119, 65, 21, 50, 37, 95, 87},
                                '{62, 57, 59, 29, 124, 126, 106, 119, 125, 124, 102, 51, 105, 109, 0, 12, 0, 78, 108, 33, 110, 95, 110, 127, 96, 96, 54, 114, 121, 124, 113, 121, 60, 0, 0, 107, 119, 82, 78, 0, 59, 107, 94, 101, 74, 106, 62, 81, 53, 100, 6, 86, 76, 69, 87, 96, 121, 65, 108, 80, 102, 49, 79, 90, 76, 119, 61, 108, 35, 67, 69, 11, 61, 29, 37, 52, 92, 120, 0, 121, 0, 79, 112, 105, 72, 101, 124, 89, 1, 105, 97, 106, 86, 73, 104, 12, 118, 22, 103, 124, 37, 113, 89, 2, 16, 71, 19, 82, 54, 115, 117, 83, 115, 97, 0, 0, 52, 102, 122, 85, 111, 51, 69, 8, 65, 0, 126, 59, 89, 26, 73, 111, 110, 73, 111, 110, 83, 0, 17, 32, 64, 55, 50, 13, 33, 127, 101, 74, 72, 11, 65, 60, 122, 80, 94, 57, 106, 127, 46, 125, 105, 89, 73, 26, 125, 125, 11, 122, 103, 15, 110, 112, 26, 68, 82, 118, 80, 59, 112, 108, 0, 0, 66, 87, 80, 97, 56, 44, 49, 118, 92, 106, 124, 88, 79, 91},
                                '{10, 74, 96, 122, 95, 83, 110, 39, 120, 105, 1, 83, 0, 127, 49, 91, 112, 122, 99, 27, 21, 23, 98, 71, 0, 124, 74, 97, 119, 105, 63, 120, 106, 0, 112, 60, 98, 114, 81, 0, 77, 97, 105, 89, 0, 96, 92, 85, 97, 38, 116, 44, 46, 124, 95, 125, 114, 122, 84, 38, 125, 114, 105, 29, 90, 101, 125, 91, 73, 95, 54, 48, 127, 111, 112, 101, 82, 0, 83, 118, 106, 109, 15, 46, 12, 96, 121, 103, 75, 63, 113, 44, 40, 0, 0, 48, 103, 123, 125, 114, 110, 93, 122, 126, 0, 111, 97, 121, 119, 120, 0, 101, 110, 71, 95, 33, 117, 118, 52, 115, 94, 95, 71, 111, 101, 65, 99, 2, 2, 0, 99, 37, 87, 77, 123, 96, 80, 69, 121, 112, 101, 103, 104, 91, 114, 109, 0, 61, 0, 109, 87, 90, 111, 1, 80, 95, 75, 16, 122, 58, 115, 65, 31, 116, 46, 119, 115, 72, 113, 97, 115, 106, 75, 80, 94, 75, 32, 122, 0, 66, 77, 106, 72, 90, 104, 46, 12, 97, 64, 89, 119, 7, 105, 106, 71, 41}};
    logic [`DATA_WIDTH-1:0] output_captured [6][196];
    
    int in_node_num= 0;
    int out_node_num = 0;

    ACC_IF_x16 acc_if (.clk(clk), .rst_n(rst_n));
    fc_ifmap_buf_if ifbuf_if(.clk(clk), .rst_n(rst_n));
    fc_w_buf_if wbuf_if(.clk(clk), .rst_all(rst_n));

        TOP u_dut(
            .clk(clk),
            .rst_n(rst_n),
            .start(start), 
            .nth_conv_i(nth_conv_i),
            .ofmap_size_i(acc_if.ofmap_size),
            .ifmap_ch_i(acc_if.ifmap_ch),
            .in_node_num_i(in_node_num_i),
            .out_node_num_i(out_node_num_i),
            .wea(wea),
            .addra(addra),
            .dia(dia),
            .wbuf_wren_i(wbuf_if.wren_i),
            .wbuf_wrptr_i(wbuf_if.wrptr_i),
            .wbuf_wdata_i(wbuf_if.weight_i),
            .ifmap_wren_i(ifbuf_if.wren_i),
            .ifmap_wrptr_i(ifbuf_if.wrptr_i),
            .ifmap_wdata_i(ifbuf_if.ifmap_i),
            .sa_data_rden_i(sa_data_rden_i),
            .sa_data_rdptr_i(sa_data_rdptr_i),
            .fc_data_rden_i(fc_data_rden_i),
            .fc_data_rdptr_i(fc_data_rdptr_i),
            .pool_address_rden_i(pool_address_rden_i),
            .pool_address_rdptr_i(pool_address_rdptr_i),
            .sa_data_rdata_o(sa_data_rdata_o),
            .fc_data_rdata_o(fc_data_rdata_o),
            .pool_address_rdata_o(pool_address_rdata_o)
            .pool_last_o(pool_last_o),
            .act_last_o(act_last_o)
        );


    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end


    task test_init_fc();
        in_node_num= 0;
        out_node_num = 0;

        wbuf_if.init();
        ifbuf_if.init();

        acc_if.init(`OFMAP_SIZE_SQRT,`CH_SIZE);
    endtask


    task test_init();    // active at time 0
            wea                     = 1'b0;
            dia                     = 'd0;
            addra                   = 'h0;
            start                   = 1'b0;
            nth_conv_i              = 'd0;

            sa_data_rden_i = 0;
            sa_data_rdptr_i = 0;
            fc_data_rden_i = 0;
            fc_data_rdptr_i = 0;
            pool_address_rden_i = 0;
            pool_address_rdptr_i = 0;

            rst_n                   = 1'b0;
            repeat (3) @(posedge clk);
            rst_n               = 1'b1;

    endtask

    initial begin
        test_init();
        test_init_fc();

        
        for (int i =0; i<25; i++) begin
            for(int j=0; j<1024; j++) begin

                addra <= (i<<11) + j;
                dia <= img[j];
                wea                 <= 1'b1;
                @(posedge clk);
               wea                 <= 1'b0;
            end
        end

 
        dia                 = 'd0;

        @(posedge clk);

        
        for(int i = 0; i<6; i++) begin
            for(int j=0; j<25; j++) begin
                addra <= (1<<16) + (i<<6) + j;
                dia <= filter[i][24-j];
                wea                 <= 1'b1;
                @(posedge clk);
                 wea                 <= 1'b0;
            end
        end
       
        dia                 = 'd0;
        
        @(posedge clk);

        start                       <= 'd1;
        nth_conv_i                  <= 'd0;
        @(posedge clk);
        start                       <= 'd0; 

        repeat (100000) @(posedge clk);

        for(int i = 0; i<6; i++) begin
            for(int j = 0; j < `OFMAP_SIZE/4; j++ ) begin
                
                sa_data_rdptr_i = (i<<10) + j;
                sa_data_rden_i = 1;
                @(posedge clk);
                sa_data_rden_i = 0;
                #1
                $display("%d||  %dth : %d,      answer: %d",i,j,sa_data_rdata_o, output_ref[i][j]);
                if(sa_data_rdata_o != output_ref[i][j]) begin
                    $display("mismatch!");
                end
            end
        end

        repeat (3) @(posedge clk);
        $finish;
    end
endmodule