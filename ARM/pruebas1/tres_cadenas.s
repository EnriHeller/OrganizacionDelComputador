    .data
p1:
    .asciz "hola "
p2:
    .asciz "extranio "
p3:
    .asciz "mundo "

    .text
    .global _start
_start:
    mov r0 ,#1

    ldr r1, =p1
    swi 0x69

    ldr r1, =p2
    swi 0x69
    
    ldr r1, =p3
    swi 0x69

    swi 0x11
    .end
