// DMA
// 1 input read port, 1 output write port
// src(Data_sa_buffer) >> dst(BUFF_INPUT)

// Authors:
// - Sangmin Park
// v1.2
// Version Updated:
// - 20230120

module BRAM_DMA #
(
    parameter SRC_DEPTH=1024,
    parameter SRC_WIDTH=16,
    parameter DST_DEPTH=1176,
    parameter DST_WIDTH=25,
    parameter DATA_WIDTH=8,
    parameter CONV1_BURST=196,
    parameter CONV2_BURST=100
)
(
    input   wire  clk,
    input   wire  rst_n,
    
    input   wire  start,                                                     // last signal of Pooling
    input   wire  [1:0] nth_conv_i,

    //Request to SRC (DATA from SRC)
    output  wire  src_ena_o,
    output  wire  [$clog2(SRC_DEPTH)+$clog2(SRC_WIDTH)-1:0] addra_o,         // MSB[$clog2(SRAM_DEPTH)+4:$clog2(SRAM_DEPTH)]: selecting which block among 25 BRAMs
    input   reg   [DATA_WIDTH-1:0]  src_dia,

    //Copy to DST (DATA to DST)
    output  wire  dst_web_o,
    output  wire  [17:0] addrb_o,                              // LSB[$clog2(SRAM_DEPTH)-1:0]: selecting in one BRAM
    output  reg   [DATA_WIDTH-1:0]  dst_dob,

    output  wire  dma_done_o
    
);

    // wire        [$clog2(BAND_WIDTH)-1:0]   BLOCK_NUMa = addra[$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:$clog2(SRAM_DEPTH)];

    localparam  S_IDLE  = 'd0,
                S_DMA1  = 'd1,
                S_DMA2  = 'd2;

    reg                                     dma_done;
    reg                                     web;
    reg         [$clog2(DST_DEPTH)-1:0]     addrb;
    reg         [2:0]                       state,  state_n;
    reg         [$clog2(SRC_WIDTH)-1:0]     block_sel,  block_sel_n;
    reg         [$clog2(SRC_DEPTH)-1:0]     addra,      addra_n;
    reg                                     ena;

    reg         [$clog2(SRC_DEPTH)-1:0]     burst;
    reg         [$clog2(SRC_WIDTH)-1:0]     block_num;


   always_ff @(posedge clk) begin
        if(!rst_n) begin
            state               <= S_IDLE;
            block_sel           <= 'd0;
            addra               <= 'd0;
            ena                 <= 'b0;

        end else begin
            state               <= state_n;
            block_sel           <= block_sel_n;
            addra               <= addra_n;
            

            if(ena) begin
                web             <= 'b1;
                addrb           <= block_sel * burst + addra;                         // 18'b =  2b(sel INPUT) + 5b(sel row-not used) + 11b(sel column)
            end
            else begin
                web             <= 'b0;
                addrb           <= 'd0;
            end
        end
    end

    always_comb begin
        state_n             = state;
        block_sel_n         = block_sel;
        addra_n             = addra;
        burst               = $clog2(SRC_DEPTH);
        block_num           = $clog2(SRC_WIDTH);
        dma_done            = 1'b0;

        case(state)
            S_IDLE: begin
                dma_done                    = 1'b1;
                block_sel_n                 = 'd0;
                ena                         = 'b0;
                addra_n                     = 'd0;

                if(start) begin
                    if(nth_conv_i == 'd0) begin
                        state_n             = S_DMA1;
                        addra_n             = 'd0;
                    end
                    else if(nth_conv_i == 'd1) begin
                        state_n             = S_DMA2;
                        addra_n             = CONV1_BURST;
                    end
                    else begin
                        state_n             = S_IDLE;
                    end
                end
            end
            S_DMA1: begin
                burst                       = CONV1_BURST;
                block_num                   = 'd6;
                ena                         = 'd1;

                if(addra == burst - 1) begin
                    block_sel_n             = block_sel + 'd1;
                    addra_n                 = 'd0;
                end
                else begin
                    addra_n                 = addra + 'd1;
                end

                if(block_sel_n == block_num) begin
                    state_n                 = S_IDLE;
                end

            end
            S_DMA2: begin
                burst                       = CONV2_BURST;
                block_num                   = 'd16;
                ena                         = 'd1;

                if(addra == burst - 1) begin
                    block_sel_n             = block_sel + 'd1;
                    addra_n                 = CONV1_BURST;
                end
                else begin
                    addra_n                 = addra + 'd1;
                end

                if(block_sel_n == block_num) begin
                    state_n                 = S_IDLE;
                end
            end
        endcase
    end

    assign  addra_o     = {block_sel, addra};
    assign  src_ena_o   = ena;
    assign  addrb_o     = addrb;
    assign  dst_web_o   = web;
    assign  dst_dob     = src_dia;
    assign  dma_done_o  = dma_done;

endmodule