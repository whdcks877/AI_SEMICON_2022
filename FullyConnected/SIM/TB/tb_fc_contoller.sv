`timescale 1ns/1ps
`include "..\RTL\fc_controller.sv"
`define     TIMEOUT_CYCLE         100000

module tb_fc_contoller();
    
    reg clk;
    reg rst_n;

    logic start_i; 
    logic [6:0] in_node_num_i; 
    logic [6:0] out_node_num_i;

    logic ifmap_rden_o;
    logic [6:0] ifmap_rdptr_o;
    logic wbuf_rden_o;
    logic [6:0] wbuf_rdptr_o;
    logic rst_buf_n_o;
    logic valid_o;
    logic last_o;
    
    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    fc_controller u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i), 
        .in_node_num_i(in_node_num_i), 
        .out_node_num_i(out_node_num_i),
        .ifmap_rden_o(ifmap_rden_o),
        .ifmap_rdptr_o(ifmap_rdptr_o),
        .wbuf_rden_o(wbuf_rden_o),
        .wbuf_rdptr_o(wbuf_rdptr_o),
        .rst_buf_n_o(rst_buf_n_o),
        .valid_o(valid_o),
        .last_o(last_o)
    );

    
    task test_init();
        rst_n = 1'b0; 
        repeat (3) @(posedge clk);   
        rst_n = 1'b1;
    endtask

    task ctrl_test();
        in_node_num_i = 5;
        out_node_num_i = 3;
        start_i = 1;
        @(posedge clk);

        in_node_num_i = 0;
        out_node_num_i = 0;
        start_i = 0;
    endtask

    initial begin
        test_init();
        ctrl_test();
    end


endmodule