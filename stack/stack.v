module stack
(
    input wire clk, reset,
    input wire pop, push,
    input wire [7:0] push_data,
    output wire empty, full,
    output wire [7:0] pop_data
);

// signal declaration
reg [7:0] stack [15:0];  // register array
reg [3:0] ptr_reg, ptr_next;
reg full_reg, empty_reg, full_next, empty_next;
wire push_en;

// body
// register file push operation
always @(posedge clk)
    if (push_en)
        stack[ptr_reg] <= push_data;

// register file pop operation
assign pop_data = stack[ptr_reg];

assign push_en = push & ~full_reg;

// lifo control logic

always @(posedge clk, posedge reset)
    if (reset)
    begin
        ptr_reg <= 0;
        full_reg <= 1'b0;
        empty_reg <= 1'b1;
    end
    else
    begin
        ptr_reg <= ptr_next;
        full_reg <= full_next;
        empty_reg <= empty_next;
    end

// next-state logic 
always @*
begin

    ptr_next = ptr_reg;
    full_next = full_reg;
    empty_next = empty_reg;
    
    case ({push, pop})
        // 2'b00: // no op
        2'b01: // pop
            if (~empty_reg) // not empty
            begin
                ptr_next = ptr_reg -1;
                full_next = 1'b0;
                if (ptr_next == 0)
                    empty_next = 1'b1;
                else empty_next = 1'b0;
            end
        2'b10: // push
            if (~full_reg) // not full
            begin
                ptr_next = ptr_reg +1;
                empty_next = 1'b0;
                if (ptr_next == 15)
                    full_next = 1'b1;
                else full_next = 1'b0;
            end
    endcase
end

// output
assign full = full_reg;
assign empty = empty_reg;

endmodule

