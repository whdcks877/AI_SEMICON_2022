interface fc_ifmap_buf_if(
    input clk,
    input rst_n
);

    logic rden_i;
    logic wren_i;
    logic [6:0] rdptr_i;
    logic [6:0] wrptr_i;
    byte ifmap_i;
    byte ifmap_o;

    task init();
        rden_i = 0;
        wren_i = 0;
        rdptr_i = 0;
        wrptr_i = 0;
        ifmap_i = 0;
    endtask

    task automatic write_ram(input logic [6:0] addr, input byte data);
        wren_i = 1;
        wrptr_i = addr;
        ifmap_i = data;
        @(posedge clk);
        wren_i = 0;
    endtask


endinterface