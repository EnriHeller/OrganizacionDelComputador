    @ constantes
    .equ SWI_Open_File, 0x66
    .equ SWI_Read_Int, 0x6C
    .equ SWI_Print_Int, 0x6B
    .equ SWI_Close_File, 0x68
    .equ SWI_Exit, 0x11

    @ sección de datos
    .data
filename:
    .asciz "entero.txt"

    @sección de código
    .text

    .global _start

_start:
    @Carga el puntero al string en el registro r0
    ldr r0, =filename
    mov r1, #0 @abrir para lectura
    swi SWI_Open_File @abrir el archivo

    @ copia el manejador de archivo de r0 a r5
    mov r5, r0

    @leo un entero desde un archivo:
    @ Precondición en r0: Cargar el manejador de archivos
    @ Poscondición en : El entero leido desde el archivo 
    swi SWI_Read_Int

    @Muestro el entero por pantalla:
    @ Precondición en r0: Cargar donde mostrar (1 = stdout)
    @ Precondición en r1: Entero a mostrar

    mov r1, r0
    mov r0 #1 @Cargo el r0 con el 1 para que muestre salida por stdout
    swi SWI_Print_Int


    @cerrar el archivo, which looks for
    @Precondición r0: Cargar el manejador de archivos (lo tenia en r5)
    mov r0, r5
    swi SWI_Close_File

    @Solicito a ARMSim que salga del problema
    swi SWI_Exit
    .end 

