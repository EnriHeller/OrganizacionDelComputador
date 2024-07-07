    @ constantes
    .equ SWI_Exit, 0x11
    .equ SWI_Open_File, 0x66
    .equ SWI_Close_File, 0x68
    .equ SWI_Print_Int, 0x6B
    .equ SWI_Read_Int, 0x6C

    @ sección de datos
    .data

filename:
    .asciz "entero.txt"

    @sección de código
    .text
    .global _start

_start:
    ldr r0, =filename
    mov r1, #0 @ 0 es abrir para lectura, 1 es escritura
    swi SWI_Open_File @abre el archivo

    @ copia el manejador de archivo de r0 a r5. me lo guardo porque despues lo necesito para el close.
    mov r5, r0

    @leo un entero desde un archivo:
    @ Precondición en r0: Cargar el manejador de archivos
    @ Poscondición en r0: El entero leido desde el archivo 
    swi SWI_Read_Int

    @Me guardo en r2 el entero
    mov r2, r0

    @cerrar el archivo
    @Precondición r0: Cargar el manejador de archivos (lo tenia en r5)
    mov r0, r5
    swi SWI_Close_File

    @Chequeo si el entero leído es menor a 0. seteo flags con compare.
    cmp r2, #0

    @ si es -> sobreescribo el entero con su negación aritmetica
    mov r3, #0
    submi r2, r3, r2 @ esto solamente se realiza si el flag de negativo esta en 1
    
    @Esto hace 0 - (-n) = n. Por eso me da el valor absoluto.

    @muestro el entero
    mov r0, #1
    mov r1, r2

    swi SWI_Print_Int

    @Solicito a ARMSim que salga del problema
    swi SWI_Exit
    .end 

