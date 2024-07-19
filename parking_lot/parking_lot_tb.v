module parking_lot_tb();

reg clk = 1'b0; 
reg reset;
reg a, b;
wire entering, exiting;

parking_lot uut (
.clk(clk),
.reset(reset),
.a(a),
.b(b),
.entering(entering),
.exiting(exiting)
);


always #5 clk = ~clk;

initial begin

clk = 0;
reset = 0;
a = 0;
b = 0;

reset = 1;
#10;
reset = 0;
#10;


a = 0; b = 0; #20; 
a = 1; b = 0; #20; 
a = 1; b = 1; #20;
a = 0; b = 1; #20; 
a = 0; b = 0; #20; 

a = 0; b = 0; #20; 
a = 0; b = 1; #20;
a = 1; b = 1; #20; 
a = 1; b = 0; #20; 
a = 0; b = 0; #20; 

end


endmodule
