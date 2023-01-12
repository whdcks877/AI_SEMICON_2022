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
    //output  wire                act_ready_o,  not yet used
    input   wire                [DATA_WIDTH-1:0] acc_result_i,

    output                      act_last_o, 
    output                      act_valid_o,
    //input   wire                pool_ready_i, not yet used
    output                      [DATA_WIDTH-1:0] act_result_o
);
    localparam  S_INIT  = 1'd0,
                S_ACT   = 1'd1;

    //reg                         acc_valid;
    reg                         act_valid;
    reg                         act_last;
    reg                         [DATA_WIDTH-1:0] act_result;
    reg                         state, state_n;

    always_ff @(posedge clk) begin
        if(!rst) begin    
            state <= S_INIT;
            //act_valid <= 1'b0;
            //act_last <= 1'b0;
            //act_result <= 'b0;
        end else begin
            state <= state_n;
        end
    end


     always_comb begin
        state_n = state;
        act_valid = 1'b0; 
        //act_last = 1'b0; The location of this should be discussed later.

        case(state)
            S_INIT: begin
                if(acc_valid_i) begin
                    state_n = S_ACT;
                end
                //act_valid = 1'b0; The location of this should be discussed later.
                act_last = 1'b0;
                act_result = 'b0;
            end
            S_ACT: begin
                if(acc_valid_i) begin
                    act_valid = 1'b1;
                    if (!acc_last_i) begin
                        if(!acc_result_i[DATA_WIDTH-1]) begin
                            act_result = acc_result_i;
                        end else begin
                            act_result = 'b0;
                        end
                    end
                    else begin
                        act_last = 1'b1;
                        state_n = S_INIT;
                    end
                end
                else begin
                    state_n = S_INIT;
                end
            end
        endcase
    end

    assign act_last_o       = act_last;
    assign act_valid_o      = act_valid;
    assign act_result_o     = act_result;

endmodule
