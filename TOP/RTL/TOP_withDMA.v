module TOP_withDMA(
    input   wire            clk,
    input   wire            rst_n,
    
    //axi tpu controller
    input   wire    start_i,
    output wire done_o, 

    //axi bram controller
    input   wire [21:0] axi_addr_a,
    input   wire [31:0] axi_wrdata_a,
    output  wire [31:0] axi_rddata_a,
    input   wire        axi_en_a,
    input   wire        axi_rst_a,
    input   wire [3:0]  axi_we_a
);
    wire [1:0]  dma_start;
    wire [1:0]  nth_conv;
    wire [4:0]  ofmap_size;
    wire [5:0]  ifmap_ch;
    wire [8:0]  in_node_num;
    wire [6:0]  out_node_num;
    wire [15:0] pool_last;
    wire        act_last;
    wire [16:0] core_done = {act_last, pool_last};
    wire [1:0]  start_core;
    wire        dma_done;

    wire        dma_input_bram_wren;
    wire [16:0] dma_input_bram_addr; 
    wire [7:0]  dma_input_bram_wrdata;

    wire        axi_input_bram_wren;
    wire [16:0] axi_input_bram_addr;
    wire [7:0]  axi_input_bram_wrdata;
    
    wire        input_bram_wren = dma_input_bram_wren || axi_input_bram_wren;
    wire [16:0] input_bram_addr = axi_input_bram_wren ? axi_input_bram_addr : dma_input_bram_addr;
    wire [7:0]  input_bram_wrdata = axi_input_bram_wren ? axi_input_bram_wrdata : dma_input_bram_wrdata;

    wire        axi_ifmap_wren;
    wire [9:0]  axi_ifmap_wrptr;
    wire [7:0]  axi_ifmap_wdata;

    wire        dma_ifmap_wren;
    wire [9:0]  dma_ifmap_wrptr;
    wire [7:0]  dma_ifmap_wdata;

    wire        ifmap_wren = axi_ifmap_wren || dma_ifmap_wren;
    wire [9:0]  ifmap_wrptr = axi_ifmap_wren ? axi_ifmap_wrptr : dma_ifmap_wrptr;
    wire [7:0]  ifmap_wdata = axi_ifmap_wren ? axi_ifmap_wdata : dma_ifmap_wdata;

    wire        axi_fc_data_rden;
    wire [9:0]  axi_fc_data_rdptr;

    wire        dma_fc_data_rden;
    wire [9:0]  dma_fc_data_rdptr;

    wire        fc_data_rden = axi_fc_data_rden || dma_fc_data_rden;
    wire [9:0]  fc_data_rdptr = axi_fc_data_rden ? axi_fc_data_rdptr : dma_fc_data_rdptr;
    wire [7:0]  fc_data_rdata;

    wire        axi_sa_data_rden;
    wire [13:0] axi_sa_data_rdptr;

    wire        dma_sa_data_rden;
    wire [13:0] dma_sa_data_rdptr;

    wire        sa_data_rden = axi_sa_data_rden || dma_sa_data_rden;
    wire [13:0] sa_data_rdptr = axi_sa_data_rden ?  axi_sa_data_rdptr : dma_sa_data_rdptr;
    wire [7:0]  sa_data_rdata;

        //fully connected buffer
    wire                          wbuf_wren;
    wire  [16:0]                  wbuf_wrptr;
    wire  [7:0]                   wbuf_wdata;

    wire                          pool_address_rden;
    wire  [13:0]                  pool_address_rdptr;

    TOP u_top(
        .clk(clk),
        .rst_n(rst_n),
        .start(start_core),  
        .nth_conv_i(nth_conv),
        .ofmap_size_i(ofmap_size),
        .ifmap_ch_i(ifmap_ch),
        .in_node_num_i(in_node_num), 
        .out_node_num_i(out_node_num),
        .wea(input_bram_wren),
        .addra(input_bram_addr),
        .dia(input_bram_wrdata),
        .wbuf_wren_i(wbuf_wren),
        .wbuf_wrptr_i(wbuf_wrptr),
        .wbuf_wdata_i(wbuf_wdata),
        .ifmap_wren_i(ifmap_wren),
        .ifmap_wrptr_i(ifmap_wrptr),
        .ifmap_wdata_i(ifmap_wdata),
        .sa_data_rden_i(sa_data_rden),
        .sa_data_rdptr_i(sa_data_rdptr),
        .fc_data_rden_i(fc_data_rden),
        .fc_data_rdptr_i(fc_data_rdptr),
        .pool_address_rden_i(pool_address_rden),
        .pool_address_rdptr_i(pool_address_rdptr),
        .sa_data_rdata_o(sa_data_rdata),
        .fc_data_rdata_o(fc_data_rdata),
        .pool_address_rdata_o(),
        .pool_last_o(pool_last),
        .act_last_o(act_last)
    );

    addr_decoder u_decoder(
        .addr_a(axi_addr_a),
        .wrdata_a(axi_wrdata_a),
        .rddata_a(axi_rddata_a),
        .en_a(axi_en_a),
        .rst_a(),
        .we_a(axi_we_a),
        .sa_data_rdata_i(sa_data_rdata),
        .fc_data_rdata_i(fc_data_rdata),
        .pool_address_rdata_i(),
        .wea_o(axi_input_bram_wren),
        .addra_o(axi_input_bram_addr),
        .dia_o(axi_input_bram_wrdata),
        .wbuf_wren_o(wbuf_wren),
        .wbuf_wrptr_o(wbuf_wrptr),
        .wbuf_wdata_o(wbuf_wdata),
        .ifmap_wren_o(axi_ifmap_wren),
        .ifmap_wrptr_o(axi_ifmap_wrptr),
        .ifmap_wdata_o(axi_ifmap_wdata),
        .sa_data_rden_o(axi_sa_data_rden),
        .sa_data_rdptr_o(axi_sa_data_rdptr),
        .fc_data_rden_o(axi_fc_data_rden),
        .fc_data_rdptr_o(axi_fc_data_rdptr),
        .pool_address_rden_o(pool_address_rden),
        .pool_address_rdptr_o(pool_address_rdptr)
    );


    BRAM_DMA_v2 u_dma(
        .clk(clk),
        .rst_n(rst_n),
        .start(dma_start),
        .nth_conv_i(nth_conv),
        .sa_data_rden_o(dma_sa_data_rden),
        .sa_data_rdptr_o(dma_sa_data_rdptr),
        .sa_data_rdata_i(sa_data_rdata),
        .fc_data_rden_o(dma_fc_data_rden),
        .fc_data_rdptr_o(dma_fc_data_rdptr),
        .fc_data_rdata_i(fc_data_rdata),
        .sa_wea_o(dma_input_bram_wren),
        .sa_addra_o(dma_input_bram_addr),
        .sa_dia_o(dma_input_bram_wrdata),
        .ifmap_wren_o(dma_ifmap_wren),
        .ifmap_wrptr_o(dma_ifmap_wrptr),
        .ifmap_wdata_o(dma_ifmap_wdata),
        .dma_done_o(dma_done)
    );

    tpu_layer_ctrl u_tpu_ctrl(
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i),
        .start_dma_o(dma_start),
        .nth_conv_o(nth_conv),
        .dma_done_i(dma_done),
        .ofmap_size_o(ofmap_size),
        .ifmap_ch_o(ifmap_ch),
        .in_node_num_o(in_node_num),
        .out_node_num_o(out_node_num),
        .done(core_done), 
        .start_core_o(start_core),
        .cnn_done_o(done_o)
    );

endmodule