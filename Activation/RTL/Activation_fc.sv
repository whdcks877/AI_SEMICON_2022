//version 2022-01-12
//editor IM SUHYEOK

module Activation_fc #(
    parameter       DATA_WIDTH      = 8
    )
(
    input   wire                clk,
    input   wire                rst,
    
    input   wire                acc_last_i, 
    input   wire                acc_valid_i,
    input   wire                [DATA_WIDTH-1:0] acc_result_i,

    output                      act_last_o, 
    output                      act_valid_o,
    output                      [DATA_WIDTH-1:0] act_result_o
);

    reg                         [DATA_WIDTH-1:0] act_result;
    reg                         state, state_n;



     always_comb begin
        if(acc_valid_i) begin
            if (!acc_last_i) begin
                if(!acc_result_i[DATA_WIDTH-1]) begin
                    act_result = acc_result_i;
                end else begin
                    act_result = 'b0;
                end
            end
        end
        else begin
            act_result = 'b0;
        end
    end

    assign act_last_o       = acc_last_i;
    assign act_valid_o      = acc_valid_i;
    assign act_result_o     = act_result;

endmodule
