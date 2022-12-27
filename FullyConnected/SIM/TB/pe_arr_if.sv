interface PE_ARR_IF(
        input clk,
        input rst_n
);

    logic [7:0] weight_i [`FC_SIZE];
    logic pe_load_i;
    logic [7:0] ifmap_i;
    logic [7:0] psum_o;
    logic [7:0] ifmap_o;


endinterface