.equ SWI_Print_Int, 0x6B
.equ SWI_Exit, 0x11
.equ SWI_Print_Str, 0x69

    .data
vector:
    .word 14, 10, 8, 5, 1, 0 @ El 0 marca el fin del vector
rotulo:
    .asciz "PAR "

    .text
    .global _start

_start:
    ldr r2, =vector     @ Cargar la dirección del vector en r2

imprimir_numeros:
    ldr r1, [r2]        @ Cargar el valor desde la dirección en r2
    cmp r1, #0          @ Verificar si es el fin del vector
    beq fin             @ Si es 0, finalizar

    @ Imprimir el número
    mov r0, r1          @ Cargar el número a imprimir en r0
    mov r1, #1          @ Número de descriptor de archivo (stdout)
    swi SWI_Print_Int   @ Llamada al sistema para imprimir el entero

    @ Verificar si es par
    bl es_par

    b imprimir_numeros  @ Volver al comienzo para el siguiente número

es_par:
    stmfd sp!, {r0, r1, r3, r4, r5, lr}  @ Guardar registros

    mov r5, #2          @ Divisor (2 para módulo)
    sdiv r3, r1, r5     @ r3 = r1 / 2 (cociente)
    mul r4, r3, r5      @ r4 = r3 * 2 (producto)
    sub r4, r1, r4      @ r4 = r1 - r4 (resto)
    cmp r4, #0          @ Comparar el resto con 0
    bne volver          @ Si no es 0, volver

    @ Imprimir "PAR"
    mov r0, #1          @ Número de descriptor de archivo (stdout)
    ldr r1, =rotulo     @ Cargar la dirección del string en r1
    swi SWI_Print_Str   @ Llamada al sistema para imprimir la cadena

volver:
    ldmfd sp!, {r0, r1, r3, r4, r5, pc}  @ Restaurar registros y regresar

fin:
    swi SWI_Exit        @ Salir del programa
    .end

