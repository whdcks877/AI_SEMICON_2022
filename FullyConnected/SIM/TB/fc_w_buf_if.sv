interface fc_w_buf_if(
    input clk,
    input rst_all
);

    logic rst_n;
    logic [6:0] rdptr_i;
    logic [6:0] wrptr_i [128];
    logic rden_i;
    logic wren_i;
    byte weight_i [128];
    byte weight_o [128];

    task init();
        rst_n = 1;
        rdptr_i = 0;
        wrptr_i = '{default: 0};
        rden_i = 0;
        wren_i = 0;
        weight_i = '{default:0};
        weight_o = '{default:0};
    endtask

    task automatic write_ram(input logic [6:0] addr[128], input byte data[128]);
        wren_i = 1;
        wrptr_i = addr;
        weight_i = data;
        @(posedge clk);
        wren_i = 0;
    endtask

/*
    task automatic read_ram(input int addr, output byte data[128], int cnt);
        rden_i = 1;
        rdptr_i = addr;
        @(posedge clk);
        data = 
    endtask
*/

endinterface