`define     TIMEOUT_CYCLE           10000000
module TB_DMA_v2();

    logic  clk;
    logic  rst_n;
    
    logic  [1:0] start;                                                     // last signal of Pooling
    logic  [1:0] nth_conv_i;

    //src (a)
    logic sa_data_rden_o;
    logic [13:0]  sa_data_rdptr_o;
    logic [7:0]  sa_data_rdata_i;

    logic fc_data_rden_o;
    logic [9:0]  fc_data_rdptr_o;
    logic [7:0]  fc_data_rdata_i;

    //dst (b)
    logic    sa_wea_o;
    logic    [16:0] sa_addra_o;
    logic    [7:0]   sa_dia_o;

    logic    ifmap_wren_o;
    logic    [9:0] ifmap_wrptr_o;
    logic    [7:0] ifmap_wdata_o;

    logic  dma_done_o;


    
    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    BRAM_DMA_v2 u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .nth_conv_i(nth_conv_i),
        .sa_data_rden_o(sa_data_rden_o),
        .sa_data_rdptr_o(sa_data_rdptr_o),
        .sa_data_rdata_i(sa_data_rdata_i),
        .fc_data_rden_o(fc_data_rden_o),
        .fc_data_rdptr_o(fc_data_rdptr_o),
        .fc_data_rdata_i(fc_data_rdata_i),
        .sa_wea_o(sa_wea_o),
        .sa_addra_o(sa_addra_o),
        .sa_dia_o(sa_dia_o),
        .ifmap_wren_o(ifmap_wren_o),
        .ifmap_wrptr_o(ifmap_wrptr_o),
        .ifmap_wdata_o(ifmap_wdata_o),
        .dma_done_o(dma_done_o)
    );

    initial begin
        start= 0;
        nth_conv_i = 0;
        sa_data_rdata_i = 0;
        fc_data_rdata_i=0;
        rst_n=0;
        repeat(3) @(posedge clk);
        rst_n=1;
        repeat(3) @(posedge clk);

        start= 1;
        nth_conv_i = 0;
        @(posedge clk);
        #1
        start= 0;

        repeat(3000) @(posedge clk);

        start= 1;
        nth_conv_i = 1;
        @(posedge clk);
        #1
        start= 0;

         repeat(3000) @(posedge clk);

        start= 2;
        nth_conv_i = 0;
        @(posedge clk);
        #1
        start= 0;

         repeat(3000) @(posedge clk);

        start= 2;
        nth_conv_i = 1;
        @(posedge clk);
        #1
        start= 0;

         repeat(3000) @(posedge clk);
    end


endmodule