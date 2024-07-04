`timescale 1ns / 1ps


module tb_stack();

reg clk;
reg reset;
reg pop;
reg push;
reg [7:0] push_data;

wire empty;
wire full;
wire [7:0] pop_data;

stack uut (
.clk(clk),
.reset(reset),
.pop(pop),
.push(push),
.push_data(push_data),
.empty(empty),
.full(full),
.pop_data(pop_data)
);

always begin
clk = 1'b0;
#10;
clk= 1'b1;
#10;
end

initial begin
clk = 1'b0;
reset = 1'b1;
pop = 1'b0;
push = 1'b0;
push_data = 8'b0;

#20;
reset = 1'b0;

push = 1'b1;
push_data = 8'b00110101;
#20;
push_data = 8'b10100110;
#20;
push_data = 8'b01011010;
#20;

push = 1'b0;
pop = 1'b1;
#20
pop = 1'b0;
$finish;

end




endmodule
