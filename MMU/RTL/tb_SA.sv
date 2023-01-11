// testbench for SA_TOP
// JY Lee
// Version 2023-01-10 1st verified

`define     TIMEOUT_CYCLE           10000000

module TB_SA();  
    reg                         clk;
    reg                         rst_n;
    reg                         start;
    reg                         nth_conv_i;
    reg                         data_last;
    reg                         data_enable_o;
    reg     [7:0]               data_i[24:0];
    reg                         dvalid_i;
    reg                         burst_last_i;
    reg                         w_enable[15:0];
    reg     [5:0]               w_addr[15:0];
    reg     [7:0]               w_data_i[15:0];
    reg                         accu_valid[15:0];

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    SA_TOP u_sa_top
    (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .nth_conv_i(nth_conv_i),
        .data_last(data_last),
        .data_enable_o(data_enable_o),
        .data_i(data_i),
        .dvalid_i(dvalid_i),
        .burst_last_i(burst_last_i),
        .w_enable(w_enable),
        .w_addr(w_addr),
        .w_data_i(w_data_i),
        .accu_valid(accu_valid)
    );

    task test_init();
        rst_n                   = 1'b0;     // active at time 0
        start                   = 1'b0;
        nth_conv_i              = 1'b0;
        data_last               = 1'b0;
        data_enable_o           = 1'b0;
        data_i[0] = 'd0;
        data_i[1] = 'd0; 
        data_i[2] = 'd0; 
        data_i[3] = 'd0; 
        data_i[4] = 'd0; 
        data_i[5] = 'd0; 
        data_i[6] = 'd0; 
        data_i[7] = 'd0; 
        data_i[8] = 'd0; 
        data_i[9] = 'd0; 
        data_i[10] = 'd0;
        data_i[11] = 'd0;
        data_i[12] = 'd0;
        data_i[13] = 'd0;
        data_i[14] = 'd0;
        data_i[15] = 'd0;
        data_i[16] = 'd0;
        data_i[17] = 'd0;
        data_i[18] = 'd0;
        data_i[19] = 'd0;
        data_i[20] = 'd0;
        data_i[21] = 'd0;
        data_i[22] = 'd0;
        data_i[23] = 'd0;
        data_i[24] = 'd0;
        dvalid_i = 1'b0;
        burst_last_i = 1'b0;
        w_enable[0] = 1'b0;
        w_enable[1] = 1'b0;
        w_enable[2] = 1'b0;
        w_enable[3] = 1'b0;
        w_enable[4] = 1'b0;
        w_enable[5] = 1'b0;     
        w_enable[6] = 1'b0;     
        w_enable[7] = 1'b0;     
        w_enable[8] = 1'b0;     
        w_enable[9] = 1'b0;     
        w_enable[10] = 1'b0;    
        w_enable[11] = 1'b0;    
        w_enable[12] = 1'b0;    
        w_enable[13] = 1'b0;    
        w_enable[14] = 1'b0;    
        w_enable[15] = 1'b0;
        w_addr[0] = 'd0;
        w_addr[1] = 'd0;
        w_addr[2] = 'd0;        
        w_addr[3] = 'd0;        
        w_addr[4] = 'd0;        
        w_addr[5] = 'd0;        
        w_addr[6] = 'd0;        
        w_addr[7] = 'd0;        
        w_addr[8] = 'd0;        
        w_addr[9] = 'd0;        
        w_addr[10] = 'd0;       
        w_addr[11] = 'd0;       
        w_addr[12] = 'd0;       
        w_addr[13] = 'd0;       
        w_addr[14] = 'd0;       
        w_addr[15] = 'd0;   
        w_data_i[0] = 'd0;
        w_data_i[1] = 'd0;
        w_data_i[2] = 'd0;      
        w_data_i[3] = 'd0;      
        w_data_i[4] = 'd0;      
        w_data_i[5] = 'd0;      
        w_data_i[6] = 'd0;      
        w_data_i[7] = 'd0;      
        w_data_i[8] = 'd0;      
        w_data_i[9] = 'd0;      
        w_data_i[10] = 'd0;     
        w_data_i[11] = 'd0;     
        w_data_i[12] = 'd0;     
        w_data_i[13] = 'd0;     
        w_data_i[14] = 'd0;     
        w_data_i[15] = 'd0;  
        accu_valid[0] = 'd0;
        accu_valid[1] = 'd0;
        accu_valid[2] = 'd0;    
        accu_valid[3] = 'd0;    
        accu_valid[4] = 'd0;    
        accu_valid[5] = 'd0;    
        accu_valid[6] = 'd0;    
        accu_valid[7] = 'd0;    
        accu_valid[8] = 'd0;    
        accu_valid[9] = 'd0;    
        accu_valid[10] = 'd0;   
        accu_valid[11] = 'd0;   
        accu_valid[12] = 'd0;   
        accu_valid[13] = 'd0;   
        accu_valid[14] = 'd0;   
        accu_valid[15] = 'd0;                 
        repeat (3) @(posedge clk);          // after 3 cycles,
            rst_n                  = 1'b1;     // release the reset
            start                   = 1'b1;
    endtask
    task weight_input();
        repeat (25) @(posedge clk) begin
            w_data_i[0] <= w_data_i[0] + 'd1;
            w_data_i[1] <= w_data_i[1] + 'd1;
            w_data_i[2] <= w_data_i[2] + 'd1;
            w_data_i[3] <= w_data_i[3] + 'd1;
            w_data_i[4] <= w_data_i[4] + 'd1;
            w_data_i[5] <= w_data_i[5] + 'd1;
            w_data_i[6] <= w_data_i[6] + 'd1;
            w_data_i[7] <= w_data_i[7] + 'd1;
            w_data_i[8] <= w_data_i[8] + 'd1;
            w_data_i[9] <= w_data_i[9] + 'd1;
            w_data_i[10] <= w_data_i[10] + 'd1;
            w_data_i[11] <= w_data_i[11] + 'd1;
            w_data_i[12] <= w_data_i[12] + 'd1;
            w_data_i[13] <= w_data_i[13] + 'd1;
            w_data_i[14] <= w_data_i[14] + 'd1;
            w_data_i[15] <= w_data_i[15] + 'd1;
        end
    endtask

    task data_input();
        repeat (29) @(posedge clk) begin
            dvalid_i = 1'b1;
            data_i[0] <= data_i[0] + 'd1;
            data_i[1] <= data_i[1] + 'd1;
            data_i[2] <= data_i[2] + 'd1;
            data_i[3] <= data_i[3] + 'd1;
            data_i[4] <= data_i[4] + 'd1;
            data_i[5] <= data_i[5] + 'd1;
            data_i[6] <= data_i[6] + 'd1;
            data_i[7] <= data_i[7] + 'd1;
            data_i[8] <= data_i[8] + 'd1;
            data_i[9] <= data_i[9] + 'd1;
            data_i[10] <= data_i[10] + 'd1;
            data_i[11] <= data_i[11] + 'd1;
            data_i[12] <= data_i[12] + 'd1;
            data_i[13] <= data_i[13] + 'd1;
            data_i[14] <= data_i[14] + 'd1;
            data_i[15] <= data_i[15] + 'd1;
            data_i[16] <= data_i[16] + 'd1;
            data_i[17] <= data_i[17] + 'd1;
            data_i[18] <= data_i[18] + 'd1;
            data_i[19] <= data_i[19] + 'd1;
            data_i[20] <= data_i[20] + 'd1;
            data_i[21] <= data_i[21] + 'd1;
            data_i[22] <= data_i[22] + 'd1;
            data_i[23] <= data_i[23] + 'd1;
            data_i[24] <= data_i[24] + 'd1;
        end
        repeat (1) @(posedge clk) begin
            burst_last_i <= 1'b1;
            data_i[0] <= data_i[0] + 'd1;
            data_i[1] <= data_i[1] + 'd1;
            data_i[2] <= data_i[2] + 'd1;
            data_i[3] <= data_i[3] + 'd1;
            data_i[4] <= data_i[4] + 'd1;
            data_i[5] <= data_i[5] + 'd1;
            data_i[6] <= data_i[6] + 'd1;
            data_i[7] <= data_i[7] + 'd1;
            data_i[8] <= data_i[8] + 'd1;
            data_i[9] <= data_i[9] + 'd1;
            data_i[10] <= data_i[10] + 'd1;
            data_i[11] <= data_i[11] + 'd1;
            data_i[12] <= data_i[12] + 'd1;
            data_i[13] <= data_i[13] + 'd1;
            data_i[14] <= data_i[14] + 'd1;
            data_i[15] <= data_i[15] + 'd1;
            data_i[16] <= data_i[16] + 'd1;
            data_i[17] <= data_i[17] + 'd1;
            data_i[18] <= data_i[18] + 'd1;
            data_i[19] <= data_i[19] + 'd1;
            data_i[20] <= data_i[20] + 'd1;
            data_i[21] <= data_i[21] + 'd1;
            data_i[22] <= data_i[22] + 'd1;
            data_i[23] <= data_i[23] + 'd1;
            data_i[24] <= data_i[24] + 'd1;
        end
        repeat (1) @(posedge clk) begin
            burst_last_i <= 1'b0;
            dvalid_i <= 1'b0;
        end
    endtask

    initial begin
        test_init();
    end

    always @(posedge w_enable[0]) begin
        weight_input();
    end

    //data input
    always @(posedge data_enable_o) begin
        #100
        data_input();
    end

endmodule