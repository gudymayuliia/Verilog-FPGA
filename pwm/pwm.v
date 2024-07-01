module pwm(
input clk, rst,
input [3:0] w,
output reg wave
    );
    
    reg [3:0] counter;
    reg next_wave;
    reg [3:0] next_counter;
    
    always @(posedge clk, posedge rst) 
    begin
    if(rst) begin
      counter <= 0;
      wave <= 0;
    end
    else  
        counter <= next_counter;
        wave <= next_wave;
    end
    
    always @* begin
    next_counter = (counter <15) ? counter+1 : 0;
    next_wave = (counter < w) ? 1 : 0;
    end
    
endmodule
