@ Práctica 5. Negar enteros desde archivo

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Print_Str, 0x69
.equ SWI_Exit, 0x11

    .data
filename:
    .asciz "dos_enteros.txt"
eol:
    .asciz "\n"
    .align

    .text
    .global _start

_start:
    ldr r0, =filename
    mov r1, #0             @ Abrir en modo lectura
    swi SWI_Open_File
    mov r5, r0             @ Guardar manejador de archivo

    swi SWI_Read_Int        @ Leer el primer entero
    mov r2, r0             @ Guardar el primer entero en R2
    mvn r3, r0             @ Aplicar NOT
    add r3, r3, #1         @ Ajustar para obtener -N

    mov r0, r5             @ Restaurar manejador
    swi SWI_Read_Int        @ Leer el segundo entero
    mov r4, r0             @ Guardar el segundo entero en R4
    mvn r6, r0             @ Aplicar NOT
    add r6, r6, #1         @ Ajustar para obtener -N

    mov r1, r2             @ Pasar el primer entero
    bl imprimir_numero

    mov r1, r3             @ Pasar el complemento del primer entero
    bl imprimir_numero

    mov r1, r4             @ Pasar el segundo entero
    bl imprimir_numero

    mov r1, r6             @ Pasar el complemento del segundo entero
    bl imprimir_numero

    mov r0, r5             @ Restaurar manejador
    swi SWI_Close_File     @ Cerrar archivo

    swi SWI_Exit           @ Salir del programa

imprimir_numero:
    stmfd sp!, {r0,r1,lr}  @ Guardar registros
    mov r0, #1             @ stdout
    swi SWI_Print_Int      @ Imprimir número

    ldr r1, =eol           @ Cargar salto de línea
    swi SWI_Print_Str      @ Imprimir salto de línea

    ldmfd sp!, {r0,r1,pc}  @ Restaurar registros y regresar



