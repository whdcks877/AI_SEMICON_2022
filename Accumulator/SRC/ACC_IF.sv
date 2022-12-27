`timescale 1ns/1ps

interface ACC_IF (
    input clk,
    input rst_n
);

    logic [7:0] psum;
    logic pvalid;
    logic pready;

    logic [9:0] ofmap_size;
    logic [5:0] ifmap_ch;

    logic conv_valid;
    logic [7:0] conv_result;
    
    modport TB (
        input           clk, rst_n,
        input           psum, pvalid, ofmap_size, ifmap_ch,
        output          conv_valid, conv_result, pready
    );

    task init(input int ofmap_size_data, input int ifmap_ch_data);
        psum = 8'b0;
        pvalid = 1'b0;
        ofmap_size = ofmap_size_data;
        ifmap_ch = ifmap_ch_data;
    endtask

    task automatic data_feed(input byte data);
        pvalid = 1'b1;
        psum = data;

        while(!pready) begin
            @(posedge clk);
        end
        pvalid = 1'b0;
        psum = 8'bx;
    endtask

    task automatic capture_data(output byte result);
        if(!conv_valid) begin
            while(!conv_valid) begin
                @(posedge clk);
            end
            result = conv_result;
        end else begin
        @(posedge clk);
            result = conv_result;
        end
        
    endtask
endinterface