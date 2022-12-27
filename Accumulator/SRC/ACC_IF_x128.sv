`timescale 1ns/1ps

interface ACC_IF_x128 (
    input clk,
    input rst_n
);

    logic [7:0] psum [128];
    logic pvalid [128];
    logic pready [128];

    logic [9:0] ofmap_size;
    logic [5:0] ifmap_ch;

    logic conv_valid [128];
    logic [7:0] conv_result [128];
    
    modport TB (
        input           clk, rst_n,
        input           psum, pvalid, ofmap_size, ifmap_ch,
        output          conv_valid, conv_result, pready
    );

    task init(input int ofmap_size_data, input int ifmap_ch_data);
        for(int i = 0; i<128; i++) begin
            psum[i] = 8'b0;
            pvalid[i] = 1'b0;
        end
        ofmap_size = ofmap_size_data;
        ifmap_ch = ifmap_ch_data;
    endtask

    task automatic data_feed(input int col, input byte data);
        pvalid[col] = 1'b1;
        psum[col] = data;
        
        do begin
             @(posedge clk);
        end while(!pready);
        
        pvalid[col] = 1'b0;
        psum[col]= 8'bx;
    endtask

    task automatic capture_data(input int col, output byte result);
        if(!conv_valid[col]) begin
            while(!conv_valid[col]) begin
                @(posedge clk);
            end
            result = conv_result[col];
        end else begin
        @(posedge clk);
            result = conv_result[col];
        end
        
    endtask
endinterface