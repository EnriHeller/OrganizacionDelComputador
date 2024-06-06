global main
extern puts

section .data
    posx    dd     02 //dd -> double word = 4bytes
    posy    dd     03
    longfil dd     16 //longitud Fila = longitudElemento(4)*cantidad Columnas(4)
    longele dd     04

section .bss
    matriz times 12 resb //filas * columnas

section .text

main:
    mov rdi, mensaje
    sub rsp, 8
    call puts
    add rsp, 8

    ret
