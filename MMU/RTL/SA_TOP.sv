// SA_TOP
// JY Lee
// Version 2023-01-10 1st verified

module SA_TOP
(
    input   wire            clk,
    input   wire            rst_n,
    //config
    input   wire            start,
    input   wire            nth_conv_i,
    //datasetup(tmp)
    input   wire            data_last,
    output  reg             data_enable_o,
    input   wire    [7:0]   data_i[24:0],
    input   wire            dvalid_i,
    input   wire            burst_last_i,

    //BRAM_Weight buffer interface
    output  reg             w_enable[15:0],
    output  reg     [5:0]   w_addr[15:0],
    input   wire    [7:0]   w_data_i[15:0],

    //ACC interface
    output  reg             accu_valid[15:0]

);
    // reg             data_enable_o;
    reg             nth_conv_o;
    reg             weight_start_o;
    reg             weight_stop_o;
    // reg             w_enable[15:0];
    // reg     [5:0]   w_addr[15:0];
    reg     [7:0]       w_data_o[15:0];

    SA_ctrl u_sa_ctrl(
        .clk(clk),
        .rst_n(rst_n),
        //config
        .start(start),
        .nth_conv_i(nth_conv_i),
        //data setup
        .data_last(data_last),
        .d_valid_i(dvalid_i),
        .data_enable(data_enable_o),
        //weight buffer
        .nth_conv_o(nth_conv_o),
        .weight_start(weight_start_o),
        //SA
        .weight_stop(weight_stop_o)
    );
    
    SA u_sa(
        .clk(clk),
        .rst_n(rst_n),
        //DATA part interface
        .data_i(data_i),
        .d_valid_i(dvalid_i),
        .burst_last_i(burst_last_i),
        //Weight part interface(weight buffer)
        .weight_i(w_data_o),
        //ctrl interface
        .weight_stop(weight_stop_o),
        //accumulator interface
        .accu_valid(accu_valid)
    );

    weight_buffer u_weight_buffer(
        .clk(clk),
        .rst_n(rst_n),
        //SActrl-Weight_buffer interface
        .nth_conv_i(nth_conv_o),
        .weight_start(weight_start_o),
        //BRAM-Weight_buffer interface
        .w_enable(w_enable),
        .w_addr(w_addr),
        .w_data_i(w_data_i),
        //Weight_buffer-SA interface
        .w_data_o(w_data_o)
    );


endmodule