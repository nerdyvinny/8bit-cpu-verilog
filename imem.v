module imem(
    input  [7:0] addr,
    output [7:0] instr
);

    // 256 boxes each holding one 8 bit instruction
    reg [7:0] mem [0:255];

    // load the program from a text file when sim starts
    initial $readmemh("program.hex", mem);

    
    assign instr = mem[addr];

endmodule