`timescale 1ns/1ps

`include "..\..\RTL\ACC_POOL.sv"
`include "..\..\..\Accumulator\SRC\ACC_IF_x16.sv"
`include "..\..\..\FullyConnected\SIM\TB\fc_w_buf_if.sv"
`include "..\..\..\FullyConnected\SIM\TB\fc_ifmap_buf_if.sv"



`define     CH_SIZE         3      //setting input channel size
`define     OFMAP_SIZE      4*4     //setting ouput feature map size
`define     OFMAP_SIZE_SQRT 4
`define     N_COL           16
`define     TIMEOUT_CYCLE         10000000

module tb_acc_active();

    reg                     clk;
    reg                     rst_n;

    logic start_i; 
    logic [6:0] in_node_num_i; 
    logic [6:0] out_node_num_i; 

    
    logic [7:0] wbuf_wdata [`FC_SIZE];
    logic [6:0] addr [`FC_SIZE];
    logic [6:0] addr_fc [`FC_SIZE];

    logic [6:0] ifmap_wrptr;

    logic                         fc_last_o;
    logic                         fc_valid_o;
    logic [7:0]        fc_result_o;

    logic                         pool_last_o [16];
    logic                         pool_valid_o [16];
    logic [7:0]        pool_result_o [16];
    logic [9:0]     pool_result_address_o [16];

    byte psum_arr [`N_COL][`CH_SIZE][`OFMAP_SIZE];
    int correct_data [`N_COL][`OFMAP_SIZE]= '{default:0};
    int pooled_data [`N_COL][`OFMAP_SIZE/4];

    int in_node_num = 120; //setting number of input node
    int out_node_num = 84; //setting number of output node

    byte input_node [`FC_SIZE] = '{default:0};
    byte output_node [`FC_SIZE];
    byte weight [`FC_SIZE][`FC_SIZE]= '{default:0};
    byte output_node_ans [`FC_SIZE] = '{default:0};

    initial begin
		#`TIMEOUT_CYCLE $display("Timeout!");
		$finish;
	end

    initial begin
        clk                     = 1'b0;

        forever #10 clk         = !clk;
    end
    
    
    ACC_IF_x16 acc_if (.clk(clk), .rst_n(rst_n));
    fc_ifmap_buf_if ifbuf_if(.clk(clk), .rst_n(rst_n));
    fc_w_buf_if wbuf_if(.clk(clk), .rst_all(rst_n));


    ACC_POOL u_dut (
        .clk(clk),
        .rst_n(rst_n),
        .psum_i(acc_if.psum),
        .pvalid_i(acc_if.pvalid),
        .ofmap_size_i(acc_if.ofmap_size),
        .ifmap_ch_i(acc_if.ifmap_ch),
        .start_fc_i(start_i),
        .in_node_num_i(in_node_num_i),
        .out_node_num_i(out_node_num_i),
        .wbuf_wren_i(wbuf_if.wren_i),
        .wbuf_wrptr_i(wbuf_if.wrptr_i),
        .wbuf_wdata_i(wbuf_if.weight_i),
        .ifmap_wren_i(ifbuf_if.wren_i),
        .ifmap_wrptr_i(ifbuf_if.wrptr_i),
        .ifmap_wdata_i(ifbuf_if.ifmap_i),
        .fc_last_o(fc_last_o),
        .fc_valid_o(fc_valid_o),
        .fc_result_o(fc_result_o),
        .pool_last_o(pool_last_o),
        .pool_valid_o(pool_valid_o),
        .pool_result_o(pool_result_o),
        .pool_result_address_o(pool_result_address_o)
);

    task test_init();
        rst_n = 1'b0; 
        repeat (3) @(posedge clk);   
        rst_n = 1'b1;

        start_i = 0;
        in_node_num_i = 0;
        out_node_num_i = 0;

        wbuf_if.init();
        ifbuf_if.init();

        acc_if.init(`OFMAP_SIZE_SQRT,`CH_SIZE);

        for(int i = 0; i<16; i=i+1) begin
            for(int j = 0; j<`CH_SIZE; j=j+1) begin
                for(int k = 0; k<`OFMAP_SIZE; k=k+1) begin
                    psum_arr[i][j][k] = $urandom_range(255,0)-128;
                end
            end
        end
        
        //accumulate
        for(int i = 0; i<16; i=i+1) begin
            for(int j = 0; j<`CH_SIZE; j=j+1) begin
                for(int k = 0; k<`OFMAP_SIZE; k=k+1) begin
                    correct_data[i][k] = correct_data[i][k] + psum_arr[i][j][k];
                end
            end
        end

        //saturation
        for(int i = 0; i<16; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                if(correct_data[i][j]> 127) begin
                    correct_data[i][j] = 127 ;
                end else if(correct_data[i][j]< -128) begin
                    correct_data[i][j] = -128 ;
                end
            end
        end

        //activation
        for(int i = 0; i<16; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                if(correct_data[i][j] < 0) begin
                    correct_data[i][j] = 0;
                end
            end
        end

        //fc
        for (int i=0; i<in_node_num; i++)
            input_node[i] = $urandom_range(6,0)-3; //setting range of random number (-3~3)
        
        $display("-------input node data---------");
        for (int i=0; i<in_node_num; i++)
            $display("%d:: %d",i,input_node[i]);    
        
        for (int i=0; i<out_node_num; i++) begin
            for (int j=0; j<in_node_num; j++) begin
                weight[i][j] = $urandom_range(6,0)-3; //setting range of random number (-3~3)
            end
        end

    endtask

    task automatic acc_test_feeddata(input int col);
        for(int i = 0; i<`CH_SIZE; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                for(int k = 0; k < 16; k++) begin
                    acc_if.data_feed(k, psum_arr[k][i][j]);
                end
            end
        end
    endtask

    task buffer_load();
        $display("buffer load start");
        //weight_buffer write
        for (int i=0; i<out_node_num; i++) begin
            addr_fc = '{default:i};
            wbuf_if.write_ram(addr_fc,weight[i]);
        end
        

        //ifmap buffer write
        for (int i=0; i<in_node_num; i++) begin
            ifmap_wrptr = i;
            ifbuf_if.write_ram(ifmap_wrptr,input_node[in_node_num - 1- i]);
        end
        $display("buffer load finished");
    endtask

    task pe_array_start();
        $display("pe start...");
        start_i = 1;
        in_node_num_i = in_node_num;
        out_node_num_i = out_node_num; 

        @(posedge clk);
        start_i = 0;
        in_node_num_i = 0;
        out_node_num_i = 0; 
    endtask
/*
    task automatic acc_test_capture(input int col);
        byte data;
        int last = 0;
        int idx[16] = '{default:0};

        while(1) begin

            for(int ch = 0; ch < 16; ch++) begin
                if(act_valid_o[ch]==1) begin
                    
                end
            end
            if(act_valid_o==1) begin
                for(int i = 0; i < 16; i++) begin
                    $display("captured data");
                    $write("%d ",act_result_o[i][idx]);
                end
                $write("\n");
                for(int i = 0; i < 16; i++) begin
                    $display("answer data");
                    $write("%d ",correct_data[i][idx]);
                end
                $write("\n");
                idx++;
                if(act_last_o)
                    last = 1;
            end
            @(posedge clk);

            if(last) begin
                $display("test pass!");
                $finish;
            end
        end
    endtask
*/
    initial begin
        
        test_init();
        repeat (1) @(posedge clk);

        fork
            acc_test_feeddata(16);
        join
        
        $display("pass");
        repeat (10000) @(posedge clk);
        $finish;
        
/*
        test_init();
        buffer_load();
        repeat (3) @(posedge clk);  
        pe_array_start();
        repeat (10000) @(posedge clk); 
        $finish;*/
    end


endmodule