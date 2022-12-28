`timescale 1ns/1ps
`include "..\RTL\ifmap_buf.sv"
`define     TIMEOUT_CYCLE         10000000

module tb_ifmap_buf();

    reg clk;
    reg rst_n;
    logic rden_i;
    logic wren_i;
    logic [6:0] addr_i;

    logic [7:0] ifmap_i;
    logic [7:0] ifmap_o;

    logic [6:0] addr;
    byte captured_data;

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    ifmap_buf u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .rden_i(rden_i),
        .wren_i(wren_i),
        .addr_i(addr_i),
        .ifmap_i(ifmap_i),
        .ifmap_o(ifmap_o)
    );

    task test_init();
        rst_n = 1'b0; 
        repeat (3) @(posedge clk);   
        rst_n = 1'b1;

        rden_i = 0;
        wren_i = 0;
        addr_i = 0;
        ifmap_i = 0;

    endtask

    task write_buf();
        wren_i = 1;
        for(int i =0; i<128; i++) begin
            addr_i = i;
            ifmap_i = i+1;
            @(posedge clk);
        end
        wren_i = 0;
    endtask

    task read_buf();
        rden_i = 1;
        for(int i =0; i<128; i++) begin
            addr_i = i;
            @(posedge clk);
            captured_data = ifmap_o;
            $display("%d:: captured: %d",i, captured_data);
        end
        rden_i = 1;
    endtask

    initial begin
        test_init();

        write_buf();
        repeat (3) @(posedge clk);  
        read_buf();

        $finish;
    end
endmodule