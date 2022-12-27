`include "ACC_IF.sv"
`include "Accumulator.sv"


`define     CH_SIZE         16
`define     OFMAP_SIZE      1024
`define     TIMEOUT_CYCLE         10000000
module TB_Accmulator();

    reg                     clk;
    reg                     rst_n;
    
    reg conv_valid;
    reg [7:0]   conv_data;
    reg pready;

    byte psum_arr [`CH_SIZE][`OFMAP_SIZE];
    int correct_data [`OFMAP_SIZE]= '{default:0};
    
    initial begin
		#`TIMEOUT_CYCLE $display("Timeout!");
		$finish;
	end
    initial begin
        clk                     = 1'b0;

        forever #10 clk         = !clk;
    end
    

    ACC_IF acc_if(.clk(clk), .rst_n(rst_n));
    
    Accmulator u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .psum_i(acc_if.psum),
        .pvaild_i(acc_if.pvalid),
        .pready_o(acc_if.pready),
        .ofmap_size(acc_if.ofmap_size),
        .ifmap_ch(acc_if.ifmap_ch),
        .conv_valid_o(acc_if.conv_valid),
        .conv_result_o(acc_if.conv_result)
    );
    int ofmap_size_data = 6**2;
    int ifmap_ch_data = 3;

    task test_init();
        rst_n                   = 1'b0;     // active at time 0
        repeat (3) @(posedge clk);          // after 3 cycles,
        rst_n                   = 1'b1;     // release the reset
        
        acc_if.init(`OFMAP_SIZE-1,`CH_SIZE-1);
        for(int i = 0; i<`CH_SIZE; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                psum_arr[i][j] = $urandom_range(255,0)-128;
            end
        end
        
        //accumulate
        for(int i = 0; i<`CH_SIZE; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                correct_data[j] = correct_data[j] + psum_arr[i][j];
            end
        end
        
        for(int i = 0; i<`CH_SIZE; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                if(correct_data[j]> 127) begin
                    correct_data[j] = 127 ;
                end else if(correct_data[j]< -128) begin
                    correct_data[j] = -128 ;
                end
            end
        end
    endtask

    task acc_test_feeddata();
        acc_if.pvalid = 1'b1;
        for(int i = 0; i<`CH_SIZE; i=i+1) begin
            for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
                acc_if.psum = psum_arr[i][j];
                 @(posedge clk);
                $display("feed data : %d to %d,%d",psum_arr[i][j],i,j);
            end
        end
        acc_if.pvalid = 1'b0;
    endtask

    task acc_test_capture();
        byte data;
        for(int j = 0; j<`OFMAP_SIZE; j=j+1) begin
            acc_if.capture_data(data);
            $display("%d : captured data = %d, correct data = %d",j,data, correct_data[j]);
            if(data != correct_data[j]) begin
                $display("mismatch!");
                $finish;
            end
        end
    endtask


    initial begin
        test_init();

        fork
            acc_test_feeddata();
            acc_test_capture();
        join
        $display("pass");
        $finish;
    end
endmodule