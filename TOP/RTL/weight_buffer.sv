//version 2022-01-19
//editor IM SUHYEOK
//edited SM PARK as of 20220120

module weight_buffer#(
    parameter       BAND_WIDTH      = 16,          
    parameter       DATA_WIDTH      = 8,
    parameter       ADDR_WIDTH      = 8      
)
(
    input   wire                clk,
    input   wire                rst_n,
    input   wire                burst_last_i,
    input   wire                [1:0] nth_conv_i,                       
    input   wire                weight_start_i,                          //SActrl-Weight_buffer interface
    input   wire                [DATA_WIDTH-1:0] w_data_i[BAND_WIDTH-1:0],   //BRAM-Weight_buffer interface
    input   wire                conv_done_i,
    input   wire                [3:0] cnt2,

    output  wire                [ADDR_WIDTH-1:0] w_addr_o[BAND_WIDTH-1:0],   //BRAM-Weight_buffer interface
    output  wire                w_enable_o[BAND_WIDTH-1:0],                  //BRAM-Weight_buffer interface
    output  wire                [DATA_WIDTH-1:0] w_data_o[BAND_WIDTH-1:0]    //Weight_buffer-SA interface
);


    localparam      S_IDLE          = 3'd0,
                    S_1th_Conv      = 3'd1,
                    S_2nd_Conv      = 3'd2,
                    S_2nd_Stop      = 3'd3,
                    S_2nd_WAIT      = 3'd4;



    reg                         [1:0] state, state_n;
    reg                         [4:0] cnt, cnt_n;
    reg                         [ADDR_WIDTH-1:0] w_addr[BAND_WIDTH-1:0];
    reg                         w_enable[BAND_WIDTH-1:0];
    reg                         [DATA_WIDTH-1:0] w_data[BAND_WIDTH-1:0];


    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= S_IDLE;
            cnt <= 'd0;
            for (int i=0; i<BAND_WIDTH; i++) begin
                w_data[i] <= 'd0;
            end
        end
        else begin
            state <= state_n;
            cnt <= cnt_n;
            w_data <= w_data_i;
        end
    end

    always_comb begin
        state_n = state;
        cnt_n   = cnt;
        case(state)
            S_IDLE: begin
                for (int i=0; i<BAND_WIDTH; i++) begin
                    w_enable[i] = 'd0;
                end
                if(weight_start_i) begin
                    state_n = (nth_conv_i == 2'b00) ? S_1th_Conv : S_2nd_Conv;
                    cnt_n = 'd0;
                end
            end

            S_1th_Conv: begin
                cnt_n = cnt + 'd1;
                if(cnt == 'd25) begin
                    state_n = S_IDLE;
                end
                else begin
                    w_addr[0] = {3'b000, cnt};
                    w_addr[1] = {3'b000, cnt};
                    w_addr[2] = {3'b000, cnt};
                    w_addr[3] = {3'b000, cnt};
                    w_addr[4] = {3'b000, cnt};
                    w_addr[5] = {3'b000, cnt};
                    w_enable[0] = 1'b1;
                    w_enable[1] = 1'b1;
                    w_enable[2] = 1'b1;
                    w_enable[3] = 1'b1;
                    w_enable[4] = 1'b1;
                    w_enable[5] = 1'b1;
                end

            end
            S_2nd_Conv: begin
                cnt_n = cnt + 'd1;
                if(cnt == 'd25) begin
                    state_n = S_IDLE;
                end
                else begin
                    for (int i=0; i<BAND_WIDTH; i++) begin
                        w_addr[i] <= cnt + ('d25 * cnt2);
                        w_enable[i] <= 1'b1;
                    end
                end
            end   
        endcase
    end

    assign w_addr_o             = w_addr;
    assign w_data_o             = w_data;
    assign w_enable_o           = w_enable;

endmodule