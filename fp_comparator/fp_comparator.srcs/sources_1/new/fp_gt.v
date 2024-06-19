

module fp_gt(
input wire [12:0] num1, num2,
output reg gt
    );
    wire sign1, sign2;
    wire [3:0] exp1, exp2;
    wire [7:0] mantissa1, mantissa2;
    
    assign sign1 = num1[12];
    assign sign2 = num2[12];
    assign exp1 = num1[11:8];
    assign exp2 = num2[11:8];
    assign mantissa1 = num1[7:0];
    assign mantissa2 = num2[7:0];
    
    always @*
    
        if(!sign1 && sign2) 
            gt = 1'b1;
        else
            begin
            if(exp1 > exp2)
                gt = 1'b1;
            else if (exp1 == exp2)
                begin
                if(mantissa1 > mantissa2)
                    gt = 1'b1;
                else 
                    gt = 1'b0;
                end
            else
            gt = 1'b0;
        end
endmodule
