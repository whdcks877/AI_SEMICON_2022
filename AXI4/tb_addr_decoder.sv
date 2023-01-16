`include "addr_decoder.sv"

`define     TIMEOUT_CYCLE           10000000


module tb_addr_decoder();
    reg                 clk;
    reg                 rst_n;

    logic [21:0]        addr_a;
    logic [31:0]        wrdata_a;
    logic [31:0]        rddata_a;
    logic               en_a;
    logic               rst_a;
    logic [3:0]         we_a;

    //result data
    logic [7:0]       sa_data_rdata_i;
    logic [7:0]       fc_data_rdata_i;
    logic [9:0]                   pool_address_rdata_i;
    
    //sa_bram write
    logic            wea_o;
    logic    [16:0]  addra_o;
    logic    [7:0]   dia_o;

    //fully connected buffer
    logic                          wbuf_wren_o;
    logic  [16:0]                  wbuf_wrptr_o;
    logic  [7:0]                   wbuf_wdata_o;

    logic                          ifmap_wren_o;
    logic  [6:0]                   ifmap_wrptr_o;
    logic  [7:0]                   ifmap_wdata_o;
    
    //pooling
    logic                          sa_data_rden_o;
    logic  [13:0]                  sa_data_rdptr_o;

    logic                          fc_data_rden_o;
    logic  [9:0]                   fc_data_rdptr_o;

    logic                          pool_address_rden_o;
    logic  [13:0]                  pool_address_rdptr_o;

    string state = "INIT";

    addr_decoder u_dut(
        .addr_a(addr_a),
        .wrdata_a(wrdata_a),
        .rddata_a(rddata_a),
        .en_a(en_a),
        .rst_a(),
        .we_a(we_a),
        .sa_data_rdata_i(sa_data_rdata_i),
        .fc_data_rdata_i(fc_data_rdata_i),
        .pool_address_rdata_i(pool_address_rdata_i),
        .wea_o(wea_o),
        .addra_o(addra_o),
        .dia_o(dia_o),
        .wbuf_wren_o(wbuf_wren_o),
        .wbuf_wrptr_o(wbuf_wrptr_o),
        .wbuf_wdata_o(wbuf_wdata_o),
        .ifmap_wren_o(ifmap_wren_o),
        .ifmap_wrptr_o(ifmap_wrptr_o),
        .ifmap_wdata_o(ifmap_wdata_o),
        .sa_data_rden_o(sa_data_rden_o),
        .sa_data_rdptr_o(sa_data_rdptr_o),
        .fc_data_rden_o(fc_data_rden_o),
        .fc_data_rdptr_o(fc_data_rdptr_o),
        .pool_address_rden_o(pool_address_rden_o),
        .pool_address_rdptr_o(pool_address_rdptr_o)
    );

    initial begin
	    #`TIMEOUT_CYCLE $display("Timeout!");
	    $finish;
	end

    initial begin
        clk                     = 1'b0;
        forever #10 clk         = !clk;
    end

    task test_init();
        addr_a = 'b0;
        wrdata_a = 'b0;
        en_a = 'b0;
        we_a = 'b0;

        repeat (3) @(posedge clk);
    endtask

    task write_sa();
        $display("write input...");
        state = "sa input";
        for(int i=0; i<25; i++) begin
            for(int j =0; j<2048; j++) begin
                addr_a = ((`TAG_SA<<17) + (i<<11) + j)<<2;
                en_a = 1'b1;
                we_a = 4'hf;
                wrdata_a = j + 1;
                @(posedge clk);
                en_a = 1'b0;
                we_a = 4'h0;
            end
        end
        state = "idle";

        repeat (10) @(posedge clk);

        $display("write weight...");
        state = "sa weight";
        for(int i=0; i<16; i++) begin
            for(int j =0; j<50; j++) begin
                addr_a = ((`TAG_SA<<17) + (1<<16) + (i<<11) + j)<<2;
                en_a = 1'b1;
                we_a = 4'hf;
                wrdata_a = j + 1;
                @(posedge clk);
                en_a = 1'b0;
                we_a = 4'h0;
            end
        end
        state = "idle";
    endtask

    task write_fc();
        $display("write fc weight...");
        state = "fc weight";
        for(int i=0; i<120; i++) begin
            for(int j =0; j<84; j++) begin
                addr_a = ((`TAG_FC_WEIGHT<<17) + (i<<10) + j)<<2;
                en_a = 1'b1;
                we_a = 4'hf;
                wrdata_a = j + 1;
                @(posedge clk);
                en_a = 1'b0;
                we_a = 4'h0;
            end
        end
        state = "idle";
        repeat (10) @(posedge clk);

        $display("write fc input...");
        state = "fc input";
        for(int i=0; i<120; i++) begin
            addr_a = ((`TAG_FC_INPUT<<17) + i)<<2;
            en_a = 1'b1;
            we_a = 4'hf;
            wrdata_a = i + 1;
            @(posedge clk);
            en_a = 1'b0;
            we_a = 4'h0;
        end
        state = "idle";
    endtask

    task read_data();
        $display("read sa data...");
        state = "read sa data";
        for(int i=0; i<16; i++) begin
            for(int j =0; j<1024; j++) begin
                addr_a = ((`TAG_SA_DATA_BUF<<17)+ (i<<10) + j)<<2;
                en_a = 1'b1;
                @(posedge clk);
                en_a = 1'b0;
            end
        end
        state = "idle";
        repeat (10) @(posedge clk);

        $display("read sa addr...");
        state = "read sa addr";
        for(int i=0; i<16; i++) begin
            for(int j =0; j<1024; j++) begin
                addr_a = ((`TAG_P_ADDR_BUF<<17)+ (i<<10) + j)<<2;
                en_a = 1'b1;
                @(posedge clk);
                en_a = 1'b0;
            end
        end
        state = "idle";
        repeat (10) @(posedge clk);

        $display("read fc data...");
        state = "read fc data";
        for(int i=0; i<1024; i++) begin
            addr_a = ((`TAG_FC_DATA_BUF<<17)+ i)<<2;
            en_a = 1'b1;
            @(posedge clk);
            en_a = 1'b0;
        end
        state = "idle";
    endtask

    initial begin
        test_init();
        write_sa();
        repeat (10) @(posedge clk);
        write_fc();
        repeat (10) @(posedge clk);
        read_data();
        repeat (10) @(posedge clk);
        $finish;
    end


endmodule