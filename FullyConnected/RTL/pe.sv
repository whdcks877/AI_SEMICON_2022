module pe(
    input wire clk,
    input wire rst_n,
    input wire pe_load,

    input wire [7:0] psum_i,
    input wire [7:0] weight_i,
    input wire [7:0] ifmap_i,

    output wire [7:0] psum_o,
    output wire [7:0] ifmap_o
);

    reg [7:0] ifmap;
    reg [7:0] psum;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            psum <= 8'b0;
        end else begin
            psum <= weight_i*ifmap+psum_i;
        end
    end

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            ifmap <= 8'b0;
        end else if(pe_load) begin
            ifmap <= ifmap_i;
        end else begin
            ifmap <= ifmap;
        end
    end

    assign psum_o = psum;
    assign ifmap_o = ifmap;

endmodule