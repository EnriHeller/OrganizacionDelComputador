@Codificar un programa en assembler ARM de 32 bits que lea desde un archivo números
@enteros e imprima por la salida estándar la productoria de aquellos números que sean positivos

.equ swi_open_file, 0x66
.equ swi_close_file, 0x68
.equ swi_print_str, 0x69
.equ swi_print_int, 0x6B
.equ swi_read_int, 0x6C
.equ swi_exit, 0x11

    .data
file_name:
    .asciz "archivo.txt"
handler:
    .skip 4

    .text
    .global _start

_start:
    ldr r0, =file_name
    mov r1, #0 @stdout
    swi swi_open_file
    bcs error_exit

    ldr r2, =handler
    str r0,[r2]

    mov r5,#1
loop:
    ldr r0, =handler
    ldr r0,[r0]
    swi swi_read_int
    bcs fin_de_archivo
    cmp r0, #0
    bmi loop
    mul r5,r0,r5
    b loop

fin_de_archivo:
    ldr r0, =handler
    ldr r0, [r0]
    swi swi_close_file
    mov r1,r5
    mov r0, #0
    swi swi_print_int
error_exit:
    swi swi_exit
    .end
