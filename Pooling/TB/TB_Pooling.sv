`timescale 1ns/1ns 

module Pooling_tb;

	reg CLK;
	reg RST;
	reg act_last;
	reg act_valid;
	reg [7:0] act_result;
	reg [9:0] act_result_address;
	wire [7:0] pool_result;
	wire [9:0] pool_result_address;
	wire pool_last;
	wire pool_valid;


	Pooling Pooling_calcul_module(.clk(CLK), .rst(RST), 
	.act_last_i(act_last), .act_valid_i(act_valid), 
	.act_result_i(act_result), .act_result_address_i(act_result_address),
	.pool_result_o(pool_result), .pool_result_address_o(pool_result_address),
	.pool_last_o(pool_last), .pool_valid_o(pool_valid));

	initial
	begin
		CLK = 1'b0;
		RST = 1'b0;
		act_valid = 1'b0;
		act_last = 1'b0;
		act_result = 8'd0;
		act_result_address = 10'd0;
	end

	initial
	begin
		forever
		begin
			#10 CLK = !CLK;
		end
	end


	//calculate				  /data/			 /address/
	// A11 A12 A13 A14 :  1   2   3   4		|  1   2   3   4
	// A21 A22 A23 A24 : -5  -6  -7  -8 	|  5   6   7   8
	// A31 A32 A33 A34 :  9   10  11  12	|  9   10  11  12
	// A41 A42 A43 A44 : -13 -14 -15 -16	|  13  14  15  16


	initial
	begin
		
		#20 RST = 1'b1; act_valid = 1'b1;
		#10;
		#20 act_result = 8'b00000001; act_result_address = 10'b0000000001;
		#20 act_result = 8'b00000010; act_result_address = 10'b0000000010;
		#20 act_result = 8'b00000100; act_result_address = 10'b0000000011;
		#20 act_result = 8'b00000011; act_result_address = 10'b0000000100;

		#20 act_result = 8'b00000101; act_result_address = 10'b0000000101;
		#20 act_result = 8'b00000110; act_result_address = 10'b0000000110;
		#20 act_result = 8'b00000111; act_result_address = 10'b0000000111;
		#20 act_result = 8'b00001000; act_result_address = 10'b0000001000;
		
		#20 act_result = 8'b00001001; act_result_address = 10'b0000001001;
		#20 act_result = 8'b00001010; act_result_address = 10'b0000001010;
		#20 act_result = 8'b00001011; act_result_address = 10'b0000001011;
		#20 act_result = 8'b00001100; act_result_address = 10'b0000001100;

		#20 act_result = 8'b00001101; act_result_address = 10'b0000001101;
		#20 act_result = 8'b00001110; act_result_address = 10'b0000001110;
		#20 act_result = 8'b00001111; act_result_address = 10'b0000001111;
		#20 act_result = 8'b00010000; act_result_address = 10'b0000010000; act_last = 1'b1;

        #20 act_last = 1'b0;
		
		// calculate again
		
		#20 act_result = 8'b00000001; act_result_address = 10'b0000000001;
		#20 act_result = 8'b00000010; act_result_address = 10'b0000000010;
		#20 act_result = 8'b00000011; act_result_address = 10'b0000000011;
		#20 act_result = 8'b00000100; act_result_address = 10'b0000000100;

		#20 act_result = 8'b00000101; act_result_address = 10'b0000000101;
		#20 act_result = 8'b00000110; act_result_address = 10'b0000000110;
		#20 act_result = 8'b00000111; act_result_address = 10'b0000000111;
		#20 act_result = 8'b00001000; act_result_address = 10'b0000001000;
		
		#20 act_result = 8'b00001001; act_result_address = 10'b0000001001;
		#20 act_result = 8'b00001010; act_result_address = 10'b0000001010;
		#20 act_result = 8'b00001011; act_result_address = 10'b0000001011;
		#20 act_result = 8'b00001100; act_result_address = 10'b0000001100;

		#20 act_result = 8'b00001101; act_result_address = 10'b0000001101;
		#20 act_result = 8'b00001110; act_result_address = 10'b0000001110;
		#20 act_result = 8'b00001111; act_result_address = 10'b0000001111;
		#20 act_result = 8'b00010000; act_result_address = 10'b0000010000; act_last = 1'b1;

        #20 act_last = 1'b0;
	end

	
endmodule

