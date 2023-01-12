// Processing Element
// JY Lee
// Version 2023-01-10 1st verified
// 2023-01-12 2nd verified

module PE
(
    input   wire            clk,
    input   wire            rst_n,
    //Left part
    input   wire    [7:0]  data_i,

    //Up part
    input   wire    [7:0]  weight_i,
    input   wire    [7:0]  sum_i,
    input   wire           weight_stop,    //when high, weight stop!
    //Right part
    output  reg    [7:0]  data_o,

    //Down part
    output  reg    [7:0]  weight_o,
    output  reg    [7:0]  sum_o
);
    reg     [7:0]      sum_tmp;
    reg     [7:0]      data_tmp;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            sum_o <= 8'b0;
            data_o <= 8'b0;
            weight_o <= 8'b0;
        end
        if(!weight_stop) begin
            weight_o <= weight_i;
        end
        sum_o <= sum_tmp;
        data_o <= data_tmp;
    end

    always_comb begin
        if(!rst_n) begin
            sum_tmp = 8'b0;
            data_tmp = 8'b0;
        end
        sum_tmp = weight_o * data_i + sum_i;
        data_tmp = data_i;
    end
endmodule