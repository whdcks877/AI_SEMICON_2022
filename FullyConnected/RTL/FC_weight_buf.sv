`include "rams_sp_rf_rst.sv"

module fc_weight_buf(
    input wire clk,
    input wire rst_n,
    input wire rst_all,

    input wire [6:0] rdptr_i,
    input wire [6:0] wrptr_i [128],
    input wire rden_i,
    input wire wren_i,
    input wire [7:0] weight_i [128],
    output wire [7:0] weight_o [128]
);

    reg [6:0] ptr [128];
    reg [6:0] rdptr_reg [127]; 
    reg rden_reg [127];
    reg rst_n_reg [127];

    always_ff @(posedge clk) begin
        if(!rst_all) begin
            for(int i = 0; i<127; i++) begin
                rdptr_reg[i] <= 'b0;
                rden_reg[i] <= 'b0;
                rst_n_reg[i] <= 'b1;
            end
        end else begin
            rdptr_reg[0] <= rdptr_i;
            rden_reg[0] <= rden_i;
            rst_n_reg[0] <= rst_n;
    
            for(int i = 1; i<127; i++) begin
                rdptr_reg[i] <= rdptr_reg[i-1];
                rden_reg[i] <= rden_reg[i-1];
                rst_n_reg[i] <= rst_n_reg[i-1];
            end
        end
    end

    always_comb begin
        if(rden_i) begin
            ptr[0] = rdptr_i;
            ptr[1:127] = rdptr_reg[0:126];
        end else begin
            ptr = wrptr_i;
        end
    end

    rams_sp_rf_rst #(.SRAM_DEPTH(84), .DATA_WIDTH(8)) buf0(
                .clk(clk),
                .en(rden_i),
                .we(wren_i),
                .rst_n(rst_all && rst_n),
                .addr(ptr[0]),
                .di(weight_i[0]),
                .dout(weight_o[0])
            );

    genvar i;
    generate
        for(i=1; i<128; i++) begin
            rams_sp_rf_rst #(.SRAM_DEPTH(84), .DATA_WIDTH(8)) u_buf(
                .clk(clk),
                .en(rden_reg[i-1]),
                .we(wren_i),
                .rst_n(rst_all & rst_n_reg[i-1]),
                .addr(ptr[i]),
                .di(weight_i[i]),
                .dout(weight_o[i])
            );
        end
    endgenerate
endmodule