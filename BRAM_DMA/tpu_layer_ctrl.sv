module tpu_layer_ctrl(
    input wire clk,
    input wire rst_n,

    
    input wire start_i,
    //dma
    output wire  start_dma_o,
    output wire [1:0] nth_conv_o,
    input  wire dma_done_i,

    //layer info
    output wire  [4:0]                   ofmap_size_o,
    output wire  [5:0]                   ifmap_ch_o,

    output   wire    [8:0]   in_node_num_o, //fully connected configure
    output   wire    [6:0]   out_node_num_o,

    //tpu core
    input wire [16:0] done, // 17: fc_last, 16~0 : pool_last 
    output wire [1:0] start_core_o, // 1: conv, 2:fc

    //axi
    output wire cnn_done_o
);
    reg start_dma;
    reg [1:0] start_core;
    reg [1:0] nth_conv;
    reg  [4:0] ofmap_size;
    reg  [5:0]  ifmap_ch;

    reg  [8:0]   in_node_num; 
    reg  [6:0]   out_node_num;

    reg [3:0] state, state_n;

    reg [16:0] done_d;
    reg     dma_done;

    reg cnn_done;

    reg start_d1, start_d1_n, start_d2, start_d2_n, start_d3, start_d3_n ;

    localparam     S_IDLE = 'd0,
                    S_CONV1 = 'd1,
                    S_DMA1  = 'd2,
                    S_CONV2 ='d3,
                    S_DMA2  = 'd4,
                    S_CONV3 = 'd5,
                    S_DMA3 = 'd6,
                    S_FC1 = 'd7,
                    S_DMA4 ='d8,
                    S_FC2 = 'd9,
                    S_DONE ='d10;
    // S_IDLE
    // S_CONV1 //nth_conv = 0 start = 1; ofmap_size=28 ifmap_ch=1
    // S_DMA1  //start dma = 1
    // S_CONV2 // nth_conv = 1 start = 1; ofmap_size=10 ifmap_ch=6
    // S_DMA2 // start dma = 1
    // S_CONV3 //nth_conv = 0  start = 2; in_node_num = 400 outnode = 120
    // S_DMA3 // start dma = 1
    // S_FC1 //nth_conv = 1  start = 2; in_node_num = 120 outnode = 84
    // S_DMA4 // start dma = 2
    // S_FC2 //nth_conv = 2  start = 2; in_node_num = 84 outnode =10
    // S_DONE // done

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state <= 'b0;
            start_d1 <= 'b0;
            start_d2 <= 'b0;
            start_d3 <= 'b0;
            done_d <= 'b0;
            dma_done <= 'b0;
        end else begin
            state <= state_n;
            start_d1 <= start_d1_n;
            start_d2 <= start_d2_n;
            start_d3 <= start_d3_n;
            done_d <= done;
            dma_done <= dma_done_i;
        end
    end

    always_comb begin
        start_dma = 0;
        ofmap_size = 0;
        ifmap_ch = 0;
        in_node_num = 0;
        out_node_num = 0;
        start_core = 0;
        cnn_done = 0;

        start_d1_n = start_d1;
        start_d2_n = start_d1;
        start_d3_n = start_d2;
        state_n = state;

        case(state)
            S_IDLE: begin
                if(start_i) begin
                    state_n = S_CONV1;
                end
            end
            S_CONV1: begin  
                start_core = 1;
                nth_conv = 0;
                ofmap_size = 28;
                ifmap_ch = 1;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_core = 0;
                end 

                if(done_d[5]) begin
                    state_n = S_DMA1;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;

                end else begin
                    state_n = S_CONV1;
                end
            end
            S_DMA1: begin
                start_dma = 1;
                nth_conv = 0;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_dma = 0;
                end 

                if(dma_done) begin
                    state_n = S_CONV2;
                    
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_DMA1;
                end
            end
            S_CONV2: begin
                start_core = 1;
                nth_conv = 1;
                ofmap_size = 10;
                ifmap_ch = 6;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_core = 0;
                end 

                if(done_d[15]) begin
                    state_n = S_DMA2;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_CONV2;
                end
            end
            S_DMA2: begin
                start_dma = 1;
                nth_conv = 1;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_dma = 0;
                end 

                if(dma_done) begin
                    state_n = S_CONV3;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_DMA2;
                end
            end
            S_CONV3: begin
                start_core = 2;
                nth_conv = 0;

                in_node_num = 400;
                out_node_num = 120;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_core = 0;
                end 

                if(done_d[16]) begin
                    state_n = S_DMA3;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_CONV3;
                end
            end
            S_DMA3: begin
                start_dma = 2;
                nth_conv = 0;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_dma = 0;
                end 

                if(dma_done) begin
                    state_n = S_FC1;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_DMA3;
                end
            end
            S_FC1: begin
                start_core = 2;
                nth_conv = 1;

                in_node_num = 120;
                out_node_num = 84;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_core = 0;
                end 

                if(done_d[16]) begin
                    state_n = S_DMA4;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_FC1;
                end
            end
            S_DMA4: begin
                start_dma = 2;
                nth_conv = 1;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_dma = 0;
                end 

                if(dma_done) begin
                    state_n = S_FC2;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_DMA4;
                end
            end
            S_FC2: begin
                start_core = 2;
                nth_conv = 2;

                in_node_num = 84;
                out_node_num = 10;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_core = 0;
                end 

                if(done_d[16]) begin
                    state_n = S_DONE;
                    start_d1_n = 0;
                    start_d2_n = 0;
                    start_d3_n = 0;
                end else begin
                    state_n = S_FC2;
                end
            end
            S_DONE: begin
                cnn_done = 1;

                start_d1_n = 1'b1;
                if(start_d3) begin
                    start_d1_n = 1'b0;
                    state_n = S_IDLE;
                end 
            end
        endcase
    end

    assign start_dma_o = start_dma;
    assign nth_conv_o = nth_conv;
    assign ofmap_size_o = ofmap_size;
    assign ifmap_ch_o = ifmap_ch;
    assign in_node_num_o = in_node_num;
    assign out_node_num_o = out_node_num;
    assign start_core_o = start_core;
    assign cnn_done_o = cnn_done;

endmodule