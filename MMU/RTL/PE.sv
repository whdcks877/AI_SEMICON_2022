// Processing Element
// JY Lee
// Version 2022-12-28

module PE
(
    input   wire            clk,
    input   wire            rst_n,
    //Left part
    input   wire    [31:0]  data_i,

    //Up part
    input   wire    [31:0]  weight_i,
    input   wire    [31:0]  sum_i,
    //Right part
    output  reg    [31:0]  data_o,

    //Down part
    output  reg    [31:0]  sum_o
);
    reg     [31:0]      sum_tmp;
    reg     [31:0]      data_tmp;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            sum_o <= 32'b0;
            data_o <= 32'b0;
        end
        sum_o <= sum_tmp;
        data_o <= data_tmp;
    end

    always_comb begin
        if(!rst_n) begin
            sum_tmp = 32'b0;
            data_tmp = 32'b0;
        end
        sum_tmp = weight_i * data_i + sum_i;
        data_tmp = data_i;
    end
endmodule