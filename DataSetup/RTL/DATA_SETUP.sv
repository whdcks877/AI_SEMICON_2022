module DATA_SETUP #(
    parameter       BURST_SIZE      = 1024,         // BURST_SIZE = 1024 (32x32 MATRIX)
    parameter       BAND_WIDTH      = 25,
    parameter       DATA_WIDTH      = 8
    )
(
    input   wire                clk,
    input   wire                rst,
     
    //IF with BRAM   25 bus?
    input   wire                            buff_valid_i[BAND_WIDTH],       // BRAM
    input   wire        [DATA_WIDTH-1:0]    buff_data_i[BAND_WIDTH],
    output  wire                            setup_ready_o[BAND_WIDTH],

    //IF with Systolic Array   25 bus?
    input   wire                            weight_ready_i,     // when all weight set up on PEs
    output  wire                            data_valid_o[BAND_WIDTH],   // SETUP >> SA valid
    output  wire        [DATA_WIDTH-1:0]    sa_data_o[BAND_WIDTH],      // SETUP >> SA data
    output  wire                            burst_last_o                // when BURST_SIZE + BANDWIDTH - 1 (1024+25-1 = 1048)th Data sending done
  
);
    //Number of Basic Input
    parameter               SIZE_INPUT  = 32;           // SIZE_INPUT=32 (32x32 Input)
    parameter               SIZE_WEIGHT = BAND_WIDTH;   // SIZE_WEIGHT=25 (5x5 Weight)

    reg             [16:0]              zero_mark;                      // 0~1023 BURST count
    reg             [7:0]               last_cnt;                       // 0~24 WEIGHT count at the very last outputs
    reg                                 dir;                            // Direction 0: Filling 1s from 0 to 24  >> Direction 1: Filling 0s from 0 to 24

    reg                                 data_valid[BAND_WIDTH];
    reg                                 setup_ready[BAND_WIDTH];
    reg            [DATA_WIDTH-1:0]     sa_data[BAND_WIDTH];
    reg                                 burst_last;


    // Buffer 8b x 1 x 25

    always_ff @(posedge clk)
    if (rst || burst_last_o) begin
        zero_mark               <= 16'd0;
        dir                     <= 1'b0;
        last_cnt                <= 'd0;
        for (int i=0; i<SIZE_WEIGHT; i++) begin
            sa_data[i]          <= 'd0;
            data_valid[i]       <= 1'b0;
        end
    end
    else begin
        if(weight_ready_i) begin
            for (int i=0; i<SIZE_WEIGHT; i++) begin
                if(buff_valid_i[i] && setup_ready_o[i]) begin
                    sa_data[i]              <= buff_data_i[i];
                    data_valid[i]           <= 1'b1;
                end
                else if(!setup_ready_o[i]) begin
                    sa_data[i]              <= 'd0;
                    data_valid[i]           <= 1'b0;
                end
            end
            zero_mark                   <= zero_mark + 'd1;
        end

        if(zero_mark == BURST_SIZE - 1) begin
            zero_mark           <= 16'd0;
            dir                 <= 1'b1;
        end
        
        if(dir) begin
            last_cnt            <= last_cnt + 'd1;
        end
    end

    always_comb begin
        if(rst) begin
            for(int i=0; i<SIZE_WEIGHT; i++) begin
                setup_ready[i]              = 1'b0;
            end
            burst_last                      = 1'b0;
        end
        else begin
            for (int i=0; i<SIZE_WEIGHT; i++) begin
                if((i < zero_mark + 'd1) && !dir)begin
                    setup_ready[i]          = weight_ready_i;
                end
                else if((i < zero_mark + 'd1) && dir) begin
                    setup_ready[i]          = 1'b0;
                end
            end

            if(last_cnt == 'd24) begin
                burst_last                  = 1'b1;
            end
            else begin
                burst_last                  = 1'b0;
            end
        end
    end

    assign  burst_last_o        = burst_last;
    assign  data_valid_o        = data_valid;
    assign  setup_ready_o       = setup_ready;
    assign  sa_data_o           = sa_data;


endmodule