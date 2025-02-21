@Práctica 4. Entrada y Salida de entero
@Escribir el código ARM que ejecutado bajo ARMSim# que lea un entero desde un archivo e
@imprima el mismo entero por pantalla.

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Exit, 0x11

    .data
filename: 
    .asciz "entero.txt"

    .text
    .global _start

_start:
    @Carga el puntero al string en el registro r0
    ldr r0, =filename
    mov r1, #0 @abrir para lectura
    swi SWI_Open_File @abrir el archivo

    @Queda el manejador de archivos en r0

    mov r5, r0 @conservo r5 en r0 
    @Para leerlo, uso el manejador en r0 y obtengo el entero 
    swi SWI_Read_Int
    mov r1,r0
    mov r0, #1
    swi SWI_Print_Int

    mov r0, r5
    swi SWI_Close_File

    swi SWI_Exit