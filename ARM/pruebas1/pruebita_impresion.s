.global _start

_start:
    LDR     r0, =string1
    SWI     0x02

    LDR     r0, =string2
    SWI     0x69

    B       end

string1:
    .asciz  "Printing with SWI 0x02\n"

string2:
    .asciz  "Printing with SWI 0x69\n"

end:
    B       end
