`timescale 1ns / 1ps
module tb;

    // Inputs
    reg [7:0] a;
    reg [2:0] amt;
    reg lr;

    // Outputs
    wire [7:0] mout;

    // Instantiate the Unit Under Test (UUT)
    bshifter uut (
        .a(a), 
        .amt(amt), 
        .lr(lr), 
        .mout(mout)
    );

    initial begin
        // Initialize inputs
        a = 8'b10101010; amt = 3'b000; lr = 0;
        #10; // Wait 10 ns
        $display("Initial: mout = %b", mout);

        // Test right rotation
        amt = 3'b001; #10; // Shift right by 1
        $display("Shift right by 1: mout = %b", mout);

        amt = 3'b010; #10; // Shift right by 2
        $display("Shift right by 2: mout = %b", mout);

        amt = 3'b100; #10; // Shift right by 4
        $display("Shift right by 4: mout = %b", mout);

        // Test left rotation
        lr = 1; amt = 3'b001; #10; // Shift left by 1
        $display("Shift left by 1: mout = %b", mout);

        amt = 3'b010; #10; // Shift left by 2
        $display("Shift left by 2: mout = %b", mout);

        amt = 3'b100; #10; // Shift left by 4
        $display("Shift left by 4: mout = %b", mout);

        $finish;
    end
endmodule

