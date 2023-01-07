// Systolic Array Data Setup Unit
// Authors:
// - Sangmin Park
// v1.4
// Version Updated:
// - 20220108

module DATA_SETUP #(
    // parameter       BURST_SIZE      = 1024,         // BURST_SIZE = 1024 (32x32 MATRIX)
    parameter       BAND_WIDTH      = 25,           // BAND_WIDTH=25 (5x5 Weight)
    parameter       DATA_WIDTH      = 8             // 8bit Integer
    )
(
    input   wire                clk,
    input   wire                rst,

    //IF with CFG
    input   wire        [10:0]              BURST_SIZE,                 // 1024 = 32*32
     
    //IF with BRAM   25 bus?
    input   wire        [DATA_WIDTH-1:0]    buff_data_i[BAND_WIDTH],
    output  wire                            setup_ready_o[BAND_WIDTH],      // BRAM rden
    output  wire        [9:0]               buff_addr_o[BAND_WIDTH],

    //IF with Systolic Array   25 bus?
    input   wire                            weight_ready_i,     // when all weight set up on PEs
    output  wire                            data_valid_o[BAND_WIDTH],   // SETUP >> SA valid
    output  wire        [DATA_WIDTH-1:0]    sa_data_o[BAND_WIDTH],      // SETUP >> SA data
    output  wire                            burst_last_o                // when BURST_SIZE + BANDWIDTH - 1 (1024+25-1 = 1048)th Data sending done
  
);
    //Number of Basic Input

    reg             [16:0]              zero_mark;                      // 0~1023 BURST count, Maximum count 2^17
    reg             [7:0]               last_cnt;                       // 0~24 WEIGHT count at the very last outputs, Maximum count 2^7
    reg                                 dir;                            // Direction 0: Opening Data set from 0 to 24  >> Direction 1: Closing Data set from 0 to 24
    reg             [9:0]               buff_addr[BAND_WIDTH];

    reg                                 data_valid[BAND_WIDTH],   data_valid_n[BAND_WIDTH];
    reg                                 setup_ready[BAND_WIDTH];
    reg            [DATA_WIDTH-1:0]     sa_data[BAND_WIDTH];


    // Buffer 8b x 1 x 25

    always_ff @(posedge clk)
    if (rst) begin
        zero_mark               <= 16'd0;
        dir                     <= 1'b0;
        last_cnt                <= 'd0;
        for (int i=0; i<BAND_WIDTH; i++) begin
            buff_addr[i]        <= 10'b1111111111;
            setup_ready[i]      <= 1'b0;
            sa_data[i]          <= 'd0;
            data_valid_n[i]     <= 1'b0;
        end
    end
    else begin
        if(weight_ready_i) begin
            for (int i=0; i<BAND_WIDTH; i++) begin
                if(!dir) begin
                    if((i < zero_mark)) begin
                        setup_ready[i]          <= weight_ready_i;
                        buff_addr[i]            <= buff_addr[i] + 1;
                    end
                    else begin
                        setup_ready[i]          <= 1'b0;
                    end
                end
                else begin
                    if((i < zero_mark)) begin
                        setup_ready[i]          <= 1'b0;
                        last_cnt                <= last_cnt + 'd1;      // Count when Closing Data set, BAND_WIDTH th cnt = done
                    end
                    else begin
                        setup_ready[i]          <= weight_ready_i;
                        buff_addr[i]            <= buff_addr[i] + 1;
                    end
                end
            end

            for (int i=0; i<BAND_WIDTH; i++) begin
                sa_data[i]                      <= buff_data_i[i];
                if(setup_ready_o[i]) begin
                    data_valid_n[i]             <= 1'b1;
                end
                else if(!setup_ready_o[i]) begin
                    data_valid_n[i]             <= 1'b0;
                end
            end
            zero_mark                   <= zero_mark + 'd1;
        end

        if(zero_mark == BURST_SIZE - 1) begin
            zero_mark           <= 16'd0;
            dir                 <= 1'b1;
        end
        
        data_valid              <= data_valid_n;

        if(burst_last_o) begin
            zero_mark               <= 16'd0;
            dir                     <= 1'b0;
            last_cnt                <= 'd0;
            for (int i=0; i<BAND_WIDTH; i++) begin
                buff_addr[i]        <= 10'b1111111111;
                setup_ready[i]      <= 1'b0;
                sa_data[i]          <= 'd0;
                data_valid_n[i]     <= 1'b0;
            end
        end
    end

    assign  buff_addr_o         = buff_addr;
    assign  burst_last_o        = last_cnt == BAND_WIDTH + 'd1;
    assign  data_valid_o        = data_valid;
    assign  setup_ready_o       = setup_ready;
    assign  sa_data_o           = sa_data;


endmodule