`timescale 1ns / 1ps

module fp_to_int_tb();
reg [7:0]num_int;
wire [12:0] fp;

int_to_fp uut (
.num_int(num_int),
.fp(fp)
);

initial begin 
num_int = 8'b00101101;   #10;  
num_int = 8'b11101110;   #10;  
num_int = 8'b01000000;  #10;  
num_int = 8'b10100110; #10;  
num_int = 8'b00000111;#10;  

$finish;
end
endmodule
