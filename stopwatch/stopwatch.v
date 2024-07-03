module stopwatch(
    input wire clk,
    input wire go, //start
    input wire clr, //reset
    output wire [3:0] d3, d2, d1, d0,
    output reg [3:0] an,        // enable, 1-out-of-4 asserted low
    output reg [6:0] sseg,      // seven-segment display segments
    output reg dp               // decimal point
);

// declaration
localparam DVSR = 5000000;

reg [22:0] counter;
wire [22:0] counter_next;
reg [3:0] d3_reg, d2_reg, d1_reg, d0_reg;
reg [3:0] hex_in;
wire [3:0] d3_next, d2_next, d1_next, d0_next;
wire d3_en, d1_en, d2_en, d0_en;
wire max_tick, d0_tick, d1_tick, d2_tick;

// body
// register
always @(posedge clk)
begin
if(clr)
    begin
    counter <=0; 
    d3_reg <= 0;
    d2_reg <= 0;
    d1_reg <= 0;
    d0_reg <= 0;
    end
else if(go) begin
    counter <= counter_next;
    d3_reg <= d3_next;
    d2_reg <= d2_next;
    d1_reg <= d1_next;
    d0_reg <= d0_next;
end
end

// next-state logic
// 0.1 sec tick generator: mod-5000000
assign counter_next = (counter == DVSR) ? 4'b0 : counter + 1;
assign max_tick = (counter == DVSR) ? 1'b1 : 1'b0;

// 0.1 sec counter
assign d0_en = max_tick;
assign d0_next = (d0_en && d0_reg == 9) ? 4'b0 :
                 (d0_en) ? d0_reg + 1 : d0_reg;
assign d0_tick = (d0_reg == 9) ? 1'b1 : 1'b0;

// 1 sec counter
assign d1_en = max_tick & d0_tick;
assign d1_next = (d1_en && d1_reg == 9) ? 4'b0 :
                 (d1_en) ? d1_reg + 1 :
                 d1_reg;
assign d1_tick = (d1_reg == 9) ? 1'b1 : 1'b0;

// 10 sec counter
assign d2_en = max_tick & d0_tick & d1_tick;
assign d2_next = (d2_en && d2_reg == 9) ? 4'b0 :
                 (d2_en) ? d2_reg + 1 :
                 d2_reg;
assign d2_tick = (d2_reg == 9) ? 1'b1 : 1'b0;

//minutes counter
assign d3_en = max_tick & d0_tick & d1_tick & d2_tick;
assign d3_next = (d3_en && d3_reg == 5) ? 4'b0 :
                 (d3_en) ? d3_reg + 1 :
                 d3_reg;

// output logic
assign d0 = d0_reg;
assign d1 = d1_reg;
assign d2 = d2_reg;
assign d3 = d3_reg;


// led multiplexing circuit
reg [17:0] c_reg;
wire [17:0] c_next;

always @(posedge clk, posedge clr) 
if(clr) c_reg <= 0;
else c_reg <= c_next;

assign c_next = c_reg + 1;

always @*
case (c_reg[17:16])
2'b00: 
    begin
    an = 4'b1110;
    hex_in = d0_reg;
    dp = 1'b1;
    end
2'b01: 
    begin
    an = 4'b1101;
    hex_in = d1_reg;
    dp = 1'b1;
    end
2'b10: 
    begin
    an = 4'b1011;
    hex_in = d2_reg;
    dp = 1'b1;
    end
2'b11: 
    begin
    an = 4'b0111;
    hex_in = d3_reg;
    dp = 1'b1;
    end
endcase

always @* begin 
case(hex_in)
   4'd0 : sseg = 7'b1000000;
   4'd1 : sseg = 7'b1111001;
   4'd2 : sseg = 7'b0100100;
   4'd3 : sseg = 7'b0110000;
   4'd4 : sseg = 7'b0011001;
   4'd5 : sseg = 7'b0010010;
   4'd6 : sseg = 7'b0000010;
   4'd7 : sseg = 7'b1111000;
   4'd8 : sseg = 7'b0000000;
   4'd9 : sseg = 7'b0010000;
   default : sseg = 7'b0111111; 
  endcase

end

endmodule



