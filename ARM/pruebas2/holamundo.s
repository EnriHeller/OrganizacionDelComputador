.equ SWI_Print_Str, 0x02
.equ SWI_Exit, 0x11

    .data
mensaje:
    .asciz "Hola Mundo"

    .text
    .global _start
_start:
    ldr r0, =mensaje
    swi SWI_Print_Str
    swi SWI_Exit
    .end
