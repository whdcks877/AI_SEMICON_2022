
`define     TIMEOUT_CYCLE           10000000
module tb_layer_ctrl();
    logic clk;
    logic rst_n;

    
    logic start_i;
    //dma
    logic start_dma_o;
    logic [1:0] nth_conv_o;
    logic  dma_done_i;

    //layer info
    logic  [4:0]                   ofmap_size_o;
    logic  [5:0]                   ifmap_ch_o;

    logic    [8:0]   in_node_num_o; //fully connected configure
    logic    [6:0]   out_node_num_o;

    //tpu core
    logic [16:0] done; // 17: fc_last, 16~0 : pool_last 
    logic [1:0] start_core_o ;// 1: conv, 2:fc

    //axi
    logic cnn_done_o;

    tpu_layer_ctrl u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i),
        .start_dma_o(start_dma_o),
        .nth_conv_o(nth_conv_o),
        .dma_done_i(dma_done_i),
        .ofmap_size_o(ofmap_size_o),
        .ifmap_ch_o(ifmap_ch_o),
        .in_node_num_o(in_node_num_o), 
        .out_node_num_o(out_node_num_o),
        .done(done), 
        .start_core_o(start_core_o),
        .cnn_done_o(cnn_done_o)
);
    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    initial begin
        start_i= 0;
        done = 0;
        dma_done_i = 0; 
        rst_n=0;
        repeat(3) @(posedge clk);
        rst_n=1;
        repeat(3) @(posedge clk);

        start_i = 1;
        @(posedge clk);
        #1
        start_i = 0;

        repeat(10) @(posedge clk);
        done = 1<<5;

        @(posedge clk);
        done = 0;

        repeat(10) @(posedge clk);
        dma_done_i = 1;

        @(posedge clk);
        dma_done_i = 0;

        repeat(10) @(posedge clk);
        done = 1<<15;

        
        @(posedge clk);
        done = 0;

        repeat(10) @(posedge clk);
        dma_done_i = 1;

        @(posedge clk);
        dma_done_i = 0;

        repeat(10) @(posedge clk);
        done = 1<<16;

        @(posedge clk);
        done = 0;

        repeat(10) @(posedge clk);
        dma_done_i = 1;

        @(posedge clk);
        dma_done_i = 0;

        repeat(10) @(posedge clk);
        done = 1<<16;

        @(posedge clk);
        done = 0;

        repeat(10) @(posedge clk);
        dma_done_i = 1;

        @(posedge clk);
        dma_done_i = 0;

        repeat(10) @(posedge clk);
        done = 1<<16;

        @(posedge clk);
        done = 0;

        repeat(10) @(posedge clk);
        dma_done_i = 1;

        @(posedge clk);
        dma_done_i = 0;
        
        repeat(100) @(posedge clk);
    end

endmodule