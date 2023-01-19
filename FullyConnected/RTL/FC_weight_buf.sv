`include "rams_sp_rf_rst.sv"

module fc_weight_buf(
    input wire clk,
    input wire rst_n,
    input wire rst_all,

    input wire [9:0] rdptr_i,
    //input wire [9:0] wrptr_i [120],
    input wire [16:0] wrptr_i,
    input wire rden_i,
    input wire wren_i,
    //input wire [7:0] weight_i [120],
    input wire [7:0] weight_i,
    output wire [7:0] weight_o [120]
);

    reg [9:0] ptr [120];
    reg [9:0] rdptr_reg [119]; 
    reg rden_reg [119];
    reg rst_n_reg [119];
    wire [9:0] wrptr = wrptr_i[9:0];
    wire [9:0] bram_sel = wrptr_i[16:10];

    always_ff @(posedge clk) begin
        if(!rst_all) begin
            for(int i = 0; i<119; i++) begin
                rdptr_reg[i] <= 'b0;
                rden_reg[i] <= 'b0;
                rst_n_reg[i] <= 'b1;
            end
        end else begin
            rdptr_reg[0] <= rdptr_i;
            rden_reg[0] <= rden_i;
            rst_n_reg[0] <= rst_n;
    
            for(int i = 1; i<119; i++) begin
                rdptr_reg[i] <= rdptr_reg[i-1];
                rden_reg[i] <= rden_reg[i-1];
                rst_n_reg[i] <= rst_n_reg[i-1];
            end
        end
    end


    rams_sp_rf_rst #(.SRAM_DEPTH(1024), .DATA_WIDTH(8)) buf0(
                .clk(clk),
                .en(rden_i),
                .we(wren_i && (bram_sel == 7'd0)),
                .rst_n(rst_all && rst_n),
                .addr(rden_i ? rdptr_i : wrptr),
                
                .di(weight_i),
                .dout(weight_o[0])
            );

    genvar i;
    generate
        for(i=1; i<120; i++) begin
            rams_sp_rf_rst #(.SRAM_DEPTH(1024), .DATA_WIDTH(8)) u_buf(
                .clk(clk),
                .en(rden_reg[i-1]),
                .we(wren_i && (bram_sel == i)),
                .rst_n(rst_all & rst_n_reg[i-1]),
                .addr(rden_i ? rdptr_reg[i-1] : wrptr),
                .di(weight_i),
                .dout(weight_o[i])
            );
        end
    endgenerate
endmodule