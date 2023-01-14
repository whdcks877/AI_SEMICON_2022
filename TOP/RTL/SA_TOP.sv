// SA_TOP
// JY Lee, SM Park
// Version 2023-01-10 1st verified
// 2023-01-12 2nd verified
// 2023-01-14 4th verified

module SA_TOP
(
    input   wire            clk,
    input   wire            rst_n,
    //config
    input   wire            start,
    input   wire    [1:0]   nth_conv_i,
    input   wire    [4:0]   ofmap_size_i,

    //weight_bram write
    input   wire            wea,
    input   wire    [16:0]  addra,
    input   wire    [7:0]   dia,

    //ACC interface
    output  reg     [7:0]   accu_data_o[15:0],
    output  reg             accu_valid[15:0]

);
    wire            data_enable_o;
    wire            nth_conv_o;
    wire            weight_start_o;
    wire            weight_stop_o;
    wire            w_enable[15:0];
    wire    [5:0]   w_addr[15:0];
    wire    [7:0]   w_data_i[15:0];
    wire    [7:0]   w_data_o[15:0];

    wire    [7:0]   data_i[25];
    wire            burst_last;
    wire            data_valid[25];

    reg    [10:0]  BURST_SIZE;

    always_comb begin
        if(!rst_n) begin
            BURST_SIZE      = 'd0;
        end
        else begin
            if(nth_conv_i == 'd0) begin
                BURST_SIZE      = 'd784;
            end
            else if(nth_conv_i == 'd1) begin
                BURST_SIZE      = 'd1176;
            end
            else if(nth_conv_i == 'd2) begin
                BURST_SIZE      = 'd400;
            end
        end
    end

    DATAINPUT_TOP #
    (
        .SRAM_DEPTH(1176),
        .BAND_WIDTH(25),
        .DATA_WIDTH(8)
    )
    u_dut
    (
       .clk                         (clk),
       .rst                         (!rst_n),

       .wea                         ((addra[16:16]=='b0) && wea),
       .addra                       (addra[15:0]),
       .dia                         (dia),
       .BURST_SIZE                  (BURST_SIZE),
       .ofmap_size_i                (ofmap_size_i),
       .weight_ready_i              (data_enable_o),
       .data_valid_o                (data_valid),
       .sa_data_o                   (data_i),
       .burst_last_o                (burst_last)  
    );

    SA_ctrl u_sa_ctrl(
        .clk(clk),
        .rst_n(rst_n),
        //config
        .start(start),
        .nth_conv_i(nth_conv_i[0:0]),
        //data setup
        .data_last(burst_last),
        .d_valid_i(data_valid[0]||data_valid[24]),
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
        .data_i({data_i[24], data_i[23], data_i[22], data_i[21], data_i[20], data_i[19], data_i[18], data_i[17], data_i[16], data_i[15], data_i[14], data_i[13], data_i[12], data_i[11], data_i[10], data_i[9], data_i[8], data_i[7], data_i[6], data_i[5], data_i[4], data_i[3], data_i[2], data_i[1], data_i[0]}),
        .d_valid_i(data_valid[0]||data_valid[24]),
        .burst_last_i(burst_last),
        //Weight part interface(weight buffer)
        .weight_i(w_data_o),
        //ctrl interface
        .weight_stop(weight_stop_o),
        //accumulator interface
        .accu_data_o(accu_data_o),
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
    //MSB 4bit => column, LSB 6bit => row
    weight_bram u_weight_bram(
        .clk(clk),
        .wea((addra[16:15]=='b01) && wea),
        .enb(w_enable),
        .addra(addra[9:0]),
        .addrb(w_addr),
        .dia(dia),
        .dob(w_data_i)
    );
endmodule