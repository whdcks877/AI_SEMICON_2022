`define POOL_NUM 16
`define ADDRESS_WIDTH 10
`define     FC_SIZE         120
`define DATA_WIDTH  8

module TOP(
    input   wire            clk,
    input   wire            rst_n,
    input   wire            rst_pool_n,
    
    //config
    input   wire    [1:0]   start,  //0: wait, 1: sa start, 2: fc start
    input   wire    [1:0]   nth_conv_i, //nth_conv or nth_fully

    input wire  [4:0]                   ofmap_size_i,
    input wire  [5:0]                   ifmap_ch_i,

    input   wire    [8:0]   in_node_num_i, //fully connected configure
    input   wire    [6:0]   out_node_num_i,

    //weight_bram write
    input   wire            wea,
    input   wire    [16:0]  addra,
    input   wire    [7:0]   dia,

    //fully connected buffer
    input wire                          wbuf_wren_i,
    input wire  [16:0]                  wbuf_wrptr_i,
    input wire  [7:0]                   wbuf_wdata_i,

    input wire                          ifmap_wren_i,
    input wire  [9:0]                   ifmap_wrptr_i,
    input wire  [7:0]                   ifmap_wdata_i,
    
    input wire                          sa_data_rden_i,
    input wire  [13:0]                  sa_data_rdptr_i,

    input wire                          fc_data_rden_i,
    input wire  [9:0]                   fc_data_rdptr_i,

    input wire                          pool_address_rden_i,
    input wire  [13:0]                  pool_address_rdptr_i,

    output wire [`DATA_WIDTH-1:0]       sa_data_rdata_o,
    output wire [`DATA_WIDTH-1:0]       fc_data_rdata_o,
    output wire [9:0]                   pool_address_rdata_o,

    output wire [15:0]                  pool_last_o,
    output wire                         act_last_o
);

    reg start_sa;
    reg start_fc;

    wire [31:0]  psum_sa [15:0];
    wire [31:0]  psum_fc [16];

    wire sa_valid [15:0];
    wire fc_valid [16];
    
    genvar i;
    generate
        for (i = 0; i<16; i++) begin
            assign psum_fc[i] = psum_sa[i];
            assign fc_valid[i] = sa_valid[i];
        end
    endgenerate


    always_comb begin
        if(start == 2'd1)
            start_sa = 1'b1;
        else
            start_sa = 1'b0;
    end

    always_comb begin
        if(start == 2'd2)
            start_fc = 1'b1;
        else
            start_fc = 1'b0;
    end

    SA_TOP u_sa_top (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_sa),
        .nth_conv_i(nth_conv_i),
        .ofmap_size_i(ofmap_size_i),
        .wea(wea),
        .addra({1'b0,addra}),
        .dia(dia),
        .accu_data_o(psum_sa),
        .accu_valid_o(sa_valid)
    );

    ACC_POOL u_acc_pool(
        .clk(clk),
        .rst_n(rst_n),
        .rst_pool_n(rst_pool_n),
        .psum_i(psum_fc),
        .pvalid_i(fc_valid),
        .ofmap_size_i(ofmap_size_i),
        .ifmap_ch_i(ifmap_ch_i),
        .start_fc_i(start_fc),
        .in_node_num_i(in_node_num_i),
        .out_node_num_i(out_node_num_i),
        .nth_fully_i(nth_conv_i),
        .wbuf_wren_i(wbuf_wren_i),
        .wbuf_wrptr_i(wbuf_wrptr_i),
        .wbuf_wdata_i(wbuf_wdata_i),
        .ifmap_wren_i(ifmap_wren_i),
        .ifmap_wrptr_i(ifmap_wrptr_i),
        .ifmap_wdata_i(ifmap_wdata_i),
        .sa_data_rden_i(sa_data_rden_i),
        .sa_data_rdptr_i(sa_data_rdptr_i),
        .fc_data_rden_i(fc_data_rden_i),
        .fc_data_rdptr_i(fc_data_rdptr_i),
        .pool_address_rden_i(pool_address_rden_i),
        .pool_address_rdptr_i(pool_address_rdptr_i),
        .sa_data_rdata_o(sa_data_rdata_o),
        .fc_data_rdata_o(fc_data_rdata_o),
        .pool_address_rdata_o(pool_address_rdata_o),
        .pool_last_o(pool_last_o),
        .act_last_o(act_last_o)
    );

endmodule