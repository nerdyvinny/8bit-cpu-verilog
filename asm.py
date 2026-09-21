
"""assembler for the 8 bit accumulator cpu"""

import sys

OPCODES = {
    "LDI":  0b000,
    "LD":   0b001,
    "ST":   0b010,
    "ADD":  0b011,
    "SUB":  0b100,
    "JMP":  0b101,
    "JZ":   0b110,
    "HALT": 0b111,
}

NO_OPERAND  = {"HALT"}
REG_OPERAND = {"LD", "ST", "ADD", "SUB"}


def strip_comment(line):
    return line.split(";")[0].strip()


def parse(lines):
    """first pass record where each label points and collect the instructions"""
    labels = {}
    program = []

    for lineno, raw in enumerate(lines, start=1):
        line = strip_comment(raw)
        if not line:
            continue

        if ":" in line:
            label, _, rest = line.partition(":")
            labels[label.strip().upper()] = len(program)
            line = rest.strip()
            if not line:
                continue

        program.append((lineno, line))

    return labels, program


def encode(line, labels, lineno):
    """second pass turn one instruction into one byte"""
    parts = line.replace(",", " ").split()
    mnemonic = parts[0].upper()

    if mnemonic not in OPCODES:
        raise ValueError(f"line {lineno}: unknown instruction {parts[0]}")

    opcode = OPCODES[mnemonic]

    if mnemonic in NO_OPERAND:
        operand = 0
    else:
        if len(parts) < 2:
            raise ValueError(f"line {lineno}: {mnemonic} needs an operand")

        token = parts[1]

        if mnemonic in REG_OPERAND:
            if not token.upper().startswith("R"):
                raise ValueError(f"line {lineno}: {mnemonic} needs a register like r3")
            operand = int(token[1:])
            if not 0 <= operand <= 7:
                raise ValueError(f"line {lineno}: no such register {token}")
        elif token.upper() in labels:
            operand = labels[token.upper()]
        else:
            operand = int(token, 0)

    if not 0 <= operand <= 31:
        raise ValueError(f"line {lineno}: operand {operand} does not fit in 5 bits")

    return (opcode << 5) | operand


def assemble(text):
    labels, program = parse(text.splitlines())
    return [encode(line, labels, lineno) for lineno, line in program]


def main():
    if len(sys.argv) != 3:
        print("usage: python asm.py input.asm output.hex")
        return 1

    with open(sys.argv[1]) as f:
        words = assemble(f.read())

    with open(sys.argv[2], "w") as f:
        for word in words:
            f.write(f"{word:02x}\n")

    print(f"assembled {len(words)} instructions into {sys.argv[2]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())