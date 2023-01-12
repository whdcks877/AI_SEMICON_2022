`include "ACC_IF_x16.sv"
`include "Accumulator_x16.sv"

`define     CH_SIZE         16  //setting input channel size
`define     OFMAP_SIZE      25  //setting ouput feature map size
`define     N_COL           16
`define     TIMEOUT_CYCLE         10000000

module TB_Accumulator_x16();

    reg                     clk;
    reg                     rst_n;

    byte psum_arr [`N_COL][`CH_SIZE][`OFMAP_SIZE];
    int correct_data [`N_COL][`OFMAP_SIZE]= '{default:0};

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;

        forever #10 clk         = !clk;
    end

    ACC_IF_x16 acc_if (.clk(clk), .rst_n(rst_n));
    
    Accumulator_x16 u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .psum_i(acc_if.psum),
        .pvalid_i(acc_if.pvalid),
        .pready_o(acc_if.pready),
        .ofmap_size_i(acc_if.ofmap_size),
        .ifmap_ch_i(acc_if.ifmap_ch),
        .conv_valid_o(acc_if.conv_valid),
        .conv_last_o(acc_if.conv_last),
        .conv_result_o(acc_if.conv_result)
    );

    task test_init();
        rst_n                   = 1'b0;     // active at time 0
        repeat (3) @(posedge clk);          // after 3 cycles,
        rst_n                   = 1'b1;     // release the reset
        
        acc_if.init(`OFMAP_SIZE-1,`CH_SIZE-1);

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
    endtask

    task automatic acc_test_feeddata(input int col);
        for(int i = 0; i<`CH_SIZE; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                acc_if.data_feed(col, psum_arr[col][i][j]);
            end
        end
    endtask

    task automatic acc_test_capture(input int col);
        byte data;
        for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
            acc_if.capture_data(col, data);
            $display("col)%d , idx) %d : captured data = %d, correct data = %d",col,j,data, correct_data[col][j]);
            if(data != correct_data[col][j]) begin
                $display("mismatch!");
                $finish;
            end
        end
    endtask
    
    initial begin

        test_init();
        
        for(int col=0; col<`N_COL; col++) begin
             fork
                automatic int col_i = col;
                acc_test_feeddata(col_i);
                acc_test_capture(col_i);
              join_none
         end
        wait fork;
        $display("pass");
        repeat (3) @(posedge clk); 
        $finish;
    end

endmodule