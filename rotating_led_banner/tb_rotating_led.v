module tb_rotating_led;

    reg clk;
    reg reset;
    reg [3:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9;
    wire [3:0] in0, in1, in2, in3;

    rotating_led_banner uut (
        .clk(clk),
        .reset(reset),
        .w0(w0),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .w4(w4),
        .w5(w5),
        .w6(w6),
        .w7(w7),
        .w8(w8),
        .w9(w9),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3)
    );

    // Clock generation
    always begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin
        reset = 1;
        w0 = 4'b0000;
        w1 = 4'b0001;
        w2 = 4'b0010;
        w3 = 4'b0011;
        w4 = 4'b0100;
        w5 = 4'b0101;
        w6 = 4'b0110;
        w7 = 4'b0111;
        w8 = 4'b1000;
        w9 = 4'b1001;
        #20;
        reset = 0;
        #500000;
        $finish;
    end


    always @(posedge clk) begin
        if (!reset) begin
            $display("Time: %0d | in3: %b | in2: %b | in1: %b | in0: %b", $time, in3, in2, in1, in0);
        end
    end

endmodule





