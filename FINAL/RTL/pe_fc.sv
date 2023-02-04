module pe_fc(
    input wire clk,
    input wire rst_n,
    input wire pe_load,

    input wire [31:0] psum_i,
    input wire [7:0] weight_i,
    input wire [7:0] ifmap_i,

    output wire [31:0] psum_o,
    output wire [7:0] ifmap_o
);

    reg [31:0] ifmap;
    reg [31:0] psum;
    
    wire [31:0] weight_ext = {{24{weight_i[7]}}, weight_i[7:0]};
    wire [31:0] ifmap_ext = {{24{ifmap_i[7]}}, ifmap_i[7:0]};

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            psum <= 8'b0;
        end else begin
            psum <= weight_ext*ifmap + psum_i;
        end
    end

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            ifmap <= 32'b0;
        end else if(pe_load) begin
            ifmap <= ifmap_i;
        end else begin
            ifmap <= ifmap;
        end
    end

    assign psum_o = psum;
    assign ifmap_o = ifmap;

endmodule