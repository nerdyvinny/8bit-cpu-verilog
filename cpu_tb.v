`timescale 1ns/1ps

module cpu_tb;

    reg        clk   = 0;
    reg        reset = 1;
    wire [7:0] acc;
    wire [7:0] pc_addr;
    wire       halted;

    integer cycles = 0;

    cpu dut(.clk(clk), .reset(reset),
            .acc_out(acc), .pc_out(pc_addr), .halted(halted));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_tb);

        @(posedge clk); #1;
        reset = 0;

        // run until the program halts or we give up
        while (!halted && cycles < 500) begin
            @(posedge clk); #1;
            cycles = cycles + 1;
        end

        if (halted)
            $display("halted after %0d cycles", cycles);
        else
            $display("never halted something is wrong");

        $display("acc = %0d   expected 34", acc);
        $display("r1  = %0d   r2 = %0d",
                 dut.the_regfile.regs[1], dut.the_regfile.regs[2]);

        $finish;
    end

endmodule