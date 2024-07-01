module rotating_square
#(parameter base_counter=10_000_000)
(
    input wire clk,
    input wire reset, cw,
    output reg [3:0] an,        // enable, 1-out-of-4 asserted low
    output reg [7:0] in0,in1,in2,in3     // led segments
);

reg[23:0] counter=0; 
reg[3:0] turn =0; //12 turns since the square will rotate in 6 seven-segments
wire[23:0] counter_next;
reg[3:0] turn_next=0;
wire max_tick;
   

always @(posedge clk, posedge reset) begin
    if (reset) begin
        counter <= 0;
        turn <= 0;
    end else begin
        counter <= counter_next;
        turn <= turn_next;
    end
end

// next-state logic

    assign counter_next = (counter == base_counter-1) ? 24'd0 : counter + 1'b1;   
    assign max_tick = (counter == base_counter-1) ? 1'b1 : 1'b0;


always @* begin
turn_next=turn;
if(max_tick) begin
    if(cw) turn_next = (turn == 7) ?4'd0 : turn+1'b1; 
    else turn_next =(turn == 0)? 4'd7 : turn-1'b1;    
    end
end
// 2 MSBs of counter to control 4-to-1 multiplexing
// and to generate active-low enable signal
always @* begin
in0=8'hff; in1=8'hff; in2=8'hff; in3=8'hff;
    case (turn)
       
      4'd0: in3={1'b1,7'b0011100};
      4'd1: in2={1'b1,7'b0011100};
      4'd2: in1={1'b1,7'b0011100};
      4'd3: in0={1'b1,7'b0011100};
      
      4'd4: in0={1'b1,7'b1100010}; //Lower box
      4'd5: in1={1'b1,7'b1100010};
      4'd6: in2={1'b1,7'b1100010};
      4'd7: in3={1'b1,7'b1100010};


    endcase
end

endmodule
