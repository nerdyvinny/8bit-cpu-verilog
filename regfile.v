module regfile(
    input            clk,
    input            we,
    input      [2:0] waddr,
    input      [7:0] wdata,
    input      [2:0] raddr1,
    input      [2:0] raddr2,
    output     [7:0] rdata1,
    output     [7:0] rdata2
);
reg [7:0] regs [0:7];
integer i;
initial begin
    for (i = 0; i < 8; i = i + 1)
        regs[i] = 8'b0;
end
assign rdata1 = regs[raddr1];
assign rdata2 = regs[raddr2];

always @(posedge clk) begin
        if (we)
            regs[waddr] <= wdata;
    end
endmodule