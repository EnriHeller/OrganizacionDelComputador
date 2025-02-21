@Mostrar elementos de un vector utilizando direccionamiento por registro indirecto
@Escribir el código ARM que ejecutado bajo ARMSim# imprima los valores de un vector de
@cuatro enteros definidos en memoria, recorriendo el vector mediante una subrutina que utilice
@direccionamiento por registro indirecto.

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0X68
.equ SWI_Print_Str, 0x69
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Exit, 0x11

    .data
vector:
    .word 3,6,2,1
eol:
    .asciz "\n"
    .align

    .text
    .global _start

_start:
    ldr r3, =vector
    mov r0, #1
    mov r4, #4

loop:
    bl imprimir_numero
    add r3, r3, #4
    subs r4,r4, #1
    bne loop
    swi SWI_Exit

imprimir_numero:
    stmfd sp!, {lr}
    ldr r1, [r3]
    swi SWI_Print_Int
    ldr r1, =eol
    swi SWI_Print_Str

    ldmfd sp!, {pc}



