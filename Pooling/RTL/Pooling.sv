//version 2022-12-29

module Pooling #(
    parameter       DATA_WIDTH          = 8
)
(
    input   wire                clk,
    input   wire                rst,
    
    input   wire                act_last_i, 
    input   wire                act_valid_i,
    input   wire                [DATA_WIDTH-1:0] act_result_i,

    output                      pool_last_o,
    output                      pool_valid_o,
    output                      [DATA_WIDTH-1:0] pool_result_o
);

    localparam  S_INIT         = 2'd0,
                S_POOL         = 2'd1,
                S_OUT          = 2'd2;

    reg                         pool_valid;
    reg                         pool_last;
    reg                         [DATA_WIDTH-1:0] a1; // 2x2 pooling reg
    reg                         [DATA_WIDTH-1:0] a2; // 2x2 pooling reg
    reg                         [DATA_WIDTH-1:0] a3; // 2x2 pooling reg    
    reg                         [DATA_WIDTH-1:0] a4; // 2x2 pooling reg
    reg                         [DATA_WIDTH-1:0] pool_result;
    reg                         [1:0]   state, state_n;

    always_ff @(posedge clk) begin
        if(!rst) begin    
            state <= S_INIT;
            //pool_valid <= 1'b0;
            //pool_last <= 1'b0;
            //a1 <= 'b0;
            //a2 <= 'b0;
            //a3 <= 'b0;
            //a4 <= 'b0;
        end else begin
            state <= state_n;
        end
    end


     always_comb begin
        state_n = state;
        pool_valid = 1'b0;
        pool_last = 1'b0;
        //acc_valid = 1'b0;

        case(state)
            S_INIT: begin
                state_n = S_ACT;
                pool_result = 'b0;
            end
            /*S_POOL: begin
                if(act_valid_i) begin
                    if (!act_last_i) begin
                        
                        end else begin
                            act_result = 'b0;
                        end
                    end
                    else begin
                        act_last = 1'b1;
                        state_n = S_INIT;
                    end
                end*/
// 1. valid 신호가 들어오면 들어오는 순서대로 r1, r2, r3, r4에 저장
// 2. r1, r2, r3, r4 중에 가장 큰 값을 판별해서 pool_result에 할당
// 3. 그럼 중간에 1cycle이 물릴거 같음?
// 4. valid 신호가 들어오고 나서부터는 값들이 멈추지 않고 계속 들어옴

// 아니면 reg를 하나만 선언하고, 처음값 reg에 저장 한 뒤에, 이후 들어오는 값을 비교하여 큰값 reg에 넣기
// 이거를 3번 반복하고 pool result에 reg값 저장

            S_OUT: begin
                state_n = S_ACT;
                pool_result = 'b0;
            end
        endcase
    end

    assgin pool_last_o      = pool_last;
    assgin pool_valid_o     = pool_valid;
    assgin pool_result_o    = pool_result;

endmodule