@Codificar un programa en assembler ARM de 32 bits que recorra un vector de enteros y
@genere un nuevo vector formado por elementos que resultan de sumar pares de elementos del
@vector original. Ej. vector original {1,2,5,6}, vector nuevo {3,11}

.equ swi_open_file, 0x66
.equ swi_close_file, 0x68
.equ swi_print_str, 0x69
.equ swi_print_int, 0x6B
.equ swi_read_int, 0x6C
.equ swi_exit, 0x11

    .data
vector:
    .word 1,2,5,6
vector_out:
    .word 0,0
tam_vector:
    .word 4
eol:
    .asciz "\n"
    .align

    .text
    .global _start
    .global imprimir_numero   @ Asegurar que la función es visible

_start:
    LDR r0, =vector
    LDR r1, =vector_out
    LDR r2, =tam_vector
    LDR r2, [r2]      @ Cargar tamaño del vector

loop:
    MOV r5, #0
    LDR r3, [r0]     @ Cargar primer número
    ADD r5, r5, r3   @ Acumular en r5
    ADD r0, r0, #4
    LDR r3, [r0]     @ Cargar segundo número
    ADD r5, r5, r3   @ Sumarlo
    ADD r0, r0, #4
    STR r5, [r1]     @ Guardar resultado en vector_out
    ADD r1, r1, #4   @ Avanzar al siguiente espacio en vector_out
    SUBS r2, r2, #2  @ Decrementar tamaño en 2 (procesamos pares)
    B loop         @ Si aún hay más elementos, continuar

fin_vector:
    LDR r1, =vector_out   @ Apuntar al inicio de vector_out
    MOV r2, #2            @ Número de elementos a imprimir

loop_2:
    CMP r2, #0
    BEQ final             @ Si no quedan elementos, terminar
    BL imprimir_numero    @ Llamar a la función de impresión
    B loop_2

.align                  @ Asegurar alineación de función
imprimir_numero:
    STMFD sp!, {lr}      @ Guardar dirección de retorno en el stack
    MOV r3, r1           @ Guardar r1 temporalmente
    LDR r1, [r1]         @ Cargar el número a imprimir
    MOV r0, #0           @ stdout
    SWI swi_print_int    @ Imprimir número
    LDR r1, =eol         @ Cargar dirección de "\n"
    SWI swi_print_str    @ Imprimir nueva línea
    MOV r1, r3           @ Restaurar r1
    ADD r1, r1, #4       @ Avanzar a la siguiente posición en vector_out
    SUB r2, r2, #1       @ Decrementar contador de elementos a imprimir
    LDMFD sp!, {pc}      @ Restaurar pc y retornar

final:
    SWI swi_exit         @ Terminar programa
    .end
