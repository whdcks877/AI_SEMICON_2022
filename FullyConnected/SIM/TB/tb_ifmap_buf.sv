`timescale 1ns/1ps
`include "..\RTL\ifmap_buf.sv"
`include "fc_ifmap_buf_if.sv"
`define     TIMEOUT_CYCLE         10000000

module tb_ifmap_buf();

    reg clk;
    reg rst_n;
 
 

    byte captured_data;

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    fc_ifmap_buf_if ifbuf_if(.clk(clk), .rst_n(rst_n));

    ifmap_buf u_dut(
        .clk(clk),
        .rst_n(ifbuf_if.rst_n),
        .rden_i(ifbuf_if.rden_i),
        .wren_i(ifbuf_if.wren_i),
        .rdptr_i(ifbuf_if.rdptr_i),
        .wrptr_i(ifbuf_if.wrptr_i),
        .ifmap_i(ifbuf_if.ifmap_i),
        .ifmap_o(ifbuf_if.ifmap_o)
    );

    task test_init();
        rst_n = 1'b0; 
        repeat (3) @(posedge clk);   
        rst_n = 1'b1;

        ifbuf_if.init();
    endtask

    task  write_buf();
        for(int i =0; i<128; i++) begin
            ifbuf_if.write_ram(i,i+1);
        end
    endtask

    task read_buf();
         ifbuf_if.rden_i = 1;
        for(int i =0; i<128; i++) begin
             ifbuf_if.rdptr_i = i;
            @(posedge clk);
            #1
            captured_data =  ifbuf_if.ifmap_o;
            $display("%d:: captured: %d",i, captured_data);
        end
         ifbuf_if.rden_i = 1;
    endtask

    initial begin
        test_init();

        write_buf();
        repeat (3) @(posedge clk);  
        read_buf();
        repeat (3) @(posedge clk); 

        $finish;
    end
endmodule