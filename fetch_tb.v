`timescale 1ns/1ps

module fetch_tb;

    reg        clk   = 0;
    reg        reset = 1;

    // addr is driven by the pc and read by the memory
    // neither end of this wire is us
    wire [7:0] addr;
    wire [7:0] instr;

    pc   the_pc  (.clk(clk), .reset(reset), .addr(addr));
    imem the_mem (.addr(addr), .instr(instr));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fetch.vcd");
        $dumpvars(0, fetch_tb);

        // one tick with reset high puts the counter at a known zero
        @(posedge clk); #1;
        reset = 0;

        $display("  addr | instr");
        $display("  -----+------");

        repeat (5) begin
            $display("   %3d |  0x%02h", addr, instr);
            @(posedge clk); #1;
        end

        $finish;
    end

endmodule