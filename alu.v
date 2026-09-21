module alu(
    input [7:0] a,
    input [7:0] b,
    input [2:0] op,
    output reg [7:0] y,
    output zero
);

always @(*) begin
    case (op)
        3'b000: y = a + b;   // add
        3'b001: y = a - b;   // sub
        3'b010: y = a & b;   // and
        3'b011: y = a | b;   // or
        3'b100: y = a ^ b;   // xor
        default: y = 8'b0;
    endcase
end

assign zero = (y == 8'b0);
endmodule