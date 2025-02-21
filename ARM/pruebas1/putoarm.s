@leer en un archivo numeros enteros e imprimir por salida estándar la productoria de aquellos números que sean positivos 

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68

.equ SWI_Print_Str, 0x69

.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C

.equ SWI_Exit, 0x11

    .data
filename: 
    .asciz "enteros.txt"
eol:
    .asciz "\n"
    .align
res:
    .word 1
InFileHandle:
    .word 0

    .text
    .global _start

_start:
    @abrir el archivo
    ldr r0, =filename
    mov r1, #0 @modo lectura
    swi SWI_Open_File
    bcs InFileError @ver esto
    ldr r1, =InFileHandle
    str r0, [r1] @guardo lo de r0 tal que ahi me queda el handle tras hacer open_file

    @ inicializar productoria en r1
    ldr r1, =res
    ldr r1, [r1]

read_loop:
    @guardo entero en r0
    ldr r0, =InFileHandle @para leerlo cargo dirección del handle
    ldr r0, [r0] @lo leo con corchetes
    swi SWI_Read_Int

    bcs EofReached @si me salta un carry termine el archivo

    @a partir de acá el entero está en r0

    @Si es negativo, vuelvo al ciclo
    cmp r0, #0
    blt read_loop

    @Si el numero llego hasta acá lo añado a la productoria
    ldr r3, =res @en r3 me guardo la dirección
    str r1, [r3] @en r1 me guardo el contenido
    mul r1, r1,r0 @actualizo el contenido en r1
    
    str r1, [r3] @ guardo el contenido de r1 en la dirección de r3
    b read_loop

InFileError:
    @ manejar el error de apertura de archivo
    mov r0, #1
    swi SWI_Exit

EofReached:
    @ cerrar archivo
    ldr r0, =InFileHandle
    ldr r0, [r0]
    swi SWI_Close_File

    @ imprimir el resultado
    mov r0, #1
    ldr r1, =res
    ldr r1, [r1]
    swi SWI_Print_Int

    swi SWI_Exit
    .end

