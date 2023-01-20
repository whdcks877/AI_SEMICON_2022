// 2023-01-20 2th verified by SM Park

`define     TIMEOUT_CYCLE           10000000

module TB_DMA();

    parameter                   DATA_WIDTH = 8;
    reg                         clk;
    reg                         rst_n;
    reg                         start;
    reg     [1:0]               nth_conv_i;

    reg                         wea[16];
    reg     [DATA_WIDTH-1:0]    dia[16], dob, dio;
    reg     [9:0]               addra[16];

    reg     [DATA_WIDTH-1:0]    accu_data[16];
    reg                         accu_valid[16];

    reg     [4:0]               ofmap_size_i;

    reg                         dma_done;

    wire                        enb;
    wire    [13:0]              addrb;
    wire    [17:0]              addro;


    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end


    task test_init();    // active at time 0
        for(int i=0; i<16; i++) begin
            wea[i]              = 'b0;
            addra[i]            = 'hFFFFF;
            dia[i]              = 'hFFFFF;
        end         
        ofmap_size_i            = 'd0;
    endtask

    task test_init_1();
        rst_n                   = 1'b0;
        start                   = 1'b0;
        nth_conv_i              = 'd0;                
        repeat (3) @(posedge clk) begin          // after 3 cycles,
            rst_n               <= 1'b0;     // release the reset
        end
    endtask

    initial begin
        test_init();
        test_init_1();
        rst_n                   <= 1'b1;

        repeat (196) @(posedge clk) begin
            for(int i=0; i<16; i++) begin
                wea[i]          <= 1'b1;
                addra[i]        <= addra[i] + 'd1;
                dia[i]          <= dia[i] + 'd1;
            end
        end

        #40
        repeat (1) @(posedge clk) begin
            for(int i=0; i<16; i++) begin
                wea[i]                  <= 'b0;
            end
            start                       <= 'b1;
            nth_conv_i                  <= 'd0;
            ofmap_size_i                <= 'd28;
        end

        repeat (1) @(posedge clk) begin
            start                       <= 'b0;
            nth_conv_i                  <= 'd0;
        end

        repeat (196*16 + 20) @(posedge clk);

        repeat (1) @(posedge clk) begin
            start                       <= 'b1;
        end

        repeat (1) @(posedge clk) begin
            start                       <= 'b0;
        end

    end


    SA_TOP u_sa_top
    (
        .clk(clk),
        .rst_n(rst_n),
        .start(),
        .nth_conv_i(nth_conv_i),
        .ofmap_size_i(ofmap_size_i),
        .wea(enbo),
        .addra(addro),
        .dia(dio),
        .accu_data_o(accu_data),
        .accu_valid_o(accu_valid)
    );


    BRAM_DMA u_DMA
    (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .nth_conv_i(nth_conv_i),

        .src_ena_o(enb),
        .addra_o(addrb),
        .src_dia(dob),

        .dst_web_o(enbo),
        .addrb_o(addro),
        .dst_dob(dio),

        .dma_done_o(dma_done)

    );

    Data_sa_buff u_SA_buff
    (
        .clk                        (clk),
        .wea                        (wea),
        .enb                        (enb),
        .addra                      (addra),
        .addrb                      (addrb),
        .dia                        (dia),
        .dob                        (dob)
    );



endmodule