`timescale 1ns/1ps
`define     TIMEOUT_CYCLE         10000000
`include "..\RTL\FullyConnected.sv"
`include "fc_w_buf_if.sv"
`include "fc_ifmap_buf_if.sv"

module tb_FullyConnected();

    reg clk;
    reg rst_n;

    logic start_i; 
    logic [6:0] in_node_num_i; 
    logic [6:0] out_node_num_i; 

    
    logic [7:0] wbuf_wdata [128];
    logic [6:0] addr [128];

    logic [6:0] ifmap_wrptr;

    byte psum_o; 
    logic valid_o; 
    logic last_o; 

    int in_node_num = 120; //setting number of input node
    int out_node_num = 84; //setting number of output node

    byte input_node [128] = '{default:0};
    byte output_node [128];
    byte weight [128][128]= '{default:0};
    byte output_node_ans [128] = '{default:0};
    
    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    fc_ifmap_buf_if ifbuf_if(.clk(clk), .rst_n(rst_n));
    fc_w_buf_if wbuf_if(.clk(clk), .rst_all(rst_n));

    FullyConnected u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i), 
        .in_node_num_i(in_node_num_i), 
        .out_node_num_i(out_node_num_i), 
        .wbuf_wren_i(wbuf_if.wren_i),
        .wbuf_wrptr_i(wbuf_if.wrptr_i),
        .wbuf_wdata_i(wbuf_if.weight_i),
        .ifmap_wren_i(ifbuf_if.wren_i),
        .ifmap_wrptr_i(ifbuf_if.wrptr_i),
        .ifmap_wdata_i(ifbuf_if.ifmap_i),
        .psum_o(psum_o), 
        .valid_o(valid_o), 
        .last_o(last_o)
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

        $display("-------output node data---------");
        for (int i=0; i<out_node_num; i++) begin
            for (int j=0; j<in_node_num; j++) begin
                $write("%d, ",weight[i][j]);
            end
            $write("\n");
        end

        for (int i=0; i<out_node_num; i++) begin
            for (int j=0; j<in_node_num; j++) begin
                output_node_ans[i] = output_node_ans[i] + (weight[i][j]*input_node[j]);
            end
        end
    endtask

    task buffer_load();
        $display("buffer load start");
        //weight_buffer write
        for (int i=0; i<out_node_num; i++) begin
            addr = '{default:i};
            wbuf_if.write_ram(addr,weight[i]);
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

    task output_node_test();
        int idx=0;
        int last=0;
        while(1) begin
            if(valid_o==1) begin
                //output_node = psum_o;
                $display("%d th output: %d, answer: %d",idx, psum_o, output_node_ans[idx]);
                if(psum_o != output_node_ans[idx]) begin
                    $display("mismatch!");
                    $finish;
                end
                idx++;
                if(last_o)
                    last = 1;
            end
            @(posedge clk);
            if(last) begin
                $display("test pass!");
                $finish;
            end
        end
    endtask

    initial begin
        test_init();
        buffer_load();
        repeat (3) @(posedge clk);  
        pe_array_start();
        output_node_test();
        $finish;
    end
endmodule