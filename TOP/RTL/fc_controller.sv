
module fc_controller(
    input wire          clk,
    input wire          rst_n,

    input wire          start_i, //input after buffers are filled, FC operate start
    input wire [8:0]    in_node_num_i, //number of input node, 1~512
    input wire [6:0]    out_node_num_i, //number of output node, 1~84
    input wire [1:0]    nth_fully_i,

    //interface with ifmap buffer
    output wire         ifmap_rden_o,
    output wire [9:0]   ifmap_rdptr_o,

    //interface with weight buffer
    output wire         wbuf_rden_o,
    output wire [9:0]   wbuf_rdptr_o,
    output wire         rst_buf_n_o,

    //interface with pe array
    output wire         pe_load_o,

    //interface with activation
    output wire         valid_o,
    output wire         last_o
);

    localparam  S_IDLE      = 0,
                S_IF_LOAD   = 1,
                S_FC_OP     = 2;

    localparam  FC_WBUF_OFFSET_1ST = 0,
                FC_WBUF_OFFSET_2ND = 480,
                FC_WBUF_OFFSET_3RD = 564,
                FC_IBUF_OFFSET_1ST = 0,
                FC_IBUF_OFFSET_2ND = 400,
                FC_IBUF_OFFSET_3RD = 520;

    reg [2:0]   state, state_n;
    reg [8:0]   cnt, cnt_n;

    reg         ifmap_rden, ifmap_rden_n;
    reg [9:0]   ifmap_rdptr, ifmap_rdptr_n;

    reg         wbuf_rden, wbuf_rden_n;
    reg [9:0]   wbuf_rdptr, wbuf_rdptr_n;
    reg         rst_buf_n, rst_buf_n_n;

    reg         valid, valid_n;
    reg         last, last_n;

    reg         over120;
    reg [9:0]   input_offset, weight_offset;
    reg [9:0]   tile_offset, tile_offset_n;
    reg [9:0]   tile_cnt, tile_cnt_n;
    reg [6:0]   in_node_num, in_node_num_n;
    reg [6:0]   out_node_num, out_node_num_n;

    reg pe_load;


    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state           <= S_IDLE;
            cnt             <= 8'b0;
            ifmap_rden      <= 1'b0;
            ifmap_rdptr     <= 7'b0;
            wbuf_rden       <= 1'b0;
            wbuf_rdptr      <= 7'b0;
            rst_buf_n       <= 1'b1;
            valid           <= 1'b0;
            last            <= 1'b0;
            out_node_num    <= 7'b0;
            tile_cnt        <= 10'b0;
            tile_offset     <= 10'b0;
        end else begin
            state           <= state_n;
            cnt             <= cnt_n;
            ifmap_rden      <= ifmap_rden_n;
            ifmap_rdptr     <= ifmap_rdptr_n;
            wbuf_rden       <= wbuf_rden_n;
            wbuf_rdptr      <= wbuf_rdptr_n;
            rst_buf_n       <= rst_buf_n_n;
            valid           <= valid_n;
            last            <= last_n;
            out_node_num    <= out_node_num_n;
            tile_cnt        <= tile_cnt_n;
            tile_offset <= tile_offset_n;
        end
    end

    always_comb begin
            state_n         = state;
            cnt_n           = cnt;
            ifmap_rden_n    = 1'b0;
            ifmap_rdptr_n   = ifmap_rdptr;
            wbuf_rden_n     = 1'b0;
            wbuf_rdptr_n    = wbuf_rdptr;
            rst_buf_n_n     = 1'b1;
            valid_n         = 1'b0;
            last_n          = 1'b0;
            out_node_num_n  = out_node_num;
            pe_load         = 1'b0;
            tile_cnt_n = tile_cnt;
            tile_offset_n = tile_offset;

        case(state)
            S_IDLE: begin
                if(start_i == 1'b1) begin
                    state_n = S_IF_LOAD;
                    
                    //capture FC layer information
                    ifmap_rdptr_n = input_offset;
                    tile_cnt_n = in_node_num_i;
                    out_node_num_n = out_node_num_i;

                    ifmap_rden_n = 1'b1; //start reading ifmap buffer
                end
            end
            S_IF_LOAD: begin
                ifmap_rden_n = 1'b1;

                if(cnt == in_node_num-1) begin
                    state_n = S_FC_OP;

                    ifmap_rden_n = 1'b0; //stop reading ifmap buffer
                    wbuf_rdptr_n = weight_offset + tile_offset;
                    wbuf_rden_n = 1'b1; //start reading weight buffer
                    cnt_n = 8'b0; //reset cnt
                end else begin
                    cnt_n = cnt + 1;
                    ifmap_rdptr_n = cnt_n[6:0] + input_offset + tile_offset;
                end
            end
            S_FC_OP: begin
                wbuf_rden_n = 1'b1;

                //start output output node
                if(cnt >= 120) begin
                    valid_n = 1'b1;
                end

                 //make output 0's after valid weight data
                if(cnt >= out_node_num-1) begin
                    rst_buf_n_n = 1'b0;
                end

                //make last signal for last output node
                if(cnt == (119 + {3'b0,out_node_num})) begin
                    last_n = 1'b1;
                end

                //normal operation (read weight buffer with incremental read pointer)
                if(last == 1'b1) begin
                    if(!over120) begin
                        state_n = S_IDLE;
                    end else begin
                        state_n = S_IF_LOAD;
                        ifmap_rden_n = 1'b1;
                        tile_cnt_n = tile_cnt - 120;
                        tile_offset_n = tile_offset + 120;
                        ifmap_rdptr_n = input_offset + tile_offset_n;
                    end
                    cnt_n = 0;
                    last_n = 1'b0;
                    valid_n = 1'b0;
                    rst_buf_n_n = 1'b1;
                end else begin
                    cnt_n = cnt + 1;
                    wbuf_rdptr_n = cnt_n[6:0] + weight_offset + tile_offset;
                end
            end
        endcase
    end


    always_comb begin
        case(nth_fully_i)
            2'b00: begin
                weight_offset = FC_WBUF_OFFSET_1ST;
                input_offset =  FC_IBUF_OFFSET_1ST;
            end
            2'b01: begin
                weight_offset = FC_WBUF_OFFSET_2ND;
                input_offset =  FC_IBUF_OFFSET_2ND;
            end
            2'b10: begin
                weight_offset = FC_WBUF_OFFSET_3RD;
                input_offset =  FC_IBUF_OFFSET_3RD;
            end
            default : begin
                weight_offset = 0;
                input_offset =  0;
            end
        endcase
    end

    always_comb begin
        if (tile_cnt > 120) begin
            in_node_num = 120;
            over120 = 1;
        end else begin
            in_node_num = tile_cnt;
            over120 = 0;
        end
    end
 
    assign ifmap_rden_o     = ifmap_rden;
    assign ifmap_rdptr_o    = ifmap_rdptr;
    assign wbuf_rden_o      = wbuf_rden;
    assign wbuf_rdptr_o     = wbuf_rdptr;
    assign rst_buf_n_o      = rst_buf_n;
    assign valid_o          = valid;
    assign last_o           = last;
    assign pe_load_o        = pe_load;

endmodule