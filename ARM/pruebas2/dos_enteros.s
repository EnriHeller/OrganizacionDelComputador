.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Exit, 0x11

    .data
filename: 
    .asciz "dos_enteros.txt"

    .text
    .global _start

_start:
    @ Carga el puntero al nombre del archivo en R0 y abre el archivo
    ldr r0, =filename
    mov r1, #0             @ Modo lectura
    swi SWI_Open_File      @ Abrir archivo
    cmp r0, #0             @ Verificar si la apertura fue exitosa
    blt error_exit         @ Si falla, salir

    mov r5, r0             @ Guardar el manejador de archivo en R5

    @ Leer el primer entero
    swi SWI_Read_Int       @ Leer entero (se almacena en R0)
    cmp r0, #0             @ Verificar si hubo un error
    blt error_exit         @ Si falla, salir
    mov r1, r0             @ Guardar el primer entero en R1

    @ Leer el segundo entero
    mov r0, r5             @ Restaurar el manejador de archivo
    swi SWI_Read_Int       @ Leer otro entero (se almacena en R0)
    cmp r0, #0             @ Verificar si hubo un error
    blt error_exit         @ Si falla, salir
    mov r2, r0             @ Guardar el segundo entero en R2

    @ Imprimir ambos enteros para verificar
    mov r0, r1             @ Primer entero en R0
    swi SWI_Print_Int      @ Imprimir el primer entero
    mov r0, r2             @ Segundo entero en R0
    swi SWI_Print_Int      @ Imprimir el segundo entero

    @ Cerrar el archivo
    mov r0, r5             @ Restaurar el manejador de archivo
    swi SWI_Close_File     @ Cerrar el archivo

    @ Salir del programa
    swi SWI_Exit

error_exit:
    mov r0, #-1            @ Código de error
    swi SWI_Exit           @ Salir con error
