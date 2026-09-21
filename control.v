module control(
    input      [7:0] instr,
    input            acc_zero,
    output reg       acc_we,
    output reg [1:0] acc_src,
    output reg [2:0] alu_op,
    output reg       reg_we,
    output reg       pc_load,
    output reg       halt
);

    // top three bits pick the instruction
    wire [2:0] opcode = instr[7:5];

    always @(*) begin
        // safe defaults every signal gets a value before the case runs
        acc_we  = 1'b0;
        acc_src = 2'b00;
        alu_op  = 3'b000;
        reg_we  = 1'b0;
        pc_load = 1'b0;
        halt    = 1'b0;

        case (opcode)
            3'b000: begin              // LDI put the operand straight into acc
                acc_we  = 1'b1;
                acc_src = 2'b01;
            end
            3'b001: begin              // LD copy a register into acc
                acc_we  = 1'b1;
                acc_src = 2'b10;
            end
            3'b010: begin              // ST copy acc into a register
                reg_we  = 1'b1;
            end
            3'b011: begin              // ADD acc = acc + reg
                acc_we  = 1'b1;
                acc_src = 2'b00;
                alu_op  = 3'b000;
            end
            3'b100: begin              // SUB acc = acc - reg
                acc_we  = 1'b1;
                acc_src = 2'b00;
                alu_op  = 3'b001;
            end
            3'b101: begin              // JMP always take the branch
                pc_load = 1'b1;
            end
            3'b110: begin              // JZ take it only when acc is zero
                pc_load = acc_zero;
            end
            3'b111: begin              // HALT freeze the machine
                halt    = 1'b1;
            end
        endcase
    end

endmodule