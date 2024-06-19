`timescale 1ns / 1ps

module fpgt_tb();
reg [12:0] num1, num2;
wire gt;

initial begin
num1 = 13'd0;
num2 = 13'd0;
end


fp_gt uut(
.num1(num1),
.num2(num2),
.gt(gt)
);

initial begin
num1 = 13'b1010110100100; num2 = 13'b0100011000000;
#10 num1 = 13'b0011010000000; num2 = 13'b1100011100000;
#10 num1 = 13'b0100010101000; num2 = 13'b1010110000000;
#10 num1 = 13'b0011110010000; num2 = 13'b1010011000000;
#10 num1 = 13'b0100011011000; num2 = 13'b0100011011000;

#10 $finish;
end


endmodule
