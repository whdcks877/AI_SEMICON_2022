`define TAG_SA          3'b000
`define TAG_FC_WEIGHT  3'b001
`define TAG_FC_INPUT    3'b010
`define TAG_P_ADDR_BUF  3'b011
`define TAG_FC_DATA_BUF 3'b100
`define TAG_SA_DATA_BUF 3'b101

module addr_decoder(
    input wire [21:0] addr_a,
    input wire [31:0] wrdata_a,
    output wire [31:0] rddata_a,
    input wire en_a,
    input wire rst_a,
    input wire [3:0] we_a,

    //result data
    input wire [7:0]       sa_data_rdata_i,
    input wire [7:0]       fc_data_rdata_i,
    input wire [9:0]       pool_address_rdata_i,
    
    //sa_bram write
    output   wire            wea_o,
    output   wire    [16:0]  addra_o,
    output   wire    [7:0]   dia_o,

    //fully connected buffer
    output wire                          wbuf_wren_o,
    output wire  [16:0]                  wbuf_wrptr_o,
    output wire  [7:0]                   wbuf_wdata_o,

    output wire                          ifmap_wren_o,
    output wire  [6:0]                   ifmap_wrptr_o,
    output wire  [7:0]                   ifmap_wdata_o,
    
    //pooling
    output wire                          sa_data_rden_o,
    output wire  [13:0]                  sa_data_rdptr_o,

    output wire                          fc_data_rden_o,
    output wire  [9:0]                   fc_data_rdptr_o,

    output wire                          pool_address_rden_o,
    output wire  [13:0]                  pool_address_rdptr_o
);
    wire [19:0] addr = addr_a[21:2];
    wire [3:0] tag = addr[19:17];
    wire wren = we_a[0];
    wire rden = en_a&&!(we_a[0]); 

    //axi
    reg [31:0] rddata;

    //bram
    reg                         wea;
    reg [16:0]                  addra;
    reg [7:0]                   dia;

    reg                          wbuf_wren;
    reg  [16:0]                  wbuf_wrptr;
    reg  [7:0]                   wbuf_wdata;

    reg                          ifmap_wren;
    reg  [6:0]                   ifmap_wrptr;
    reg  [7:0]                   ifmap_wdata;

    reg                          sa_data_rden;
    reg  [13:0]                  sa_data_rdptr;
    reg                          fc_data_rden;
    reg  [9:0]                   fc_data_rdptr;
    reg                          pool_address_rden;
    reg  [13:0]                  pool_address_rdptr;

    always_comb begin
        rddata = 'b0;
        wea = 'b0;
        addra = 'b0;
        dia = 'b0;
        wbuf_wren = 'b0;
        wbuf_wrptr = 'b0;
        wbuf_wdata = 'b0;
        ifmap_wren = 'b0;
        ifmap_wrptr = 'b0;
        ifmap_wdata = 'b0;
        sa_data_rden = 'b0;
        sa_data_rdptr = 'b0;
        fc_data_rden = 'b0;
        fc_data_rdptr = 'b0;
        pool_address_rden = 'b0;
        pool_address_rdptr = 'b0;
        
      if(wren) begin
            case(tag)
                `TAG_SA: begin
                    wea = 1'b1;
                    dia = wrdata_a[7:0];
                    addra = addr[16:0];
                end
                `TAG_FC_WEIGHT: begin
                    wbuf_wren = 1'b1;
                    wbuf_wrptr = addr[16:0];
                    wbuf_wdata = wrdata_a[7:0];
                end
                `TAG_FC_INPUT: begin
                    ifmap_wren = 1'b1;
                    ifmap_wrptr = addr[6:0];
                    ifmap_wdata = wrdata_a[7:0];
                end
            endcase
        end else if(rden) begin
            case(tag)
                `TAG_P_ADDR_BUF: begin
                    pool_address_rden = 1'b1;
                    pool_address_rdptr = addr[13:0];
                    rddata = {22'b0,pool_address_rdata_i};
                end
                `TAG_FC_DATA_BUF: begin
                    fc_data_rden = 1'b1;
                    fc_data_rdptr = addr[9:0];
                    rddata = {24'b0,fc_data_rdata_i};
                end
                `TAG_SA_DATA_BUF: begin
                    sa_data_rden = 1'b1;
                    sa_data_rdptr = addr[13:0];
                    rddata = {24'b0,sa_data_rdata_i};
                end
            endcase
        end
    end

    assign rddata_a = rddata;
    assign wea_o = wea;
    assign addra_o = addra;
    assign dia_o = dia;
    assign wbuf_wren_o = wbuf_wren;
    assign wbuf_wrptr_o = wbuf_wrptr;
    assign wbuf_wdata_o = wbuf_wdata;
    assign ifmap_wren_o = ifmap_wren;
    assign ifmap_wrptr_o = ifmap_wrptr;
    assign ifmap_wdata_o = ifmap_wdata;
    assign sa_data_rden_o = sa_data_rden;
    assign sa_data_rdptr_o = sa_data_rdptr;
    assign fc_data_rden_o = fc_data_rden;
    assign fc_data_rdptr_o = fc_data_rdptr;
    assign pool_address_rden_o = pool_address_rden;
    assign pool_address_rdptr_o = pool_address_rdptr;
    

endmodule

