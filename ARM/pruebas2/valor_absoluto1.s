@Práctica 7: Cálculo de valor absoluto con instrucciones condicionales
@Escribir el código ARM que ejecutado bajo ARMSim# lea un entero desde un archivo e imprima
@el valor absoluto del entero. Utilizar instrucciones ejecutadas condicionalmente y no utilizar
@bifurcaciones condicionales.

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68
.equ SWI_Print_Str, 0x69
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Exit, 0x11

    .data
fileName:
    .asciz "entero.txt"

    .text
    .global _start
_start:
    ldr r0, =fileName    @ Cargar dirección del nombre del archivo
    mov r1, #0           @ Modo lectura
    swi SWI_Open_File    @ Abrir archivo

    mov r4, r0           @ Guardar el descriptor del archivo en r4

    swi SWI_Read_Int     @ Leer entero del archivo

    mov r1, r0           @ Guardar el número leído en r1

    mov r0, r4           @ Restaurar el descriptor del archivo
    swi SWI_Close_File   @ Cerrar el archivo

    @ Calcular valor absoluto
    cmp r1, #0           @ Comparar r1 con 0 (configura los flags)
    rsbmi r1, r1, #0     @ Si r1 es negativo, convertir a positivo

    @ Imprimir el valor absoluto
    mov r0, #1           @ stdout
    swi SWI_Print_Int

    @ Salir
exit:
    swi SWI_Exit

error_exit:
    mov r0, #1           @ Código de error
    swi SWI_Exit
