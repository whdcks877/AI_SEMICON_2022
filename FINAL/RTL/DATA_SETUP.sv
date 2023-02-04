// Systolic Array Data Setup Unit
// Authors:
// - Sangmin Park
// v2.2
// Version Updated:
// - 20220119

module DATA_SETUP #(
    // parameter       BURST_SIZE      = 1024,         // BURST_SIZE = 1024 (32x32 MATRIX)
    parameter       SRAM_DEPTH      = 1176,         // DEPTH of BRAM
    parameter       BAND_WIDTH      = 25,           // BAND_WIDTH=25 (5x5 Weight)
    parameter       DATA_WIDTH      = 8,             // 8bit Integer
    parameter       CH_NUM          = 6
)
(
    input   wire                clk,
    input   wire                rst,

    //IF with CFG
    input   wire        [1:0]               nth_conv_i,                 // conv1: 32*32*1=1024, conv2: 14*14*6=1176, conv3: 5*5*16=400
    input   wire        [4:0]               ofmap_size_i,               // conv1: 28, conv2: 10, conv3: 1]
    output  reg         [2:0]               cnt_ch,
     
    //IF with BRAM   25 bus
    input   wire        [DATA_WIDTH-1:0]    buff_data_i[BAND_WIDTH],
    output  wire                            setup_ready_o[BAND_WIDTH],      // BRAM rden
    output  wire        [$clog2(SRAM_DEPTH)-1:0] buff_addr_o[BAND_WIDTH],

    //IF with Systolic Array   25 bus
    input   wire                            weight_ready_i,             // when all weight set up on PEs
    output  wire                            data_valid_o[BAND_WIDTH],   // SETUP >> SA valid
    output  wire        [DATA_WIDTH-1:0]    sa_data_o[BAND_WIDTH],      // SETUP >> SA data
    output  wire                            burst_last_o,               // when BURST_SIZE + BANDWIDTH - 1 (1024+25-1 = 1048)th Data sending done
    output  wire                            conv_done_o
);

    reg                                 conv_done;

    reg             [5:0]               INPUT_SIZE;
    assign  INPUT_SIZE = ofmap_size_i + 'd4;

    reg             [16:0]              zero_mark;                      // 0~1023 BURST count, Maximum count 2^17
    reg             [7:0]               last_cnt;                       // 0~24 WEIGHT count at the very last outputs, Maximum count 2^7
    reg                                 dir;                            // Direction 0: Opening Data set from 0 to 24  >> Direction 1: Closing Data set from 0 to 24
    reg             [$clog2(SRAM_DEPTH)-1:0] buff_addr[BAND_WIDTH];

    reg                                 data_valid[BAND_WIDTH],   data_valid_n[BAND_WIDTH];
    reg                                 setup_ready[BAND_WIDTH];
    reg             [DATA_WIDTH-1:0]    sa_data[BAND_WIDTH];

    reg             [2:0]               cnt_5, cnt_ch;                  // 5 bit counter, 6 bit counter
    reg             [4:0]               addrh_offset;                   // horizontal, vertical offset max 28 counter
    reg             [10:0]              addrv_offset;


    wire            [10:0]              BURST_SIZE      = ofmap_size_i * ofmap_size_i;
    wire            [10:0]              ch_offset       = INPUT_SIZE * INPUT_SIZE * cnt_ch;
    // Buffer 8b x 1 x 25

    always_ff @(posedge clk)
    if (rst) begin
        zero_mark               <= 16'd0;
        dir                     <= 1'b0;
        last_cnt                <= 'd0;
        cnt_5                   <= 'd0;
        addrh_offset            <= 'd0;
        addrv_offset            <= 'd0;
        for (int i=0; i<BAND_WIDTH; i++) begin
            buff_addr[i]        <= 'd0;
            setup_ready[i]      <= 1'b0;
            sa_data[i]          <= 'd0;
            data_valid_n[i]     <= 1'b0;
        end
        cnt_ch                  <= 'd0;
    end
    else begin
        if(weight_ready_i) begin
            // Packing-Unpacking
            if(!dir) begin
                setup_ready[0]              <= 1'b1;
                buff_addr[0]                <= (addrv_offset) + (addrh_offset) + ch_offset;
            end
            else begin
                setup_ready[0]              <= 1'b0;
                last_cnt                    <= last_cnt + 'd1;
            end

        //  buff_addr[0]                    <= ;
            buff_addr[1]                    <= buff_addr[0] + 'd1;
            buff_addr[2]                    <= buff_addr[1] + 'd1;
            buff_addr[3]                    <= buff_addr[2] + 'd1;
            buff_addr[4]                    <= buff_addr[3] + 'd1;
            buff_addr[5]                    <= buff_addr[4] + ofmap_size_i;
            buff_addr[6]                    <= buff_addr[5] + 'd1;
            buff_addr[7]                    <= buff_addr[6] + 'd1;
            buff_addr[8]                    <= buff_addr[7] + 'd1;
            buff_addr[9]                    <= buff_addr[8] + 'd1;
            buff_addr[10]                   <= buff_addr[9] + ofmap_size_i;
            buff_addr[11]                   <= buff_addr[10] + 'd1;
            buff_addr[12]                   <= buff_addr[11] + 'd1;
            buff_addr[13]                   <= buff_addr[12] + 'd1;
            buff_addr[14]                   <= buff_addr[13] + 'd1;
            buff_addr[15]                   <= buff_addr[14] + ofmap_size_i;
            buff_addr[16]                   <= buff_addr[15] + 'd1;
            buff_addr[17]                   <= buff_addr[16] + 'd1;
            buff_addr[18]                   <= buff_addr[17] + 'd1;
            buff_addr[19]                   <= buff_addr[18] + 'd1;
            buff_addr[20]                   <= buff_addr[19] + ofmap_size_i;
            buff_addr[21]                   <= buff_addr[20] + 'd1;
            buff_addr[22]                   <= buff_addr[21] + 'd1;
            buff_addr[23]                   <= buff_addr[22] + 'd1;
            buff_addr[24]                   <= buff_addr[23] + 'd1;
            
            //count increment
            zero_mark                   <= zero_mark + 'd1;
            cnt_5                       <= cnt_5 + 'd1;
            addrh_offset                <= addrh_offset + 'd1;
        end

        //For Read Latency==1, valid_n stall 1clk
        for (int i=0; i<BAND_WIDTH; i++) begin
            if(setup_ready_o[i]) begin
                data_valid_n[i]             <= 1'b1;
            end
            else if(!setup_ready_o[i]) begin
                data_valid_n[i]             <= 1'b0;
            end

            if(data_valid_n[i]) begin
                sa_data[i]                  <= buff_data_i[i];
            end
            data_valid[i]                   <= data_valid_n[i];

            if(i<BAND_WIDTH-1) begin
                setup_ready[i+1]            <= setup_ready[i];
            end
        end

        //count RESET
        if(zero_mark == BURST_SIZE - 'd1) begin
            zero_mark           <= 16'd0;
            dir                 <= 1'b1;
        end
        if(cnt_5 == 'd4) begin
            cnt_5               <= 'd0;
        end
        if(addrh_offset == ofmap_size_i - 'd1) begin
            addrh_offset        <= 'd0;
            if(addrv_offset < (INPUT_SIZE * INPUT_SIZE)) begin
                addrv_offset        <= addrv_offset + INPUT_SIZE;
            end
            else begin
                addrv_offset        <= 'd0;    
            end
        end
        
        
        //after last RESET
        if(burst_last_o) begin
            zero_mark               <= 16'd0;
            dir                     <= 1'b0;
            last_cnt                <= 'd0;
            cnt_5                   <= 'd0;
            addrh_offset            <= 'd0;
            addrv_offset            <= 'd0;
            for (int i=0; i<BAND_WIDTH; i++) begin
                buff_addr[i]        <= 'd0;
                setup_ready[i]      <= 1'b0;
                sa_data[i]          <= 'd0;
                data_valid_n[i]     <= 1'b0;
            end

            if(nth_conv_i == 'd0) begin
                cnt_ch              <= 'd0;
            end
            else if(nth_conv_i == 'd1) begin
                if(cnt_ch < CH_NUM) begin
                    cnt_ch              <= cnt_ch + 'd1;
                end
                else begin
                    cnt_ch              <= 'd0;
                end
            end
            
        end
    end

    always_comb begin
        if(nth_conv_i == 'd0) begin
            conv_done                   = burst_last_o;
        end
        else if(nth_conv_i == 'd1) begin
            if(cnt_ch == CH_NUM - 'd1)begin
                conv_done               = burst_last_o;
            end
            else begin
                conv_done               = 'b0;
            end
        end
    end


    assign  buff_addr_o         = buff_addr;
    assign  burst_last_o        = last_cnt == (BAND_WIDTH + 'd1);
    assign  conv_done_o         = (nth_conv_i == 'd0) ? burst_last_o : (burst_last_o && (cnt_ch == CH_NUM - 'd1));
    assign  data_valid_o        = data_valid;
    assign  setup_ready_o       = setup_ready;
    assign  sa_data_o           = sa_data;


endmodule