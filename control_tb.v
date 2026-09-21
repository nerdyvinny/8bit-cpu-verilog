`timescale 1ns/1ps

module control_tb;

    reg  [7:0] instr;
    reg        acc_zero;
    wire       acc_we, reg_we, pc_load, halt;
    wire [1:0] acc_src;
    wire [2:0] alu_op;

    control dut(.instr(instr), .acc_zero(acc_zero),
                .acc_we(acc_we), .acc_src(acc_src), .alu_op(alu_op),
                .reg_we(reg_we), .pc_load(pc_load), .halt(halt));

    initial begin
        $dumpfile("control.vcd");
        $dumpvars(0, control_tb);

        acc_zero = 1'b0;

        instr = 8'h05; #10;
        $display("LDI 5    acc_we=%b acc_src=%b reg_we=%b   expect 1 01 0", acc_we, acc_src, reg_we);

        instr = 8'h23; #10;
        $display("LD  r3   acc_we=%b acc_src=%b reg_we=%b   expect 1 10 0", acc_we, acc_src, reg_we);

        instr = 8'h43; #10;
        $display("ST  r3   acc_we=%b reg_we=%b              expect 0 1", acc_we, reg_we);

        instr = 8'h63; #10;
        $display("ADD r3   acc_we=%b alu_op=%b              expect 1 000", acc_we, alu_op);

        instr = 8'h83; #10;
        $display("SUB r3   acc_we=%b alu_op=%b              expect 1 001", acc_we, alu_op);

        instr = 8'hC8; #10;
        $display("JZ  8    acc_zero=0 pc_load=%b            expect 0", pc_load);

        acc_zero = 1'b1; #10;
        $display("JZ  8    acc_zero=1 pc_load=%b            expect 1", pc_load);

        instr = 8'hE0; #10;
        $display("HALT     halt=%b                          expect 1", halt);

        $finish;
    end

endmodule