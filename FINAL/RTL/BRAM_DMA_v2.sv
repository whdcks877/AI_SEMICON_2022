module BRAM_DMA_v2(
    input   wire  clk,
    input   wire  rst_n,
    
    input   wire  [1:0] start,                                                     // last signal of Pooling
    input   wire  [1:0] nth_conv_i,

    //src (a)
    output  reg  sa_data_rden_o,
    output  reg  [13:0]  sa_data_rdptr_o,
    input   wire [7:0]  sa_data_rdata_i,

    output  reg  fc_data_rden_o,
    output  reg  [9:0]  fc_data_rdptr_o,
    input   wire [7:0]  fc_data_rdata_i,

    //dst (b)
    output  reg     sa_wea_o,
    output  reg     [16:0] sa_addra_o,
    output  reg     [7:0]   sa_dia_o,

    output  reg     ifmap_wren_o,
    output  reg     [9:0] ifmap_wrptr_o,
    output  reg     [7:0] ifmap_wdata_o,

    output  reg     dma_done_o
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
    reg [10:0]    addrb,    addrb_n;
    reg [2:0]     state,  state_n;
    reg [4:0]     block_sel,  block_sel_n;

    reg [9:0]     addra, addra_n;

    reg [9:0]     burst;
    reg [4:0]     block_num;

    reg sa_data_rden;
    reg [13:0]  sa_data_rdptr;

    reg fc_data_rden;
    reg [9:0]  fc_data_rdptr;

    reg    sa_wea, sa_wea_on;
    reg    [16:0]   sa_addra, sa_addra_on;
    reg    [7:0]    sa_dia;

    reg    ifmap_wren, ifmap_wren_on;
    reg    [9:0] ifmap_wrptr, ifmap_wrptr_on;
    reg    [7:0] ifmap_wdata;

    reg state_t, state_tn;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state               <= S_IDLE;
            block_sel           <= 'd0;
            addra               <= 'hFFFFFFFF;
            state_t             <= 1'b0;

        end else begin
            state               <= state_n;
            block_sel           <= block_sel_n;
            addra               <= addra_n;
            addrb               <= addrb_n;
            state_t             <= state_tn;

            dma_done_o          <= dma_done;

            sa_data_rden_o      <= sa_data_rden;
            sa_data_rdptr_o     <= sa_data_rdptr;
            fc_data_rden_o      <= fc_data_rden;
            fc_data_rdptr_o     <= fc_data_rdptr;

            sa_wea_on           <= sa_wea;
            sa_addra_on         <= sa_addra;
            sa_wea_o            <= sa_wea_on;
            sa_addra_o          <= sa_addra_on;


            sa_dia_o            <= sa_dia;

            ifmap_wren_on       <= ifmap_wren;
            ifmap_wrptr_on      <= ifmap_wrptr;
            ifmap_wren_o        <= ifmap_wren_on;
            ifmap_wrptr_o       <= ifmap_wrptr_on;


            ifmap_wdata_o       <= ifmap_wdata;
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
                addra_n                     = 'd0;
                addrb_n                     = (block_sel[3:0] * burst) + addra;
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
                addrb_n                     = (block_sel[3:0] * burst) + addra;
                sa_data_rden = 'd1;
                sa_data_rdptr = {block_sel[3:0], addra[9:0]};
                sa_wea = sa_data_rden_o;
                sa_addra = {6'b0, addrb};
                sa_dia = sa_data_rdata_i;

                fc_data_rden = 'd0;
                fc_data_rdptr = 'd0;
                ifmap_wren = 'd0;
                ifmap_wrptr = 'd0;
                ifmap_wdata = 'd0;

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
                else begin
                    state_n                 = S_DMA1;
                end

            end
            S_DMA2: begin
                burst                       = CONV2_BURST;
                block_num                   = 'd16;
                addrb_n                     = (block_sel[3:0] * burst) + addra;
                sa_data_rden = 'd1;
                sa_data_rdptr = {block_sel[3:0], addra[9:0]};
                sa_wea = 'd0;
                sa_addra = 'd0;
                sa_dia = 'd0;

                fc_data_rden = 'd0;
                fc_data_rdptr = 'd0;
                ifmap_wren = sa_data_rden_o;
                ifmap_wrptr = addrb[9:0];
                ifmap_wdata = sa_data_rdata_i;

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
                else begin
                    state_n                 = S_DMA2;
                end
            end
            S_DMA3: begin
                burst                       = 'd120;
                block_num                   = 'd1;
                addrb_n                     = (block_sel[3:0] * burst) + addra;
                sa_data_rden = 'd0;
                sa_data_rdptr = 'd0;
                sa_wea = 'd0;
                sa_addra = 'd0;
                sa_dia = 'd0;

                fc_data_rden = 'd1;
                fc_data_rdptr = addra[9:0];
                ifmap_wren = fc_data_rden_o;
                ifmap_wrptr = addrb[9:0];
                ifmap_wdata = fc_data_rdata_i;

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
                else begin
                    state_n                 = S_DMA3;
                end                   

            end
            S_DMA4: begin
                burst                       = 'd84;
                block_num                   = 'd1;
                addrb_n                     = (block_sel[3:0] * burst) + addra;
                sa_data_rden = 'd0;
                sa_data_rdptr = 'd0;
                sa_wea = 'd0;
                sa_addra = 'd0;
                sa_dia = 'd0;

                fc_data_rden = 'd1;
                fc_data_rdptr = addra[9:0];
                ifmap_wren = fc_data_rden_o;
                ifmap_wrptr = addrb[9:0];
                ifmap_wdata = fc_data_rdata_i;

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
                else begin
                    state_n                 = S_DMA4;
                end
            end
        endcase
    end

endmodule