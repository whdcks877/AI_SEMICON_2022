// 2023-01-12 2nd verified by JY Lee
// 2023-01-13 3rd verified by JY Lee

`define     CH_SIZE         3      //setting input channel size
`define     OFMAP_SIZE      4*4     //setting ouput feature map size
`define     OFMAP_SIZE_SQRT 4
`define     FC_SIZE         120
`define     N_COL           16

`define     TIMEOUT_CYCLE           10000000

module TB_TOP();

    parameter                   DATA_WIDTH = 8;
    reg                         clk;
    reg                         rst_n;
    reg     [1:0]               start;
    reg     [1:0]               nth_conv_i;

    reg                         wea;
    reg     [DATA_WIDTH-1:0]    dia;
    reg     [16:0]              addra;

    reg     [DATA_WIDTH-1:0]    accu_data[15:0];
    reg                         accu_valid[15:0];

    logic [7:0] wbuf_wdata [`FC_SIZE];
    logic [6:0] addr [`FC_SIZE];
    logic [6:0] addr_fc [`FC_SIZE];

    logic [6:0] ifmap_wrptr;

    logic                         fc_last_o;
    logic                         fc_valid_o;
    logic [7:0]        fc_result_o;

    logic                         pool_last_o [16];
    logic                         pool_valid_o [16];
    logic [7:0]        pool_result_o [16];
    logic [9:0]     pool_result_address_o [16];

    logic    [6:0]   in_node_num_i; //fully connected configure
    logic    [6:0]   out_node_num_i;

    byte psum_arr [`N_COL][`CH_SIZE][`OFMAP_SIZE];
    int correct_data [`N_COL][`OFMAP_SIZE]= '{default:0};
    int pooled_data [`N_COL][`OFMAP_SIZE/4];

    int in_node_num = 120; //setting number of input node
    int out_node_num = 84; //setting number of output node

    byte input_node [`FC_SIZE] = '{default:0};
    byte output_node [`FC_SIZE];
    byte weight [`FC_SIZE][`FC_SIZE]= '{default:0};
    byte output_node_ans [`FC_SIZE] = '{default:0};


    ACC_IF_x16 acc_if (.clk(clk), .rst_n(rst_n));
    fc_ifmap_buf_if ifbuf_if(.clk(clk), .rst_n(rst_n));
    fc_w_buf_if wbuf_if(.clk(clk), .rst_all(rst_n));


    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    task buffer_load();
        $display("buffer load start");
        //weight_buffer write
        for (int i=0; i<out_node_num; i++) begin
            addr_fc = '{default:i};
            wbuf_if.write_ram(addr_fc,weight[i]);
        end
        

        //ifmap buffer write
        for (int i=0; i<in_node_num; i++) begin
            ifmap_wrptr = i;
            ifbuf_if.write_ram(ifmap_wrptr,input_node[in_node_num - 1- i]);
        end
        $display("buffer load finished");
    endtask


    task test_init_fc();
        in_node_num= 0;
        out_node_num = 0;

        wbuf_if.init();
        ifbuf_if.init();

        acc_if.init(`OFMAP_SIZE_SQRT,`CH_SIZE);

        for(int i = 0; i<16; i=i+1) begin
            for(int j = 0; j<`CH_SIZE; j=j+1) begin
                for(int k = 0; k<`OFMAP_SIZE; k=k+1) begin
                    psum_arr[i][j][k] = $urandom_range(6,0)-3;
                end
            end
        end

        for (int i=0; i<in_node_num; i++) begin
            input_node[i] = $urandom_range(6,0)-3; //setting range of random number (-3~3)
        end

        for (int i=0; i<out_node_num; i++) begin
            for (int j=0; j<in_node_num; j++) begin
                weight[i][j] = $urandom_range(6,0)-3; //setting range of random number (-3~3)
            end
        end
        
    endtask


    task test_init();    // active at time 0
            wea                     = 1'b0;
            dia                     = 'd0;
            addra                   = 'hFFFFF;
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
        test_init_fc();
        rst_n                   <= 1'b1;

         repeat (2048*25) @(posedge clk) begin
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
        start                       <= 'd1;
        nth_conv_i                  <= 'd1;
    end

    task pe_array_start();
        $display("pe start...");
        start = 2;
        in_node_num_i = in_node_num;
        out_node_num_i = out_node_num; 

        @(posedge clk);
        start = 0;
        in_node_num_i = 0;
        out_node_num_i = 0; 
    endtask


    TOP u_dut(
        .clk(clk),
        .rst_n(rst_n),
        .start(start), 
        .nth_conv_i(nth_conv_i),
        .ofmap_size_i(acc_if.ofmap_size),
        .ifmap_ch_i(acc_if.ifmap_ch),
        .in_node_num_i(in_node_num_i),
        .out_node_num_i(out_node_num_i),
        .wea(wea),
        .addra(addra),
        .dia(dia),
        .wbuf_wren_i(wbuf_if.wren_i),
        .wbuf_wrptr_i(wbuf_if.wrptr_i),
        .wbuf_wdata_i(wbuf_if.weight_i),
        .ifmap_wren_i(ifbuf_if.wren_i),
        .ifmap_wrptr_i(ifbuf_if.wrptr_i),
        .ifmap_wdata_i(ifbuf_if.ifmap_i),
        .fc_last_o(fc_last_o),
        .fc_valid_o(fc_valid_o),
        .fc_result_o(fc_result_o),
        .pool_last_o(pool_last_o),
        .pool_valid_o(pool_valid_o),
        .pool_result_o(pool_result_o),
        .pool_result_address_o(pool_result_address_o)
    );

endmodule