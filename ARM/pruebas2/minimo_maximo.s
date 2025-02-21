@Escribir el código ARM que ejecutado bajo ARMSim# lea dos enteros desde un archivo e
@imprima el mínimo y el máximo respectivamente de la siguiente manera:
@Min: <mínimo>
@Max: <máximo>

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68
.equ SWI_Print_Str, 0x69
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Exit, 0x11

    .data
min_text:
    .asciz "Min: "
max_text:
    .asciz "Max: "
eol:
    .asciz "\n"
    .align
filename: 
    .asciz "dos_enteros.txt"

    .text
    .global _start

_start:
    ldr r0, =filename
    mov r1, #0 @lectura

    swi SWI_Open_File

    cmp r0, #0
    blt error_exit

    mov r4, r0 @me guardo handler en r4

    bl read_int
    mov r1, r0 @me guardo primer entero en r1

    mov r0, r4 @recargo handler en r0
    bl read_int
    mov r2, r0 @me guardo segundo entero en r2

    mov r0,r4 @restauro handler
    swi SWI_Close_File @cierro archivo

    sub r3, r1, r2 @ r3 = r1 - r2. Si r3 < 0 r2 = max y r1 = min

    @quiero minimo en r1 y maximo en r2
    cmp r3, #0 
    blgt rotar_numeros @si r3 > 0,  r1 = max y r2 = min -> tengo que rotar

    mov r6, r1

    mov r0, #1 @stdout
    ldr r1, =min_text
    swi SWI_Print_Str

    mov r1,r6
    swi SWI_Print_Int
    ldr r1, =eol
    swi SWI_Print_Str

    ldr r1, =max_text
    swi SWI_Print_Str
    mov r1,r2
    swi SWI_Print_Int

    swi SWI_Exit


rotar_numeros:
    stmfd sp!, {lr}

    mov r3, r1
    mov r1, r2
    mov r2, r3

    ldmfd sp!, {pc}

read_int:
    stmfd sp!, {lr}
    swi SWI_Read_Int

    cmp r0, #0
    blt error_exit

    ldmfd sp!, {pc}

error_exit:
    mov r0,r4 @restauro handler
    swi SWI_Close_File @cierro archivo
    swi SWI_Exit @salgo del programa
