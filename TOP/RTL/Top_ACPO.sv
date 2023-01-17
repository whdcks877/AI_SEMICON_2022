//version 2022-01-13
//editor IM SUHYEOK

module Top_ACPO #(
    parameter       SRAM_DEPTH          = 1024,
    parameter       BAND_WIDTH          = 16,
    parameter       ACC_NUM             = 16,
    parameter       POOL_NUM            = 16,
    parameter       FA_NUM              = 1,
    parameter       ADDRESS_WIDTH       = 10,
    parameter       DATA_WIDTH          = 8
)
(
    input                       clk,
    input                       rst,
    
    input                       acc_last_i [ACC_NUM + FA_NUM], 
    input                       acc_valid_i [ACC_NUM + FA_NUM],
    input                       [DATA_WIDTH-1:0] acc_result_i [ACC_NUM + FA_NUM],
    input                       [ADDRESS_WIDTH-1:0] acc_result_address_i [ACC_NUM],

    input                       enb_d_sa,                                                     //data(sa) bram read enable
    input                       [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addrb_d_sa,       //data(sa) bram read address
 
    input                       enb_d_fc,                                                     //data(fc) bram read enable
    input                       [$clog2(SRAM_DEPTH)-1:0] addrb_d_fc,                          //data(fc) bram read address

    input                       enb_a,                                                         //address bram read enable
    input                       [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addrb_a,           //address bram read address

    output                      act_last_o,
    output                      pool_last_o [POOL_NUM],
    output                      [DATA_WIDTH-1:0] dob_d_sa,                                     //data(sa) bram output
    output                      [DATA_WIDTH-1:0] dob_d_fc,                                     //data(fc) bram output
    output                      [9:0] dob_a                                                    //address bram output
);

    wire                        act_last [ACC_NUM + FA_NUM];
    wire                        act_valid [ACC_NUM + FA_NUM];
    wire                        [DATA_WIDTH-1:0] act_result [ACC_NUM + FA_NUM];
    wire                        [ADDRESS_WIDTH-1:0] act_result_address [ACC_NUM];

    wire                        act_last_16 [ACC_NUM];
    wire                        act_valid_16 [ACC_NUM];
    wire                        [DATA_WIDTH-1:0] act_result_16 [ACC_NUM];

    wire                        act_valid_fc;
    wire                        [DATA_WIDTH-1:0] act_result_fc;

    wire                        pool_valid [POOL_NUM];
    wire                        [DATA_WIDTH-1:0] pool_result [POOL_NUM];
    wire                        [ADDRESS_WIDTH-1:0] pool_result_address [POOL_NUM];

    wire                        [$clog2(SRAM_DEPTH)-1:0] addra[BAND_WIDTH];
    wire                        [$clog2(SRAM_DEPTH)-1:0] addra_fc;
                 
    Activation_x17  u_AC(
        .clk(clk),
        .rst(rst),  
        .acc_last_i(acc_last_i), 
        .acc_valid_i(acc_valid_i),
        .acc_result_i(acc_result_i),
        .acc_result_address_i(acc_result_address_i),
        .act_last_o(act_last),
        .act_valid_o(act_valid),
        .act_result_o(act_result),
        .act_result_address_o(act_result_address) 
    );
    
    Pooling_x16 u_POOL(
        .clk(clk),                                  
        .rst(rst),                                  
        .act_last_i(act_last_16),                                
        .act_valid_i(act_valid_16),                               
        .act_result_i(act_result_16),                               
        .act_result_address_i(act_result_address),                               
        .pool_last_o(pool_last_o),                               
        .pool_valid_o(pool_valid),                               
        .pool_result_o(pool_result),                               
        .pool_result_address_o(pool_result_address)
    );

    Data_sa_buff u_data_sa_buff(
        .clk(clk),
        .wea(pool_valid),
        .enb(enb_d_sa),
        .addra(addra),    
        .addrb(addrb_d_sa),
        .dia(pool_result),  
        .dob(dob_d_sa) 
    );

    Data_fc_buff u_data_fc_buff(
        .clk(clk),
        .wea(act_valid_fc),
        .enb(enb_d_fc),
        .addra(addra_fc),    
        .addrb(addrb_d_fc),
        .dia(act_result_fc),  
        .dob(dob_d_fc) 
    );

    Address_buff u_address_buff(
        .clk(clk),
        .wea(pool_valid),
        .enb(enb_a),
        .addra(addra),  // address counter
        .addrb(addrb_a),
        .dia(pool_result_address),  
        .dob(dob_a)
    );

    bram_address_counter_x16 u_bram_address_x16(
        .clk(clk),
        .rst(rst),
        .enable(pool_valid),
        .address(addra)
    );

    bram_address_counter u_bram_address(
        .clk(clk),
        .rst(rst),
        .enable(act_valid_fc),
        .address(addra_fc)
    );



    assign act_last_16                  = act_last[0:15];  
    assign act_valid_16                 = act_valid[0:15];    
    assign act_result_16                = act_result[0:15];       

    assign act_last_o                    = act_last[16];                
    assign act_valid_fc                  = act_valid[16]; 
    assign act_result_fc                 = act_result[16];

endmodule
