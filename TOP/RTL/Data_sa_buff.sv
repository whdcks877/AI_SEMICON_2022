
module Data_sa_buff #
(
    parameter SRAM_DEPTH=1024,
    parameter BAND_WIDTH=16,
    parameter DATA_WIDTH=8
)
(
    input   wire  clk,
    input   wire  wea[BAND_WIDTH],                                      //write
    input   wire  enb,                                                  //read
    input   wire  [$clog2(SRAM_DEPTH)-1:0] addra[BAND_WIDTH],           //write   
    input   wire  [$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:0] addrb,    //read
    
    input   reg   [DATA_WIDTH-1:0]  dia[BAND_WIDTH],                    //write
    output  reg   [DATA_WIDTH-1:0]  dob                                 //read
);

    wire        [$clog2(BAND_WIDTH)-1:0]   BLOCK_NUMa = addrb[$clog2(SRAM_DEPTH)+$clog2(BAND_WIDTH)-1:$clog2(SRAM_DEPTH)];
    reg         [$clog2(BAND_WIDTH)-1:0]    BLOCK_NUM_d;
    wire        [7:0] rdatas[16];
    reg         [7:0] rdata;

    genvar  i;
    generate
        for (i=0; i<BAND_WIDTH; i++) begin: channel
            simple_dual_one_clock #(
                .SRAM_DEPTH(SRAM_DEPTH),
                .DATA_WIDTH(DATA_WIDTH)
            )
            u_ram
            (
                .clk                    (clk),
                .wea                    (wea[i]),
                .enb                    (enb && (BLOCK_NUMa == i)),
                .addra                  (addra[i]),
                .addrb                  (addrb[$clog2(SRAM_DEPTH)-1:0]),

                .dia                    (dia[i]),
                .dob                    (rdatas[i])
            );
        end
    endgenerate
    always_ff @(posedge clk) begin
        BLOCK_NUM_d <= BLOCK_NUMa;
    end
    always_comb begin
        case(BLOCK_NUM_d)
            'd0: begin
                rdata = rdatas[0];
            end
            'd1: begin
                rdata = rdatas[1];
            end
            'd2: begin
                rdata = rdatas[2];
            end
            'd3: begin
                rdata = rdatas[3];
            end
            'd4: begin
                rdata = rdatas[4];
            end
            'd5: begin
                rdata = rdatas[5];
            end
            'd6: begin
                rdata = rdatas[6];
            end
            'd7: begin
                rdata = rdatas[7];
            end
            'd8: begin
                rdata = rdatas[8];
            end
            'd9: begin
                rdata = rdatas[9];
            end
            'd10: begin
                rdata = rdatas[10];
            end
            'd11: begin
                rdata = rdatas[11];
            end
            'd12: begin
                rdata = rdatas[12];
            end
            'd13: begin
                rdata = rdatas[13];
            end
            'd14: begin
                rdata = rdatas[14];
            end
            'd15: begin
                rdata = rdatas[15];
            end
            default : begin
                rdata = 'b0;
            end
        endcase
    end

    assign dob = rdata;
endmodule