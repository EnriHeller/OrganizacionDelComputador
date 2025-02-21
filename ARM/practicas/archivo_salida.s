@codicar un programa en ARM de 32 bits que recorra un vector de
@enteros y genere un archivo de salida con el resultado de aplicar la
@funcion AND en cada uno de los elementos del vector original contra una
@constante.

.equ SWI_Print_Int, 0x6B
.equ SWI_Exit, 0x11
.equ SWI_Print_Str, 0x69
.equ SWI_Open_File, 0x66
.equ SWI_Write, 0x05
.equ SWI_Close_File, 0x68

    .data
array_origen:
    .word 1,2,5,6
array_length:
    .word 4
filename:
    .asciz "resultado.txt"
eol:
    .asciz "\n"
    .align

outFileHandle:
    .skip 4

.text
.global _start


_start:
    ldr r0, =filename @nombre del archivo de salida
    mov r1, #1 @modo: salida

    swi SWI_Open_File @abre archivo
    bcs outFileError @chequea si hubo error
    ldr r1, =outFileHandle @carga dirección donde almacenar el handler
    str r0, [r1]
    ldr r1, =array_origen
    ldr r2, =array_length
    ldr r2, [r2]

loop:
    ldr r4, [r1]
    bl imprimir
    add r1, r1, #4
    subs r2, r2, #1
    cmp r2, #0
    bne loop
    b exit

imprimir:
    stmfd sp!, {r1,r2,lr}
    and r4, r4, #1 @Hago and contra una constante
    ldr r0, =outFileHandle
    ldr r0, [r0]
    mov r1, r4
    swi SWI_Print_Int @ Escribir el número en el archivo
    ldr r1, =eol @ Cargar el salto de línea
    swi SWI_Print_Str @ Escribir el salto de línea en el archivo
    ldmfd sp!, {r1,r2,pc}
    outFileError: @sale del programa con error

exit:
    ldr r0, =filename
    swi SWI_Close_File @cierra el archivo de salida
    swi SWI_Exit
    .end