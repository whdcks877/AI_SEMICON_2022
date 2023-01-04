`timescale 1ns/1ns 

module Activation_x16_tb;

	reg CLK;
	reg RST;
	reg acc_last[15:0];
	reg acc_valid[15:0];
	reg [7:0] acc_result[15:0];
	wire [7:0] act_result[15:0];
	wire act_last[15:0];
	wire act_valid[15:0];


	Activation_x16 Activation_x16_calcul_module(.clk(CLK), .rst(RST), 
	.acc_last_i(acc_last), .acc_valid_i(acc_valid), 
	.acc_result_i(acc_result), .act_result_o(act_result), 
	.act_last_o(act_last), .act_valid_o(act_valid));

	initial
	begin
		CLK = 1'b0;
		RST = 1'b0;
		for(int j=0; j<16; j++) begin
			acc_valid[j] = 1'b0;
			acc_last[j] = 1'b0;
			acc_result[j] = 8'd0;
		end
	end

	initial
	begin
		forever
		begin
			#10 CLK = !CLK;
		end
	end


	//calculate
	// A11 A12 A13 A14 :  1   2   3   4		
	// A21 A22 A23 A24 : -5  -6  -7  -8 	
	// A31 A32 A33 A34 :  9   10  11  12	
	// A41 A42 A43 A44 : -13 -14 -15 -16


	initial
	begin
		for(int i=0; i<16; i++) begin
		#20 RST = 1'b1; acc_valid[i] = 1'b1;
		#20 acc_result[i] = 8'b00000001;
		#20 acc_result[i] = 8'b00000010;
		#20 acc_result[i] = 8'b00000011;
		#20 acc_result[i] = 8'b00000100;

		#20 acc_result[i] = 8'b10000101;
		#20 acc_result[i] = 8'b10000110;
		#20 acc_result[i] = 8'b10000111;
		#20 acc_result[i] = 8'b10001000;
		
		#20 acc_result[i] = 8'b00001001;
		#20 acc_result[i] = 8'b00001010;
		#20 acc_result[i] = 8'b00001011;
		#20 acc_result[i] = 8'b00001100;

		#20 acc_result[i] = 8'b10001101;
		#20 acc_result[i] = 8'b10001110;
		#20 acc_result[i] = 8'b10001111;
		#20 acc_result[i] = 8'b10010000; acc_last[i] = 1'b1;

        #20 acc_last[i] = 1'b0;
		
		// calculate again
		
		#20 acc_result[i] = 8'b00000001;
		#20 acc_result[i] = 8'b00000010;
		#20 acc_result[i] = 8'b00000011;
		#20 acc_result[i] = 8'b00000100;

		#20 acc_result[i] = 8'b10000101;
		#20 acc_result[i] = 8'b10000110;
		#20 acc_result[i] = 8'b10000111;
		#20 acc_result[i] = 8'b10001000;
		
		#20 acc_result[i] = 8'b00001001;
		#20 acc_result[i] = 8'b00001010;
		#20 acc_result[i] = 8'b00001011;
		#20 acc_result[i] = 8'b00001100;

		#20 acc_result[i] = 8'b10001101;
		#20 acc_result[i] = 8'b10001110;
		#20 acc_result[i] = 8'b10001111;
		#20 acc_result[i] = 8'b10010000; 
		end
	end

	
endmodule

