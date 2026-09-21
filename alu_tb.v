`timescale 1ns/1ps
module alu_tb;
    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] y;
    wire zero;

    alu dut (.a(a), .b(b), .op(op), .y(y), .zero(zero));

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        a = 8'd10; b = 8'd5;  op = 3'b000; #10;
        $display("10 + 5  = %0d   (zero=%b)", y, zero);

        a = 8'd10; b = 8'd5;  op = 3'b001; #10;
        $display("10 - 5  = %0d    (zero=%b)", y, zero);

        a = 8'd7;  b = 8'd7;  op = 3'b001; #10;
        $display("7 - 7   = %0d    (zero=%b)  <-- zero flag set!", y, zero);

        a = 8'd12; b = 8'd10; op = 3'b010; #10;
        $display("12 & 10 = %0d", y);

        a = 8'd12; b = 8'd10; op = 3'b011; #10;
        $display("12 | 10 = %0d", y);

        a = 8'd12; b = 8'd10; op = 3'b100; #10;
        $display("12 ^ 10 = %0d", y);

        $finish;
    end
endmodule 