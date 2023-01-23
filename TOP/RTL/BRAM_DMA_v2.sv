module BRAM_DMA_v2(
    input   wire  clk,
    input   wire  rst_n,
    
    input   wire  [1:0] start,                                                     // last signal of Pooling
    input   wire  [1:0] nth_conv_i,

    //src (a)
    output  wire sa_data_rden_o,
    output  wire [13:0]  sa_data_rdptr_o,
    input   wire [7:0]  sa_data_rdata_i,

    output  wire fc_data_rden_o,
    output  wire [9:0]  fc_data_rdptr_o,
    input   wire [7:0]  fc_data_rdata_i,

    //dst (b)
    output  wire    sa_wea_o,
    output  wire    [16:0] sa_addra_o,
    output  wire    [7:0]   sa_dia_o,

    output  wire    ifmap_wren_o,
    output  wire    [9:0] ifmap_wrptr_o,
    output  wire    [7:0] ifmap_wdata_o,

    output  wire  dma_done_o
);

    localparam  S_IDLE  = 'd0,
                S_DMA1  = 'd1,
                S_DMA2  = 'd2,
                S_DMA3  = 'd3,
                S_DMA4  = 'd4,
                S_WRITE = 'd5;

    localparam SRC_DEPTH=1024;
    localparam SRC_WIDTH=16;
    localparam DST_DEPTH=1176;
    localparam DST_WIDTH=25;
    localparam DATA_WIDTH=8;
    localparam CONV1_BURST=196;
    localparam CONV2_BURST=25;

    reg           dma_done;
    reg           web;
    reg [10:0]    addrb;
    reg [2:0]     state,  state_n;
    reg [4:0]     block_sel,  block_sel_n;

    reg [9:0]     addra, addra_n;
    reg           ena;

    reg [9:0]     burst;
    reg [4:0]     block_num;

    reg sa_data_rden;
    reg [13:0]  sa_data_rdptr;

    reg fc_data_rden;
    reg [9:0]  fc_data_rdptr;

    reg    sa_wea;
    reg    [16:0] sa_addra;
    reg    [7:0]   sa_dia;

    reg    ifmap_wren;
    reg    [9:0] ifmap_wrptr;
    reg    [7:0] ifmap_wdata;

    reg state_t, state_tn;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state               <= S_IDLE;
            block_sel           <= 'd0;
            addra               <= 'd0;
            ena                 <= 'b0;
            state_t             <= 1'b0;

        end else begin
            state               <= state_n;
            block_sel           <= block_sel_n;
            addra               <= addra_n;
            state_t             <= state_tn;
            
            if(ena) begin
                web             <= 'b1;
                addrb           <= (block_sel[3:0] * burst) + addra;                         // 18'b =  2b(sel INPUT) + 5b(sel row-not used) + 11b(sel column)
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
        burst               = 'd0;
        block_num           = 'd0;
        dma_done            = 1'b0;
        state_tn            = 1'b0;

        case(state)
            S_IDLE: begin
                dma_done                    = 1'b1;
                block_sel_n                 = 'd0;
                ena                         = 'b0;
                addra_n                     = 'd0;

                if(start != 0) begin
                    addra_n             = 'd0;
                    if(nth_conv_i == 'd0 && start == 1) begin
                        state_n             = S_DMA1;
                    end
                    else if(nth_conv_i == 'd1 && start == 1) begin
                        state_n             = S_DMA2;
                    end
                    else if(nth_conv_i == 'd0 && start == 2) begin
                        state_n             = S_DMA3;
                    end
                    else if(nth_conv_i == 'd1 && start == 2) begin
                        state_n             = S_DMA4;
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

                if(block_sel == block_num) begin
                    state_n                 = S_IDLE;
                end

            end
            S_DMA2: begin
                burst                       = CONV2_BURST;
                block_num                   = 'd16;
                ena                         = 'd1;

                if(addra == burst - 1) begin
                    block_sel_n             = block_sel + 'd1;
                    addra_n                 = 'd0;
                end
                else begin
                    addra_n                 = addra + 'd1;
                end

                if(block_sel == block_num) begin
                    state_n                 = S_IDLE;
                end
            end
            S_DMA3: begin
                burst                       = 'd120;
                block_num                   = 'd1;
                ena                         = 'd1;

                if(addra == burst - 1) begin
                    addra_n                 = 'd0;
                    state_tn                 = 1'b1;
                end
                else begin
                    addra_n                 = addra + 'd1;
                end
                if(state_t) begin
                    state_n                 = S_IDLE;
                end
            end
            S_DMA4: begin
                burst                       = 'd84;
                block_num                   = 'd1;
                ena                         = 'd1;

                if(addra == burst - 1) begin
                    addra_n                 = 'd0;
                    state_tn                 = 1'b1;
                end
                else begin
                    addra_n                 = addra + 'd1;
                end
                if(state_t) begin
                    state_n                 = S_IDLE;
                end
            end
        endcase
    end

    always_comb begin
        case(state)
            S_DMA1: begin
                sa_data_rden = ena;
                sa_data_rdptr = {block_sel[3:0], addra[9:0]};
                fc_data_rden = 'd0;
                fc_data_rdptr = 'd0;
                sa_wea = web;
                sa_addra = {6'b0, addrb};
                sa_dia = sa_data_rdata_i;
                ifmap_wren = 'd0;
                ifmap_wrptr = 'd0;
                ifmap_wdata = 'd0;
            end
            S_DMA2: begin
                sa_data_rden = ena;
                sa_data_rdptr = {block_sel[3:0], addra[9:0]};
                fc_data_rden = 'd0;
                fc_data_rdptr = 'd0;
                sa_wea = 'd0;
                sa_addra = 'd0;
                sa_dia = 'd0;
                ifmap_wren = web;
                ifmap_wrptr = addrb[9:0];
                ifmap_wdata = sa_data_rdata_i;
            end
            S_DMA3: begin
                sa_data_rden = 'd0;
                sa_data_rdptr = 'd0;
                fc_data_rden = ena;
                fc_data_rdptr = addra[9:0];
                sa_wea = 'd0;
                sa_addra = 'd0;
                sa_dia = 'd0;
                ifmap_wren = web;
                ifmap_wrptr = addrb[9:0];
                ifmap_wdata = fc_data_rdata_i;
            end
            S_DMA4: begin
                sa_data_rden = 'd0;
                sa_data_rdptr = 'd0;
                fc_data_rden = ena;
                fc_data_rdptr = addra[9:0];
                sa_wea = 'd0;
                sa_addra = 'd0;
                sa_dia = 'd0;
                ifmap_wren = web;
                ifmap_wrptr = addrb[9:0];
                ifmap_wdata = fc_data_rdata_i;
            end
            default: begin
                sa_data_rden = 'd0;
                sa_data_rdptr = 'd0;
                fc_data_rden = 'd0;
                fc_data_rdptr = 'd0;
                sa_wea = 'd0;
                sa_addra = 'd0;
                sa_dia = 'd0;
                ifmap_wren = 'd0;
                ifmap_wrptr = 'd0;
                ifmap_wdata = 'd0;
            end
        endcase
    end

    assign sa_data_rden_o = sa_data_rden;
    assign sa_data_rdptr_o = sa_data_rdptr;
    assign fc_data_rden_o = fc_data_rden;
    assign fc_data_rdptr_o = fc_data_rdptr;
    assign sa_wea_o = sa_wea;
    assign sa_addra_o = sa_addra;
    assign sa_dia_o = sa_dia;
    assign ifmap_wren_o = ifmap_wren;
    assign ifmap_wrptr_o = ifmap_wrptr;
    assign ifmap_wdata_o = ifmap_wdata;
    assign  dma_done_o  = dma_done;

endmodule