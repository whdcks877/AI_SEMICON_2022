module TOP(
    input   wire            clk,
    input   wire            rst_n,
    
    //config
    input   wire    [1:0]   start,  //0: wait, 1: sa start, 2: fc start
    input   wire    [1:0]   nth_conv_i,

    input wire  [4:0]                   ofmap_size_i,
    input wire  [5:0]                   ifmap_ch_i,

    input   wire    [6:0]   in_node_num_i, //fully connected configure
    input   wire    [6:0]   out_node_num_i,


    //weight_bram write
    input   wire            wea,
    input   wire    [16:0]  addra,
    input   wire    [7:0]   dia,


    input wire                          wbuf_wren_i,
    input wire  [6:0]                   wbuf_wrptr_i [`FC_SIZE],
    input wire  [7:0]                   wbuf_wdata_i [`FC_SIZE],

    input wire                          ifmap_wren_i,
    input wire  [6:0]                   ifmap_wrptr_i,
    input wire  [7:0]                   ifmap_wdata_i,
    
    //Fully connected output
    output wire                         fc_last_o,
    output wire                         fc_valid_o,
    output wire [`DATA_WIDTH-1:0]        fc_result_o,

    //pooling 
    output wire                         pool_last_o [`POOL_NUM],
    output wire                         pool_valid_o [`POOL_NUM],
    output wire [`DATA_WIDTH-1:0]        pool_result_o [`POOL_NUM],
    output wire [`ADDRESS_WIDTH-1:0]     pool_result_address_o [`POOL_NUM]


);

    reg start_sa;
    reg start_fc;

    wire [7:0]  psum_sa [15:0];
    wire        psum_fc = {psum_sa[0], psum_sa[1], psum_sa[2], psum_sa[3], psum_sa[4], psum_sa[5], psum_sa[6], psum_sa[7], psum_sa[8], 
                        psum_sa[9], psum_sa[10], psum_sa[11], psum_sa[12], psum_sa[13], psum_sa[14], psum_sa[15]};

    wire sa_valid [15:0];
    wire fc_valid = {sa_valid[0], sa_valid[1], sa_valid[2], sa_valid[3], sa_valid[4], sa_valid[5], sa_valid[6], sa_valid[7], sa_valid[8], 
                    sa_valid[9], sa_valid[10], sa_valid[11], sa_valid[12], sa_valid[13], sa_valid[14], sa_valid[15]};

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
        .wea(wea),
        .addra(addra),
        .dia(dia),
        .accu_data_o(psum_sa),
        .accu_valid(sa_valid)
    );

    ACC_POOL u_acc_pool(
        .clk(clk),
        .rst_n(rst_n),
        .psum_i(psum_fc),
        .pvalid_i(fc_valid),
        .ofmap_size_i(ofmap_size_i),
        .ifmap_ch_i(ifmap_ch_i),
        .start_fc_i(start_fc),
        .in_node_num_i(in_node_num_i),
        .out_node_num_i(out_node_num_i),
        .wbuf_wren_i(wbuf_wren_i),
        .wbuf_wrptr_i(wbuf_wrptr_i),
        .wbuf_wdata_i(wbuf_wdata_i),
        .ifmap_wren_i(ifmap_wren_i),
        .ifmap_wrptr_i(ifmap_wrptr_i),
        .ifmap_wdata_i(ifmap_wdata_i),
        .fc_last_o(fc_last_o),
        .fc_valid_o(fc_valid_o),
        .fc_result_o(fc_result_o),
        .pool_last_o(pool_last_o),
        .pool_valid_o(pool_valid_o),
        .pool_result_o(pool_result_o),
        .pool_result_address_o(pool_result_address_o)
    );

endmodule