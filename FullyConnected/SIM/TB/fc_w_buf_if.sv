interface fc_w_buf_if(
    input clk,
    input rst_all
);

    logic rst_n;
    logic [9:0] rdptr_i;
    logic [16:0] wrptr_i;
    logic rden_i;
    logic wren_i;
    byte weight_i;
    byte weight_o [120];

    task init();
        rst_n = 1;
        rdptr_i = 0;
        wrptr_i = '{default: 0};
        rden_i = 0;
        wren_i = 0;
        weight_i = '{default:0};
        weight_o = '{default:0};
    endtask

    task automatic write_ram(input logic [16:0] addr, input byte data);
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