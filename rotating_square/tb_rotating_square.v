`timescale 1ns / 1ps

module tb_rotating_square;

	// Inputs
	reg clk;
	reg reset;
	reg cw;

	wire [7:0] in0;
	wire [7:0] in1;
	wire [7:0] in2;
	wire [7:0] in3;

	rotating_square #(.base_counter(5)) uut 
	( 
		.clk(clk), 
		.reset(reset), 
		.cw(cw), 
		.in0(in0), 
		.in1(in1), 
		.in2(in2), 
		.in3(in3)
	);
	always begin
	clk=1'b0;
	#10;
	clk=1'b1;
	#10;
	end
	
	initial begin
		clk = 0;
		reset = 1'b0;
		cw = 0;
	end
endmodule
