module parking_lot(
    input clk, reset,
    input a, b,
    output reg exiting, entering
    );

    // State encoding
    localparam [1:0] 
        unblocked = 2'b00,
        b_blocked = 2'b01,
        a_blocked = 2'b10,
        both_blocked = 2'b11;

    reg [1:0] state_reg, state_next;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state_reg <= unblocked;
        else
            state_reg <= state_next;
    end

    // Next state logic and output logic
    always @* begin
        // Default values
        state_next = state_reg;
        exiting = 1'b0;
        entering = 1'b0;

        case (state_reg)
            unblocked: begin
                if (a & ~b) // 10
                    state_next = a_blocked;
                else if (~a & b) // 01
                    state_next = b_blocked;
            end
            
            a_blocked: begin
                if (a & b) // 11
                    state_next = both_blocked;
                else if (~a & ~b) begin // 00
                    state_next = unblocked;
                    exiting = 1'b1;
                end
            end
            
            both_blocked: begin
                if (~a & b) // 01
                    state_next = b_blocked;
                else if (a & ~b) // 10
                    state_next = a_blocked;
            end
            
            b_blocked: begin
                if (~a & ~b) begin // 00
                    state_next = unblocked;
                    entering = 1'b1;
                end else if (a & b) // 11
                    state_next = both_blocked;
            end
            
            default: state_next = unblocked;
        endcase
    end
endmodule

