    .equ SWI_Print_Int 0x6B
    .equ SWI_Read_Int 0x6C
    .equ SWI_Open_File 0x66
    .equ SWI_Close_File 0x68
    .equ SWI_Exit 0x11

    .data
filename: 
    .asciz "entero.txt"

    .text
    .global _start

_start:

    bl read_int

    swi SWI_Exit
    .end

read_int:
    strmfd !sp, {r0,lr}

    ldr r0, =filename
    mov r1, #0
    swi SWI_Open_File 

    @en r0 recibo el handler
    mov r5, r0

    swi SWI_Read_Int
    @en r0 el read_int deja resultado
    mov r1, r0
    mov r0, #1 @modo stdout para la salida

    swi SWI_Print_Int

    @para cerrar el archivo, muevo el handler en el r0:
    mov r0, r5
    swi SWI_Close_File

    ldmfd !sp, {r0, pc}