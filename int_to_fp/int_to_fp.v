module int_to_fp(
input wire [7:0] num_int,
output reg [12:0] fp
    );
    integer i;
    reg done;
    always @*
    begin
    done = 1'b0; 
    fp[12]=num_int[7];
    for(i = 7; i >= 0; i = i-1)
    begin 
        if(num_int[i] && !done) begin 
        fp[11:8] = i + 7;
        fp[7:0] = num_int << (7 - i);
        done = 1'b1;
        end
    end
    end
endmodule
