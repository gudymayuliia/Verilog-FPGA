`timescale 1ns / 1ps

module tb_stopwatch;
  // Inputs
  reg clk;
  reg go;
  reg clr;

  // Outputs
  wire [3:0] d3;
  wire [3:0] d2;
  wire [3:0] d1;
  wire [3:0] d0;
  wire [3:0] an;
  wire [6:0] sseg;
  wire dp;

  // Instantiate the Unit Under Test (UUT)
  stopwatch uut (
    .clk(clk), 
    .go(go), 
    .clr(clr), 
    .d3(d3), 
    .d2(d2), 
    .d1(d1), 
    .d0(d0),
    .an(an),
    .sseg(sseg),
    .dp(dp)
  );

  always begin
  clk = 1'b1;
  #5;
  clk = 1'b0;
  #5;
  end

  initial begin
    clk = 0;
    go = 0;
    clr = 1;

    #100;

    clr = 0;
    go = 1;
  end
  

  initial begin
    $monitor("Time: %0d | d3: %d | d2: %d | d1: %d | d0: %d | an: %b | sseg: %b | dp: %b", $time, d3, d2, d1, d0, an, sseg, dp);
    #50000000000 
    $finish; 
  end
      
endmodule

