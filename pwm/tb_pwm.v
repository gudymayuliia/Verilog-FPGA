`timescale 1ns / 1ps


module tb_pwm();
reg clk =0;
reg rst = 0;
reg [3:0] w = 4'b0000;
wire wave;

pwm uut (.clk(clk), .rst(rst), .w(w), .wave(wave));

initial begin
rst = 1'b1;
#10;
rst = 1'b0;
end

initial begin
#10;
w = 4'b1000;
#1000;
w = 4'b1110; 
#1000;

$finish;
end
always #10 clk = ~clk;
endmodule
