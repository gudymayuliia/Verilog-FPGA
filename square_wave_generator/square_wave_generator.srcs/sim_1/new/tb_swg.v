`timescale 1ns / 1ps

module tb_swg();


    // Inputs
    reg clk;
    reg rst;
    reg [3:0] m;
    reg [3:0] n;

    // Outputs
    wire square_wave;

    // Instantiate the Unit Under Test (UUT)
    square_wave_generator uut (
.clk(clk),
.rst(rst),
.m(m),
.n(n),
.square_wave(square_wave)
    );
    always begin
	clk=1'b0;
	#10;
	clk=1'b1;
	#10;
	end
    initial begin
        
        clk = 0;
        rst = 0;
        m = 4'b0010;
        n = 4'b0011;

        rst = 1;
        #20; 
        rst = 0;

        $monitor("Time: %0t | m: %d | n: %d | square_wave: %b", $time, m, n, square_wave);

        #1000;
        m = 4'b0100;
        n = 4'b0101;
        #1000;
        m = 4'b0011; 
        n = 4'b0010; 
        #1000;
        $finish;
    end

endmodule

