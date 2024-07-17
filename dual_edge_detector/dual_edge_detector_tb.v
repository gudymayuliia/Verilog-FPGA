`timescale 1ns / 1ps

module dual_edge_detector_tb();
reg clk = 1'b0; 
reg reset;
reg level = 1'b0;;
wire tick;

dual_edge_detector uut (
.clk(clk),
.reset(reset),
.level(level),
.tick(tick)
);

always #10 clk = ~clk;

initial begin
reset = 1'b1;
#10;
reset = 1'b0;
end

initial begin
level = 1'b1;
repeat(2) @(negedge clk);
level=0;
repeat(5) @(negedge clk);


end


endmodule
