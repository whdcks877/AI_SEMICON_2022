`include "DATA_SETUP.sv"

`define     TIMEOUT_CYCLE           10000000
`define     DATA_WIDTH              8
`define     BAND_WIDTH              25

module TB_DATA_SETUP();
    parameter       BAND_WIDTH      = 25;
    parameter       DATA_WIDTH      = 8;

    
    reg                         clk;
    reg                         rst_n;
    reg                         buff_valid[BAND_WIDTH];
    reg     [DATA_WIDTH-1:0]    buff_data[BAND_WIDTH];
    reg                         setup_ready[BAND_WIDTH];
    reg                         weight_ready;
    reg                         data_valid[BAND_WIDTH];
    reg     [DATA_WIDTH-1:0]    sa_data[BAND_WIDTH];
    integer clk_cnt;

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    DATA_SETUP #(
        .BAND_WIDTH(25),
        .DATA_WIDTH(8)
    )
    u_dut
    (
        .clk(clk),
        .rst(rst_n),
        .buff_valid_i(buff_valid),
        .buff_data_i(buff_data),
        .setup_ready_o(setup_ready),
        .weight_ready_i(weight_ready),
        .data_valid_o(data_valid),
        .sa_data_o(sa_data)
    );


    task test_init();
        rst_n                   = 1'b1;     // active at time 0
        weight_ready            = 1'b0;
        for(int i=0; i <25; i++) begin
            buff_valid[i]       = 1'b0;
            buff_data[i]        = 'd0;
        end
        clk_cnt                 = 'd0;
        repeat (3) @(posedge clk);          // after 3 cycles,
        rst_n                   = 1'b0;     // release the reset
    endtask
    
    initial begin
        test_init();
        for(int i=0; i<25; i++) begin
            buff_data[i]        = 1;
            $display("buff_data[%d] : %d", i, i);
            buff_valid[i]       = 1'b1;
        end

        #40
        weight_ready            <= 1'b1;

        forever @(posedge clk) begin
            for(int i=0; i<25; i++) begin
                if(buff_valid[i] && setup_ready[i]) begin
                    buff_data[i]        <= buff_data[i] + 1;
                end
            end
            clk_cnt     <= clk_cnt + 1;
        end
    end

endmodule