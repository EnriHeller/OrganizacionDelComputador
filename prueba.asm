global main

section .data
    algo    dq 7

section .text

main:

mov ebx, algo
mov eax, [ebx] ; carga el dato, no la dirección