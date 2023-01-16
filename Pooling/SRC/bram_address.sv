
module bram_address_counter#
(
    parameter SRAM_DEPTH=1024,
    parameter DATA_WIDTH=8
)
(
    input     wire  clk,
    input     wire  rst,
    input     wire  enable,                                                                                  
    output    reg  [$clog2(SRAM_DEPTH)-1:0] address
);
    always_ff @(posedge clk) begin
        if(!rst) begin
            address <= 'd0;
        end else begin
            if(enable) begin
                address <= address + 1'b1;
            end
        end
            
    end
endmodule