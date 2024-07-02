module rotating_led_banner
#(parameter base_counter=10_000_000)
(
    input wire clk,
    input wire reset,
    input wire [3:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9,
    output reg [3:0] in0,in1,in2,in3     // led segments
);
    reg[23:0] counter=0; 
    reg[39:0] word;
    reg[39:0] word_next;
    wire [23:0] counter_next;
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
            word <= {w9, w8, w7, w6, w5, w4, w3, w2, w1, w0};
        end else begin
            counter <= counter_next;
            word <= word_next;
        end
    end
    // next-state logic

    assign counter_next = (counter == base_counter-1) ? 24'd0 : counter + 1'b1;   

    
    always @* begin
    word_next = word;
    word_next = {word[35:0], word[39:36]};
    
    in3 = word[39:36];
    in2 = word[35:32];
    in1 = word[31:28];
    in0 = word[27:24];
    end
    
endmodule



