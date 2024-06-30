`timescale 1ns / 1ps


module square_wave_generator
(
input wire clk, rst,
input wire [3:0] m, n, 
output wire square_wave
    );
    
    reg [3:0] counter;
    reg [3:0] on;
    reg [3:0] off;
    reg next_wave;
    reg reg_wave;
    
    always@(posedge clk, posedge rst) begin
    if(rst) begin
        reg_wave <=0;
        counter <= 0;
    end
    else begin
        reg_wave <= next_wave;
        counter <= counter +1;
    end
end   
    always @* begin
    next_wave = reg_wave;
    on = m* 5;
    off = n * 5;
    
    if(~reg_wave && counter == off) begin
        next_wave = 1;
        counter = 0;
    end
    
    if(reg_wave && counter == on) begin
        next_wave = 0;
        counter = 0;
    end
end    
assign square_wave = reg_wave;
    
endmodule
