module pc(
    input            clk,
    input            reset,
    input            halt,
    input            load,
    input      [7:0] target,
    output reg [7:0] addr
);

    always @(posedge clk) begin
        if (reset)
            addr <= 8'd0;          // back to the start
        else if (halt)
            addr <= addr;          // freeze in place
        else if (load)
            addr <= target;        // jump
        else
            addr <= addr + 8'd1;   // next instruction
    end

endmodule