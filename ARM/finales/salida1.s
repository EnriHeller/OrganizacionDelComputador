@Codificar un programa en assembler ARM de 32 bits que recorra un vector de enteros y
@genere un archivo de salida con el resultado de aplicar la función OR en cada uno de los elementos
@del vector original contra una constante

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68
.equ SWI_Print_Str, 0x69
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Exit, 0x11

    .data
vector:
    .word 3,5,8,1
filename:
    .asciz "resultado.txt"

eol:
    .asciz "\n"
    .align

handler:
    .skip 4

    .text
    .global _start

_start:
    ldr r0, =filename
    mov r1, #1 @salida
    mov r5, #5
    mov r4, #4

    swi SWI_Open_File
    bcs exit_error

    ldr r3, =handler
    str r0, [r3]

    ldr r1, =vector

loop:
    bl imprimir_numero
    add r1,r1, #4
    subs r4,r4, #1
    bne loop

    ldr r0, =handler
    ldr r0, [r0]

    swi SWI_Close_File
    swi SWI_Exit

imprimir_numero:
    stmfd sp!, {r1, lr}

    ldr r0, =handler
    ldr r0, [r0]

    ldr r1, [r1]
    orr r1, r1, r5
    swi SWI_Print_Int

    ldr r1, =eol
    swi SWI_Print_Str

    ldmfd sp!, {r1, pc}

exit_error:
    ldr r0, =handler
    ldr r0, [r0]
    swi SWI_Close_File
    swi SWI_Exit

