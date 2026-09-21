; fibonacci on the 8 bit accumulator cpu
; leaves the eighth fibonacci number in the accumulator

        LDI 0
        ST  r1          ; previous
        LDI 1
        ST  r2          ; current
        LDI 1
        ST  r5          ; a constant one to subtract with
        LDI 8
        ST  r4          ; loop counter

loop:   LD  r1
        ADD r2          ; acc = previous + current
        ST  r3
        LD  r2
        ST  r1          ; previous = current
        LD  r3
        ST  r2          ; current = next
        LD  r4
        SUB r5          ; counter = counter - 1
        ST  r4
        JZ  done
        JMP loop

done:   LD  r2
        HALT