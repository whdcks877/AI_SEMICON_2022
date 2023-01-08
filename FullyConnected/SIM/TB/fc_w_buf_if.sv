interface fc_w_buf_if(
    input clk,
    input rst_all
);

    logic rst_n;
    logic [6:0] rdptr_i;
    logic [6:0] wrptr_i [`FC_SIZE];
    logic rden_i;
    logic wren_i;
    byte weight_i [`FC_SIZE];
    byte weight_o [`FC_SIZE];

    task init();
        rst_n = 1;
        rdptr_i = 0;
        wrptr_i = '{default: 0};
        rden_i = 0;
        wren_i = 0;
        weight_i = '{default:0};
        weight_o = '{default:0};
    endtask

    task automatic write_ram(input logic [6:0] addr[`FC_SIZE], input byte data[`FC_SIZE]);
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