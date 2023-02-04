//version 2022-01-19
//editor IM SUHYEOK

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
    input   wire    [17:0]  addra,
    input   wire    [7:0]   dia,

    //ACC interface
    output  reg     [31:0]  accu_data_o[15:0],
    output  reg             accu_valid_o[15:0]
);

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            for(int i=0; i<16; i++) begin
                accu_data_o[i]  <= 'd0;
                accu_valid_o[i] <= 'd0;
            end
            
        end
        else begin
            accu_data_o     <= accu_data;
            accu_valid_o    <= accu_valid;
        end
        
    end

    wire            [31:0]  accu_data[15:0];
    wire            accu_valid[15:0];

    wire            burst_last;

    wire            [7:0] sa_data_o[25];
    wire            [7:0] sa_data_i[24:0];
    wire            data_valid_o[25];
    wire            data_valid_i[24:0];
    wire            data_enable;
    wire            conv_done;


    DATAINPUT_TOP #
    (
        .SRAM_DEPTH(1176),
        .BAND_WIDTH(25),
        .DATA_WIDTH(8)
    )
    u_DATA_TOP
    (
       .clk                         (clk),
       .rst                         (!rst_n),
       .nth_conv_i                  (nth_conv_i),
       .wea                         ((addra[17:16]=='b00) && wea),
       .addra                       (addra[15:0]),
       .dia                         (dia),
       .ofmap_size_i                (ofmap_size_i),
       .weight_ready_i              (data_enable),
       .data_valid_o                (data_valid_o),
       .sa_data_o                   (sa_data_o),
       .burst_last_o                (burst_last),
       .conv_done_o                 (conv_done)  
    );


    genvar i;
    generate 
        for(i = 0; i<25; i++) begin
            assign sa_data_i[i]     = sa_data_o[i];
            assign data_valid_i[i]  = data_valid_o[i];
        end
    endgenerate


    WT_TOP #
    (
        .SRAM_DEPTH(256),
        .BAND_DT_WIDTH(25),
        .BAND_WT_WIDTH(16),
        .DATA_WIDTH(8)
    )
    u_WT_TOP
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start),
        .nth_conv_i(nth_conv_i),
        .burst_last_i(burst_last),
        .data_i(sa_data_i),
        .wea((addra[17:16]=='b01) && wea),
        .dia(dia),
        .addra(addra[11:0]),
        .data_valid_i(data_valid_i),
        .conv_done_i(conv_done),
        .data_enable_o(data_enable),
        .accu_data_o(accu_data),
        .accu_valid_o(accu_valid)
    );

endmodule