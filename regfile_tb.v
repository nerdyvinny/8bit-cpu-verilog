`timescale 1ns/1ps

module regfile_tb;
    reg clk = 0;
    reg        we  = 0;
    reg  [2:0] waddr, raddr1, raddr2;
    reg  [7:0] wdata;
    wire [7:0] rdata1, rdata2;
    
    regfile dut(.clk(clk), .we(we), .waddr(waddr), .wdata(wdata),
            .raddr1(raddr1), .raddr2(raddr2),
            .rdata1(rdata1), .rdata2(rdata2));
    
    
    always #5 clk = ~clk;

    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, regfile_tb);

        we = 1; waddr = 3'd3; wdata = 8'd42;
        @(posedge clk); #1;

        waddr = 3'd5; wdata = 8'd7;
        @(posedge clk); #1;
        we = 0;

        raddr1 = 3'd3; raddr2 = 3'd5; #1;
        $display("r3 = %0d, r5 = %0d   (expect 42, 7)", rdata1, rdata2);

        we = 0; waddr = 3'd3; wdata = 8'd99;
        @(posedge clk); #1;
        raddr1 = 3'd3; #1;
        $display("r3 = %0d after blocked write   (expect 42, NOT 99)", rdata1);

        raddr1 = 3'd1; #1;
        $display("r1 = %0d   (expect 0, never written)", rdata1);

        $finish;
    end
endmodule