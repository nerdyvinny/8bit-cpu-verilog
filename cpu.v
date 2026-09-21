module cpu(
    input        clk,
    input        reset,
    output [7:0] acc_out,
    output [7:0] pc_out,
    output       halted
);

    wire [7:0] instr;
    wire [7:0] pc_addr;
    wire [7:0] rdata1, rdata2;
    wire [7:0] alu_y;
    wire       alu_zero;

    wire       acc_we, reg_we, pc_load, halt;
    wire [1:0] acc_src;
    wire [2:0] alu_op;

    // split the instruction into its two fields
    wire [4:0] operand = instr[4:0];
    wire [2:0] rsel    = instr[2:0];

    // the accumulator is the one register every instruction touches
    reg  [7:0] acc;
    reg  [7:0] acc_next;
    wire       acc_zero = (acc == 8'd0);

    pc the_pc(
        .clk(clk), .reset(reset), .halt(halt),
        .load(pc_load), .target({3'b000, operand}),
        .addr(pc_addr)
    );

    imem the_imem(.addr(pc_addr), .instr(instr));

    control the_control(
        .instr(instr), .acc_zero(acc_zero),
        .acc_we(acc_we), .acc_src(acc_src), .alu_op(alu_op),
        .reg_we(reg_we), .pc_load(pc_load), .halt(halt)
    );

    regfile the_regfile(
        .clk(clk), .we(reg_we),
        .waddr(rsel), .wdata(acc),
        .raddr1(rsel), .raddr2(3'b000),
        .rdata1(rdata1), .rdata2(rdata2)
    );

    alu the_alu(
        .a(acc), .b(rdata1), .op(alu_op),
        .y(alu_y), .zero(alu_zero)
    );

    // pick where the next accumulator value comes from
    always @(*) begin
        case (acc_src)
            2'b00:   acc_next = alu_y;                // result of a calculation
            2'b01:   acc_next = {3'b000, operand};    // a number baked into the instruction
            2'b10:   acc_next = rdata1;               // a copy of a register
            default: acc_next = acc;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            acc <= 8'd0;
        else if (acc_we)
            acc <= acc_next;
    end

    assign acc_out = acc;
    assign pc_out  = pc_addr;
    assign halted  = halt;

endmodule