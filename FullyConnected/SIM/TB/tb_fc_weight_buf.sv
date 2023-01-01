`timescale 1ns/1ps

`include "..\RTL\FC_weight_buf.sv"
`include "fc_w_buf_if.sv"

`define     TIMEOUT_CYCLE         10000000
module tb_fc_weight_buf();

    reg clk;
    reg rst_all;

    logic [6:0] addr [128];

    byte captured_data [128];
    
    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end


    fc_w_buf_if buf_if(.clk(clk), .rst_all(rst_all));

    fc_weight_buf u_dut(
        .clk(clk),
        .rst_n(buf_if.rst_n),
        .rst_all(buf_if.rst_all),
        .rdptr_i(buf_if.rdptr_i),
        .wrptr_i(buf_if.wrptr_i),
        .rden_i(buf_if.rden_i),
        .wren_i(buf_if.wren_i),
        .weight_i(buf_if.weight_i),
        .weight_o(buf_if.weight_o)
    );

    task test_init();
        rst_all = 1'b0; 
        repeat (3) @(posedge clk);   
        rst_all = 1'b1;

        buf_if.init();
    endtask

    task write_buf();
        for(int i =0; i<84; i++) begin
            addr = '{default: i};
            buf_if.write_ram(addr, '{default:i+1});
        end
    endtask

    task read_buf();
        buf_if.rden_i = 1;
        buf_if.rst_n = 1;
        for(int i = 0; i<84+128; i++) begin
            buf_if.rdptr_i = i;
            if(i == 84)
                buf_if.rst_n = 1'b0;
            @(posedge clk);
            captured_data = buf_if.weight_o;
            $write("cycle: %d", i);
            for(int j =0; j<128; j++) begin
                $write("%d,  ", captured_data[j]);
            end
            $write("\n");
        end
    endtask

    initial begin
        test_init();

        write_buf();
        repeat (3) @(posedge clk);  
        read_buf();

        $finish;
    end
endmodule