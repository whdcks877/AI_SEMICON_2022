`define     TIMEOUT_CYCLE           10000000
`define     DATA_WIDTH              8
`define     BAND_WIDTH              25

module TB_DATAINPUT();
    parameter       SRAM_DEPTH      = 1024;
    parameter       BAND_WIDTH      = 25;
    parameter       DATA_WIDTH      = 8;

    
    reg                         clk;
    reg                         rst;
    reg                         setup_ready[BAND_WIDTH];
    reg                         weight_ready;
    reg                         data_valid[BAND_WIDTH];
    reg     [DATA_WIDTH-1:0]    sa_data[BAND_WIDTH];
    reg     [9:0]               buff_addr[BAND_WIDTH];
    reg                         burst_last;
    integer clk_cnt;

    reg                         enb[BAND_WIDTH];
    reg                         wea;
    reg     [DATA_WIDTH-1:0]    dia;
    reg     [DATA_WIDTH-1:0]    dob[BAND_WIDTH];
    reg     [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addra;         // MSB[$clog2(SRAM_DEPTH)+4:$clog2(SRAM_DEPTH)]: selecting which block among 25 BRAMs
    reg     [$clog2(SRAM_DEPTH)-1:0] addrb[BAND_WIDTH];
    reg     [10:0]              BURST_SIZE;

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    DATAINPUT_TOP #
    (
        .SRAM_DEPTH(1024),
        .BAND_WIDTH(25),
        .DATA_WIDTH(8)
    )
    u_dut
    (
       .clk                         (clk),
       .rst                         (rst),

       .wea                         (wea),
       .addra                       (addra),
       .dia                         (dia),
       .BURST_SIZE                  (BURST_SIZE),
       .weight_ready_i              (weight_ready),
       .data_valid_o                (data_valid),
       .sa_data_o                   (sa_data),
       .burst_last_o                (burst_last)  
    );

    task test_init();
        rst                     = 1'b1;     // active at time 0
        weight_ready            = 1'b0;
        clk_cnt                 = 'd0;
        wea                     = 1'b0;
        dia                     = 'd0;
        addra                   = 'hFFFF;
        BURST_SIZE              = 'd0;

        repeat (3) @(posedge clk);          // after 3 cycles,
            rst                     = 1'b0;     // release the reset
    endtask
    
    initial begin
        test_init();

        #10
        repeat (SRAM_DEPTH*BAND_WIDTH) @(posedge clk) begin
            wea                 <= 1'b1;
            addra               <= addra + 'd1;
            dia                 <= dia + 'd1;
        end
        repeat (1) @(posedge clk) begin
            wea                     <= 1'b0;
        end

        #60
        BURST_SIZE              <= 'd1024;
        weight_ready            <= 1'b1;
        
        repeat(1) @(burst_last) begin
            weight_ready    <= 1'b0; 
        end

        #60
        BURST_SIZE              <= 'd784;
        weight_ready            <= 1'b1;
        repeat(1) @(burst_last) begin
            weight_ready    <= 1'b0;
        end

        #60
        BURST_SIZE              <= 'd196;
        weight_ready            <= 1'b1;
        repeat(1) @(burst_last) begin
            weight_ready    <= 1'b0;
        end

        #60
        BURST_SIZE              <= 'd100;
        weight_ready            <= 1'b1;
        repeat(1) @(burst_last) begin
            weight_ready    <= 1'b0;
        end

        #60
        BURST_SIZE              <= 'd25;
        weight_ready            <= 1'b1;
        repeat(1) @(burst_last) begin
            weight_ready    <= 1'b0;
        end
    end

endmodule
