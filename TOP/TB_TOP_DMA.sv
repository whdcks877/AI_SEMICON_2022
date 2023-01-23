`define TAG_SA          3'b000
`define TAG_FC_WEIGHT  3'b001
`define TAG_FC_INPUT    3'b010
`define TAG_P_ADDR_BUF  3'b011
`define TAG_FC_DATA_BUF 3'b100
`define TAG_SA_DATA_BUF 3'b101

`timescale 1ns/1ps
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
    logic [7:0] data;


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

    logic [7:0] img [1024] = {55, -109, 89, 125, 123, 76, 56, -106, 107, -66, 54, -72, -128, -77, 97, -106, -44, -48, 73, -96, -23, -56, -124, 21, -48, -3, -27, -102, 62, -32, 93, -87, -75, -93, 17, 124, 19, -102, -13, 35, -10, 44, 119, -21, -76, -100, 43, -93, -10, -73, 77, -36, 81, -77, -13, -54, -15, -49, -123, 2, 76, -94, -78, -108, -71, 24, -56, 31, 67, -48, -51, 31, -34, -76, -108, -19, 53, -34, -105, -27, 103, -36, 115, 109, -4, 88, 126, 38, 80, -41, 73, -33, 33, 4, -62, -44, 47, -117, 123, -128, 36, 57, -118, 4, 87, -117, -113, -36, -11, 56, -102, 89, -5, 123, 31, 106, -112, 26, 109, -63, -100, 18, -45, -53, -43, 10, 48, -92, -63, 125, -4, 66, -31, 108, -60, 60, -94, -22, -77, 19, -43, -120, -11, -44, -3, 74, 45, 0, -14, -34, -104, 18, 56, -2, -72, -123, -61, -45, -45, -27, 67, 77, -106, 84, -86, -114, 87, 123, -97, -30, -32, 108, 84, -28, -50, 27, 9, 1, -19, 8, -2, -84, 47, -97, -73, 68, -87, -96, 110, 86, 6, 90, 5, 73, -104, -42, 32, -65, -31, -123, -121, -32, 12, 77, -31, -80, -114, 93, -105, 126, 94, -13, 26, 35, 49, 22, -67, -70, 18, -128, 74, -98, -74, -56, 96, -11, -3, -24, 54, -88, 68, -26, 90, 3, -54, -126, -74, 6, 22, -29, 19, 20, 124, 44, -83, 56, -93, 19, -69, 75, 126, 108, 74, -79, -2, 125, -114, 66, 98, 33, -85, 21, -117, 8, 45, -91, -58, -84, -8, -75, 68, -98, 63, -18, -49, -28, -5, -87, 42, -8, 124, 60, -83, -70, 110, 111, 93, 70, 78, -92, 81, -127, 90, -5, 45, -1, 47, 25, -27, -92, 82, 87, -116, -101, -91, -80, -2, 105, -88, 54, -30, -109, 96, 121, 45, 104, -2, -54, -67, -2, -50, 59, 22, 78, -63, 49, -96, 13, -90, 126, -60, -111, 110, 3, 100, 112, 14, 35, 67, -56, -101, 29, -48, 102, 118, -67, 40, -105, -8, -124, 119, -3, 78, -64, -48, 106, 77, -49, 107, -91, 52, 43, 33, -93, -18, 49, 94, 31, -11, 7, -49, 83, 19, 41, 19, -58, -123, 56, 44, -58, 114, 84, 20, 90, -45, -41, 98, -79, 125, 57, 42, -66, -45, 49, -57, -79, -14, 113, -82, -33, 37, 5, -113, 43, -81, 3, 90, 19, -14, -112, 111, 14, -11, 89, -58, 22, -119, -95, -67, -83, 75, -84, 42, -54, 111, -121, -119, 47, -79, -104, 120, 105, -31, 9, -56, 16, 122, 118, 94, -101, 71, 57, 43, -36, 89, 60, -101, -116, 91, 31, 66, -1, -48, 98, -22, -125, 91, 44, -69, -10, -38, 54, -50, -127, 45, 8, 42, 48, 26, 59, -115, 72, -121, -28, 126, -87, 89, -1, -46, -3, 46, -11, 26, 72, 21, 101, 78, 87, -7, -2, 70, -66, 78, -126, -19, -117, 71, -69, -3, -122, 2, 62, 116, -118, -111, 66, -93, 51, 11, -20, -75, -18, 84, 118, 118, -88, 20, -52, -20, 2, 15, -66, 71, 14, -111, 17, 98, 96, 40, 99, 95, -80, -28, 23, 96, -98, -74, 14, -80, 43, -103, -12, 74, -3, 27, -87, -28, -67, -29, -77, 42, 21, -116, -59, 53, -45, -8, 21, -11, 103, 105, -31, 26, 44, -59, 93, 80, 66, 51, 10, -117, 18, -82, 4, 83, -110, -67, -19, 80, -68, -83, 125, -50, 97, -11, -48, 82, 121, 119, -125, 82, -45, -48, 100, 49, 100, 80, 88, -87, 55, -73, 58, -51, 96, 60, -105, -27, 17, 64, -80, -94, 77, -114, 31, 29, -97, -71, -118, 113, 22, 99, -98, -87, -3, 90, 9, -84, -60, 4, 83, 4, -107, 121, 87, -125, -51, 125, 119, 60, 40, -109, 21, -58, -26, -10, 79, 123, -44, -86, 121, 89, -108, 38, 57, -79, 95, 7, 10, 93, -8, -82, -29, -101, 80, -122, -56, -47, 102, 6, 41, 111, -24, -50, -84, 60, -7, -111, 9, -115, 91, 8, 117, -17, 104, -30, -113, 57, -17, 104, 9, 72, 28, 64, 42, 89, 116, 110, -97, -51, 54, -123, 25, 109, 19, -88, -120, -118, -91, -26, -78, 21, -127, -99, -117, 48, -7, -27, -94, -51, 70, -107, 91, -115, 106, 121, -83, -32, 114, 30, 2, 23, 69, 115, -16, -26, -44, 4, -43, 85, 72, 126, 100, 104, -72, 119, -1, 12, -46, -112, -63, -105, 79, 66, -31, -4, 2, -86, 33, 56, -74, 3, 33, -112, -103, 33, 92, -21, 32, -111, 56, 106, 126, -90, 113, 9, -4, 111, 126, -55, -117, -126, -13, -108, 20, 33, -108, -58, -109, 10, -70, 97, 126, 105, -115, -66, -123, -69, 19, -40, -90, -77, 73, -97, 77, -44, -61, -59, 59, 65, -75, 11, 105, 103, -68, -27, 56, -128, 120, 10, 13, 77, 20, 109, 114, 98, -54, -14, -116, -79, 65, 9, -67, 83, 20, -74, 83, -100, -70, 62, -16, -52, -104, -27, 107, 105, 73, 14, -67, -67, 93, -65, -4, -87, 79, -103, -10, -16, -47, 26, -85, 60, 122, 119, -81, 27, -45, 81, 89, 94, 36, -23, -66, -107, 32, 11, -75, -43, 50, 63, 39, 55, -25, 94, 63, -32, 25, 112, 18, -117, -23, 64, -8, 76, -100, 78, 26, 22, 71, -128, -105, -36, -60, 13, -111, -22, 59, -7, -88, 42, 38, -47, -60, 104, 52, -17, 119, -105, -126, 122, 84, 20, -19, 15, -116, 50, -41, -11, -71, -81, -90, 113, 65, -97, -69, -75, 52, -116, -44, -69, -66, 33, 87, -81, 48, 69, 101, 19, 71, 21, -26, 53, 34, 45, 76, -43, 109, -27, 74, 42, 5, -60, -62, 95, -85, 20, 92, -52, 16, -55, -5, -4, -80, 23, -68, -86, 70, 43, -43, -41, -5, 22, -26, 103, 38, -42, -82, 82, -54, -82, -70, 13, -45, 13, 87, -88, -115, 123, -54, 28, -108, -61, 121, 9, 78, 112, 75, -108, -41, -50, 118, -89, -22, 92, 92, 81, 81, -121, -13, -57, 44, 97, -25, 60, 30};
    logic [7:0] filter [6][25] ='{  '{3, 82, -37, 43, 86, 117, -76, -19, 57, 54, -4, -117, 68, 52, -8, 28, 107, -81, 2, 27, 125, -63, 81, 95, -6},
                            '{48, 88, -86, 29, 44, -45, -99, -46, -48, -113, -116, -122, 126, -48, -101, 107, -127, 7, -30, -35, -95, 122, -48, 113, -104},
                            '{-53, -122, -86, -44, -59, 33, 44, -58, 22, 28, -85, 98, 80, -70, 59, 50, -87, 123, -66, 92, -79, 115, -20, -98, 70},
                            '{125, -26, -57, 91, 88, 112, 81, 80, -97, 73, -107, 2, 60, 31, 117, -92, -32, -35, 34, -68, 13, -28, 42, 91, 25},
                            '{-68, -61, 23, -97, 8, 124, -20, -84, -7, 55, 109, -53, -57, 75, -127, -83, 81, -57, 95, 19, -125, -81, 5, -11, -86},
                           ' {92, 104, 103, 41, 87, -70, 66, -94, 29, 50, 82, -18, -113, -114, 15, 102, 113, -88, -16, -79, -15, 55, -82, 81, 108}};

    logic [7:0] output_captured [10];

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end
    task test_init();    // active at time 0
            axi_addr_a = 'b0;
            axi_wrdata_a = 'b0;
            axi_en_a = 'b0;
            axi_we_a = 'b0;
            start_i                   =  1'b0;

            rst_n                   =  1'b0;
            repeat (3) @(posedge clk);
            rst_n               = 1'b1;
    endtask

    task automatic write_ram(input logic [21:0] addr, input logic [7:0] data);
        axi_we_a = 4'hf;
        axi_addr_a = addr;
        axi_wrdata_a = data;
        @(posedge clk);
        axi_we_a = 4'h0;
    endtask

    task automatic read_ram(input logic [21:0] addr, output logic [7:0] data);

        axi_en_a = 1'b1;
        axi_addr_a = addr;
        @(posedge clk);
        #1
        data = axi_rddata_a;
        axi_en_a = 1'b0;
    endtask

    task test_conv();
        for (int i =0; i<25; i++) begin
            for(int j=0; j<1024; j++) begin
                addr = ((`TAG_SA<<17) + j)<<2;
                data =  img[j];
                write_ram(addr, data);
            end
        end
        
        for(int i = 0; i<16; i++) begin
            for(int j=0; j<25+(25*6); j++) begin
                addr = ((`TAG_SA<<17) + (1<<16) + (i<<8) + j)<<2;
                data = $urandom_range(6,0) - 3;
                write_ram(addr, data);
                
            end
        end

        for(int i = 0; i<128; i++) begin
            for(int j=0; j<1024; j++) begin
                addr = ((`TAG_FC_WEIGHT<<17) + (i<<10) + j)<<2;
                data = $urandom_range(6,0) - 3;
                write_ram(addr, data);
                
            end
        end

        start_i                       = 'd1;
        @(posedge clk);
        start_i                       = 'd0; 


        while(done_o != 1) begin
            @(posedge clk);
        end
         
        for(int i = 0; i<10; i++) begin
            addr = ((`TAG_FC_DATA_BUF<<17) + i)<<2;
            read_ram(addr, data);
            $display("%d  ",data);
            //$display("%d||  %dth : %d,      answer: %d",i,j,data, output_ref[i][j]);
        end

        repeat (10)@(posedge clk);
        $finish;
    endtask

    initial begin
        test_init();
        @(posedge clk);
        test_conv();

    end
    


endmodule