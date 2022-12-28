interface PE_ARR_IF(
        input clk,
        input rst_n
);

    logic [7:0] weight_i [`FC_SIZE];
    logic pe_load_i;
    logic [7:0] ifmap_i;
    logic [7:0] psum_o;
    logic [7:0] ifmap_o;

    modport TB (
    input weight_i, pe_load_i, ifmap_i,
    output psum_o, ifmap_o
    );

    task init();
        weight_i = '{default: 'b0};
        pe_load_i = 'b0;
        ifmap_i = 'b0;
        psum_o = 'b0;
        ifmap_o = 'b0;
    endtask


endinterface