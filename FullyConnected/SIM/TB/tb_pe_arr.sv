`timescale 1ns/1ps

`include "..\RTL\pe_1x128.sv"
`include "pe_arr_if.sv"

`define     TIMEOUT_CYCLE         10000000

module tb_pe_arr();
    reg clk;
    reg rst_n;

    byte ifmap_data [128];
    byte ifmap_captured [128];

    byte weight_data [128];
    byte caputured_psum;
    int psum_result=0;

    int pass = 1;

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    PE_ARR_IF pe_if(.clk(clk), .rst_n(rst_n));

    pe_1x128 u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .weight_i(pe_if.weight_i),
        .pe_load_i(pe_if.pe_load_i),
        .ifmap_i(pe_if.ifmap_i),
        .psum_o(pe_if.psum_o),
        .ifmap_o(pe_if.ifmap_o)
    );
    
    task test_init();
        rst_n = 1'b0;     
        repeat (3) @(posedge clk);          
        rst_n = 1'b1;

        pe_if.init();

        for(int i = 0; i<128; i++) begin
            ifmap_data[i] = $urandom_range(6,0)-3; //-3 ~ 3
            weight_data [i] = $urandom_range(6,0)-3; //-3 ~ 3
        end

        for(int i = 0; i<128; i++) begin
           psum_result = psum_result + (ifmap_data[i]*weight_data[127-i]);
        end
    endtask

    task load_ifmap();
    $display("start ifmap load");
        pe_if.pe_load_i = 1'b1;
        for(int i=0; i<128; i++) begin
            pe_if.ifmap_i = ifmap_data[i];
            @(posedge clk);
        end
        pe_if.pe_load_i = 1'b0;
    endtask

    task load_ifmap_test();
        $display("start ifmap load test");
        pe_if.pe_load_i = 1'b1;
        for(int i=0; i<128; i++) begin
            @(posedge clk);
            ifmap_captured[i] = pe_if.ifmap_o;
        end
        pe_if.pe_load_i = 1'b0;
        for(int i=0; i<128; i++) begin
            $display("%d: input: %d, caputured: %d",i, ifmap_data[i], ifmap_captured[i]);
            if(ifmap_captured[i] != ifmap_data[i]) begin
                pass = 0;
            end
        end
    endtask

    task mac_operation_test();
        $display("start mac_operation_test");
        for(int i=0; i<128; i++) begin
            pe_if.weight_i[i] = weight_data[i];
            @(posedge clk);
        end 
        #1
        caputured_psum = pe_if.psum_o;
        $display("answer: %d, captured: %d", psum_result, caputured_psum);
    endtask
    
    initial begin
        test_init();
        load_ifmap();
        mac_operation_test();

        $finish;
    end

endmodule