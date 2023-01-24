`include "fc_accumulator.sv"
`include "FullyConnected.sv"

module FC_TOP(
    input wire          clk,
    input wire          rst_n,

    input wire          start_i, //input after buffers are filled, FC operate start
    input wire [8:0]    in_node_num_i, //number of input node, 1~128
    input wire [6:0]    out_node_num_i, //number of output node, 1~84
    input wire [1:0]    nth_fully_i,

    //write port  for weight buffer
    input wire          wbuf_wren_i,
    input wire [16:0]    wbuf_wrptr_i,
    input wire [7:0]    wbuf_wdata_i,

    //write port for ifmap buffer
    input wire          ifmap_wren_i,
    input wire [9:0]    ifmap_wrptr_i,
    input wire [7:0]    ifmap_wdata_i,

    output wire [7:0]   fc_result_o, //output node
    output wire         fc_valid_o, //output node data is valiad
    output wire         fc_last_o  //last data of output node
);



    wire [7:0]  psum_acc;
    wire [15:0] psum_dir;
    reg  [7:0] psum_dir_truncted;
    wire        valid_dir, valid_acc;
    wire        last_dir, last_acc;

    reg [1:0]   nth_fully;

    always_ff @(posedge clk) begin
        if(start_i)
            nth_fully <= nth_fully_i;
        else
             nth_fully <= nth_fully;
    end


FullyConnected u_fc(
    .clk(clk),
    .rst_n(rst_n),
    .start_i(start_i),
    .in_node_num_i(in_node_num_i), 
    .out_node_num_i(out_node_num_i),
    .nth_fully_i(nth_fully),
    .wbuf_wren_i(wbuf_wren_i),
    .wbuf_wrptr_i(wbuf_wrptr_i),
    .wbuf_wdata_i(wbuf_wdata_i),
    .ifmap_wren_i(ifmap_wren_i),
    .ifmap_wrptr_i(ifmap_wrptr_i),
    .ifmap_wdata_i(ifmap_wdata_i),
    .psum_o(psum_dir),
    .valid_o(valid_dir), 
    .last_o(last_dir)
    );

fc_accumulator u_fc_acc(
    .clk(clk),
    .rst_n(rst_n),
    .psum_i(psum_dir),
    .pvalid_i(valid_dir), 
    .out_node_num_i(out_node_num_i),
    .tile_num_i((nth_fully == 0) ? 4'd4 : 4'd1),
    .fc_valid_o(valid_acc), 
    .last_o(last_acc),
    .fc_result_o(psum_acc)
);
    always_comb begin
        if(psum_dir[15] == 1'b0) begin
            if(|psum_dir[15:7] == 1'b1)
                psum_dir_truncted = 8'b01111111;
           else
                psum_dir_truncted = psum_dir[7:0];
            
        end else begin
            if(&psum_dir[15:7] == 1'b0)
                psum_dir_truncted = 8'b10000000;
            else
                psum_dir_truncted = psum_dir[7:0];
        end
    end

    assign fc_result_o = (nth_fully == 0) ? psum_acc : psum_dir_truncted;
    assign fc_valid_o = (nth_fully == 0) ? valid_acc : valid_dir;
    assign fc_last_o = (nth_fully == 0) ? last_acc : last_dir;
endmodule