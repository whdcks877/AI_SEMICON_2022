module top_wrapped(
    input   wire            clk,
    input   wire            rst_n,
    
    //config
    input   wire    [1:0]   start,  //0: wait, 1: sa start, 2: fc start
    input   wire    [1:0]   nth_conv_i,

    input wire  [4:0]                   ofmap_size_i,
    input wire  [5:0]                   ifmap_ch_i,

    input   wire    [6:0]   in_node_num_i, //fully connected configure
    input   wire    [6:0]   out_node_num_i,
    
    output wire [17:0] done,

    //bram controller
    input   wire [21:0] addr_a,
    input   wire [31:0] wrdata_a,
    output  wire [31:0] rddata_a,
    input   wire        en_a,
    input   wire        rst_a,
    input   wire [3:0]  we_a
);


    //result data
    wire [7:0]       sa_data_rdata;
    wire [7:0]       fc_data_rdata;
    wire [9:0]       pool_address_rdata;
    
    //sa_bram write
    wire            wea;
    wire    [16:0]  addra;
    wire    [7:0]   dia;

    //fully connected buffer
    wire                          wbuf_wren;
    wire  [16:0]                  wbuf_wrptr;
    wire  [7:0]                   wbuf_wdata;

    wire                          ifmap_wren;
    wire  [6:0]                   ifmap_wrptr;
    wire  [7:0]                   ifmap_wdata;
    
    //pooling
    wire                          sa_data_rden;
    wire  [13:0]                  sa_data_rdptr;

    wire                          fc_data_rden;
    wire  [9:0]                   fc_data_rdptr;

    wire                          pool_address_rden;
    wire  [13:0]                  pool_address_rdptr;

    TOP u_top(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),  
        .nth_conv_i(nth_conv_i),
        .ofmap_size_i(ofmap_size_i),
        .ifmap_ch_i(ifmap_ch_i),
        .in_node_num_i(in_node_num_i), 
        .out_node_num_i(out_node_num_i),
        .wea(wea),
        .addra(addra),
        .dia(dia),
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
        .pool_address_rdata_o(pool_address_rdata)
    );

    addr_decoder u_dut(
        .addr_a(addr_a),
        .wrdata_a(wrdata_a),
        .rddata_a(rddata_a),
        .en_a(en_a),
        .rst_a(),
        .we_a(we_a),
        .sa_data_rdata_i(sa_data_rdata),
        .fc_data_rdata_i(fc_data_rdata),
        .pool_address_rdata_i(pool_address_rdata),
        .wea_o(wea),
        .addra_o(addra),
        .dia_o(dia),
        .wbuf_wren_o(wbuf_wren),
        .wbuf_wrptr_o(wbuf_wrptr),
        .wbuf_wdata_o(wbuf_wdata),
        .ifmap_wren_o(ifmap_wren),
        .ifmap_wrptr_o(ifmap_wrptr),
        .ifmap_wdata_o(ifmap_wdata),
        .sa_data_rden_o(sa_data_rden),
        .sa_data_rdptr_o(sa_data_rdptr),
        .fc_data_rden_o(fc_data_rden),
        .fc_data_rdptr_o(fc_data_rdptr),
        .pool_address_rden_o(pool_address_rden),
        .pool_address_rdptr_o(pool_address_rdptr)
    );
endmodule