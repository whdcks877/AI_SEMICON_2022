// 2023-01-12 2nd verified by JY Lee
// 2023-01-14 4th verified by SM Park

`define     TIMEOUT_CYCLE           10000000

module TB_MMU();

    parameter                   DATA_WIDTH = 8;
    reg                         clk;
    reg                         rst_n;
    reg                         start;
    reg     [1:0]               nth_conv_i;

    reg                         wea;
    reg     [DATA_WIDTH-1:0]    dia;
    reg     [16:0]              addra;

    reg     [DATA_WIDTH-1:0]    accu_data[16];
    reg                         accu_valid[16];

    reg     [4:0]               ofmap_size_i;


    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end


    task test_init();    // active at time 0
        wea                     = 1'b0;
        dia                     = 'hFFFF;
        addra                   = 'hFFFFF;
        ofmap_size_i             = 'd0;
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

        // repeat (784) @(posedge clk) begin
        //     wea                 <= 1'b1;
        //     addra               <= addra + 'd1;
        //     dia                 <= 'd1;
        // end
        repeat (1024*25) @(posedge clk) begin
            wea                 <= 1'b1;
            addra               <= addra + 'd1;
            dia                 <= dia + 'd1;
            

            // if(addra[10:0] == 'd1024) begin
            //     addra[16:10]    <= addra[16:10] + 'd1;
            //     addra[9:0]      <= 'd0;
            //     dia             <= 'd0;
            // end
            // else begin
            //     addra           <= addra + 'd1;
            //     dia             <= dia + 'd1;
            // end
        end
        repeat (1) @(posedge clk) begin
            wea                 <= 1'b0;
            dia                 <= 'd0;
            addra               <= 17'b00111111111111111;
        end

        // 17'b01 00000 0000 000000
        #20
        repeat (50*16) @(posedge clk) begin
            wea                 <= 1'b1;
            // if(dia) begin
            //     dia             <= 'd0;
            // end
            // else begin
            //     dia             <= 'd1;
            // end
            dia <= dia + 'd1;
            if(addra[5:0] == 'd49) begin
                addra[9:6]      <= addra[9:6] + 'd1;
                addra[5:0]      <= 'd0;
                // dia <= 'd1;
            end
            else begin
                addra           <= addra + 'd1;
            end
        end
        repeat (1) @(posedge clk) begin
            wea                     <= 1'b0;
            dia                     <= 'd0;
        end

        #40
        repeat (1) @(posedge clk) begin
            start                       <= 'b1;
            nth_conv_i                  <= 'd0;
            ofmap_size_i                 <= 'd28;
        end

        repeat (1) @(posedge clk) begin
            start                       <= 'b0;
            nth_conv_i                  <= 'd0;
        end

    end


    SA_TOP u_sa_top
    (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .nth_conv_i(nth_conv_i),
        .ofmap_size_i(ofmap_size_i),
        .wea(wea),
        .addra(addra),
        .dia(dia),
        .accu_data_o(accu_data),
        .accu_valid(accu_valid)
    );



endmodule