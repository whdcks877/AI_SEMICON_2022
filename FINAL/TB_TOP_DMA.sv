`timescale 1ns/1ps

`define TAG_SA          3'b000
`define TAG_FC_WEIGHT  3'b001
`define TAG_FC_INPUT    3'b010
`define TAG_P_ADDR_BUF  3'b011
`define TAG_FC_DATA_BUF 3'b100
`define TAG_SA_DATA_BUF 3'b101

`define     CH_SIZE         1      //setting input channel size
`define     OFMAP_SIZE      28*28     //setting ouput feature map size
`define     OFMAP_SIZE_SQRT 28
`define     FC_SIZE         120
`define     N_COL           16

`define     TIMEOUT_CYCLE           10000000

module tb_top_dma();

    logic            clk;
    logic            rst_n;
    
    //axi tpu controller
    logic    start_i;
    logic done_o; 

    //axi bram controller
    logic [21:0] axi_addr_a;
    logic [31:0] axi_wrdata_a;
    logic [31:0] axi_rddata_a;
    logic        axi_en_a;
    logic        axi_rst_a;
    logic [3:0]  axi_we_a;

    logic [21:0] addr;
    int data;

    int conv1_filter_fp;
    int conv2_filter_fp;
    int conv3_filter_fp;
    int fc1_filter_fp;
    int fc2_filter_fp;
    int images_fp;
    int labels_fp;

    int conv1_filter [6][25];
    int conv2_filter [16][6][25];
    int conv3_filter [120][400];
    int fc1_filter [84][120];
    int fc2_filter [10][84];
    int images  [10000][1024];
    int labels [10000];

    int prediction[10];
    int score;
    int score_previous;


    TOP_withDMA u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i),
        .done_o(done_o), 
        .axi_addr_a(axi_addr_a),
        .axi_wrdata_a(axi_wrdata_a),
        .axi_rddata_a(axi_rddata_a),
        .axi_en_a(axi_en_a),
        .axi_rst_a(axi_rst_a),
        .axi_we_a(axi_we_a)
    );





    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end
    task test_init();    // active at time 0
            score = 0;
            axi_addr_a = 'b0;
            axi_wrdata_a = 'b0;
            axi_en_a = 'b0;
            axi_we_a = 'b0;
            start_i                   =  1'b0;

            rst_n                   =  1'b0;
            repeat (3) @(posedge clk);
            rst_n               = 1'b1;
    endtask
    
    task read_files();
        conv1_filter_fp = $fopen("conv1_filter.txt", "r");
        conv2_filter_fp = $fopen("conv2_filter.txt", "r");
        conv3_filter_fp = $fopen("conv3_filter.txt", "r");
        fc1_filter_fp = $fopen("fc1_filter.txt", "r");
        fc2_filter_fp = $fopen("fc2_filter.txt", "r");
    
        images_fp = $fopen("img.txt", "r");
        labels_fp = $fopen("label.txt", "r");

        $display("Read conv1 filter");
        if(!conv1_filter_fp) begin
		$display("error!\n");
		$finish;
        end else begin
            for(int i =0; i< 6; i++) begin 
                for(int j=0;j<25;j++) begin
                    $fscanf(conv1_filter_fp,"%d,", conv1_filter[i][j]);
                end
            end
        end

        $display("Read conv2 filter");
        if(!conv2_filter_fp) begin
            $display("error!\n");
            $finish;
        end else begin
            for(int i =0; i< 16; i++) begin 
                for(int j=0;j<6;j++) begin
                    for(int k=0; k<25; k++) begin
                        $fscanf(conv2_filter_fp,"%d,", conv2_filter[i][j][k]);
                    end
                end
            end
        end

        $display("Read conv3 filter");
        if(!conv3_filter_fp) begin
            $display("error!\n");
            $finish;
        end else begin
            for(int i =0; i< 120; i++) begin 
                for(int j=0; j < 400;j++) begin
                    $fscanf(conv3_filter_fp,"%d,", conv3_filter[i][j]);
                end
            end
        end

        $display("Read fc1 filter");
        if(!fc1_filter_fp) begin
            $display("error!\n");
            $finish;
        end else begin
            for(int i =0; i< 84; i++) begin 
                for(int j=0; j < 120;j++) begin
                    $fscanf(fc1_filter_fp,"%d,", fc1_filter[i][j]);
                end
            end
        end

        $display("Read fc2 filter");
        if(!fc2_filter_fp) begin
            $display("error!\n");
            $finish;
        end else begin
            for(int i =0; i< 10; i++) begin 
                for(int j=0; j < 84;j++) begin
                    $fscanf(fc2_filter_fp,"%d,", fc2_filter[i][j]);
                end
            end
        end
        
        $display("Read images");
        if(!images_fp) begin
            $display("error!\n");
            $finish;
        end else begin
            for(int i =0; i< 10000; i++) begin 
                for(int j=0; j < 1024;j++) begin
                    $fscanf(images_fp,"%d,", images[i][j]);
                end
            end
        end

        $display("Read labels");
        if(!labels_fp) begin
            $display("error!\n");
            $finish;
        end else begin
            for(int i =0; i< 10000; i++) begin
                $fscanf(labels_fp,"%d,", labels[i]);
            end
        end

        $fclose(conv1_filter_fp);
        $fclose(conv2_filter_fp);
        $fclose(conv3_filter_fp);
        $fclose(fc1_filter_fp);
        $fclose(fc2_filter_fp);
        $fclose(images_fp);
        $fclose(labels_fp);
        $display("Files read successfully...");
    endtask

    task automatic write_ram(input logic [21:0] addr, input int data);
        axi_we_a = 4'hf;
        axi_addr_a = addr;
        axi_wrdata_a = data;
        @(posedge clk);
        axi_we_a = 4'h0;
    endtask

    task automatic read_ram(input logic [21:0] addr, output int data);
        @(posedge clk);
        #1
        axi_en_a = 1'b1;
        axi_addr_a = addr;
        @(posedge clk);
        //#1
        axi_en_a = 1'b0;
        @(posedge clk);
        @(posedge clk);
        #1
        data = axi_rddata_a;
        
    endtask

    task write_weight();
        
		
        //write conv1 filter
        for(int i=0; i<6; i++) begin
            for(int j=0; j<25; j++) begin
                addr = ((`TAG_SA<<17) + (1<<16) + (i<<8) + j)<<2;
                data = conv1_filter[i][24-j];
                write_ram(addr, data);
            end
        end
        repeat (10)@(posedge clk);
        //write conv2 filter
        for(int i = 0; i<16; i++) begin
            for(int j = 0; j < 6; j++) begin
                for(int k=0; k<25; k++) begin
                    addr = ((`TAG_SA<<17) + (1<<16) + (i<<8) + 25 + (j*25) + k)<<2;
                    data = conv2_filter[i][6 -j][24-k];
                    write_ram(addr, data);
                end
            end
        end
		
		repeat (10)@(posedge clk);

        //write conv3 filter
        for(int i = 0; i<3; i++) begin
            for(int j=0; j<120; j++) begin
                for(int k=0; k<120; k++) begin
                    addr = ((`TAG_FC_WEIGHT<<17) + (j<<10)+ (120*i) + k)<<2;
                    data = conv3_filter[k][(120*(i+1)) - 1 -j];
                    write_ram(addr, data);
                end
            end
        end

        for(int i = 0; i<40; i++) begin
            for(int j = 0; j<120; j++) begin
                addr = ((`TAG_FC_WEIGHT<<17) + (i<<10) + 360 + j)<<2;
                data = conv3_filter[j][400 - 1 - i];
                write_ram(addr, data); 
            end
        end

        for(int i = 0; i<80; i++) begin
            for(int j = 0; j<120; j++) begin
                addr = ((`TAG_FC_WEIGHT<<17) + ((40+i)<<10) + 360 + j)<<2;
                data = 0;
                write_ram(addr, data); 
            end
        end
        repeat (10)@(posedge clk);
        //write fc1 filter [84][120]
        for(int i =0; i<120; i++) begin
            for(int j = 0; j<84; j++) begin
                addr = ((`TAG_FC_WEIGHT<<17) + (i<<10) + 480 + j)<<2;
                data = fc1_filter[j][120 -1 -i];
                write_ram(addr, data); 
            end
        end
		
        //write fc2 filter [10][84]
		repeat (10)@(posedge clk);

        for(int i =0; i<84; i++) begin
            for(int j = 0; j<10; j++) begin
                addr = ((`TAG_FC_WEIGHT<<17) + (i<<10) + 564 + j)<<2;
                data = fc2_filter[j][84 -1 -i];
                write_ram(addr, data); 
            end
        end
        for(int i =0; i<120-84; i++) begin
            for(int j = 0; j<10; j++) begin
                addr = ((`TAG_FC_WEIGHT<<17) + ((i+84)<<10) + 564 + j)<<2;
                data = 0;
                write_ram(addr, data); 
            end
        end
    endtask
    function automatic int argmax (int pred[10]);
        int max = 0;
        argmax = 0;
        for(int i = 0; i<10; i++) begin
            if(max < pred[i]) begin
                max = pred[i];
                argmax = i;
            end
        end
    endfunction

    task automatic test_conv(int idx);
        //$display("Write image %d", idx);

        for(int j=0; j<1024; j++) begin
			addr = ((`TAG_SA<<17) + j)<<2;
			data =  images[idx][j];
			write_ram(addr, data);
		end
        
		repeat (2)@(posedge clk);

        //$display("Start conv");
        start_i                       = 'd1;
        @(posedge clk);
        start_i                       = 'd0; 


        while(done_o != 1) begin
            @(posedge clk);
        end
        repeat(3) @(posedge clk);
        //$display("Conv finished");
            for(int i = 0; i<10; i++) begin
                addr = ((`TAG_FC_DATA_BUF<<17) + i)<<2;
                read_ram(addr, prediction[i]);
                repeat(3) @(posedge clk);
            end
        //$display("-------Prediction----------");
        if(labels[idx] == argmax(prediction)) begin
            score++;
        end
        for(int i = 0; i<10; i++) begin
            $display("%dth||  %d",i,prediction[i]);
        end
        $display("answer: %d", labels[idx]);
        //$display("%d th|| label: %d/ pred:%d  ",i,labels[idx], argmax(prediction));

            // $display("-------Label----------");
            // $display("%d  ",labels[idx]);
            repeat (2)@(posedge clk);
    endtask





    initial begin
        read_files();
        test_init();
        score_previous = 0;
		repeat (10)@(posedge clk);
        write_weight();
  
        for(int i=0; i<1; i++) begin
            test_conv(i);
            if((i+1)%1000 == 0) begin
                $display("%d000th finished", i/1000);
                $display("%d th score : %d", i/1000, score - score_previous);
                score_previous  = score;
            end
            rst_n                   =  1'b0;
            repeat (2) @(posedge clk);
            rst_n               = 1'b1;
        end
        $display("final score: %d", (score));
            
        $finish;
    end
    


endmodule
