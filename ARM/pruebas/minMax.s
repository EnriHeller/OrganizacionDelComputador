    @ constantes
    .equ SWI_Print_String, 0x02
    .equ SWI_Open_File, 0x66
    .equ SWI_Read_Int, 0x6C
    .equ SWI_Print_Int, 0x6B
    .equ SWI_Close_File, 0x68
    .equ SWI_Exit, 0x11
    .equ SWI_Print_Char, 0x00
    .equ SWI_Print_Str, 0x69
    .equ Stdout,1

    @ sección de datos
    .data
filename:
    .asciz "dos_enteros.txt"
min_header:
    .asciz "Min: "
mas_header:
    .asciz "Max: "
eol:
    .asciz "\n"
    .align
InFileHandle:
    .word 0

    @sección de código
    .text
    .global _start

_start:
    ldr r0, =filename @nombre de archivo de entrada
    mov r1, #0 @abrir para lectura
    swi SWI_Open_File @abrir el archivo
    bcs InFileError @Chequeo si hubo error
    ldr r1, =InFileHandle @Cargo dirección donde almacene el handler
    str r0, [r1] @almaceno handler

    bl read_int 
    mov r2, r0
    bl read_int
    mov r3, r0

    cmp r2, r3
    blt print_result
    mov r1, r2
    mov r2, r3
    mov r3, r1

print_result:
    ldr r0, =Stdout
    ldr r1, =min_header
    swi SWI_Print_Str
    mov r1, r2
    bl print_r1_int

    ldr r0, = Stdout
    ldr r1, =max_header
    swi SWI_Print_Str
    mov r1, r3
    bl print_r1_int

@Leo entero desde archivo
read_int:
    stmfd sp!, {lr}
    ldr r0, =InFileHandle
    ldr r0, [r0]
    swi SWI_Read_Int
    ldmfd sp!, {pc}

print_r1_int:
    stmfd sp!, {r0,r1, lr}
    ldr r0, =Stdout
    swi SWI_Print_Int
    ldr r1, =eol
    swi SWI_Print_Str
    ldmfd sp!, {r0,r1, pc}

InFileError:
EofReached:
    swi SWI_Exit
    .end 