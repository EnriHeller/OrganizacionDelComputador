;Dada una matriz de 3x3 de números almacenados en BPF c/s de 16 bits, 
;calcule la traza e imprimirla por pantalla.

global main

extern puts
extern gets
extern printf

%macro mPuts 1
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro

%macro mGets 1
    mov rdi, %1
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro

%macro mPrintf 0
    sub rsp, 8
    call printf
    add rsp, 8
%endmacro

section .data

tabla   dw 1,2,3 
        dw 4,5,6
        dw 7,8,9

formatResultado db "La traza es: %li",10,0

longFila      db 6 ;longFila = longElemento (2) * cantidad de Columnas (3)
longElemento  db 2
resultado     dw 0

section .text
main:
    sub rax, rax
    sub rcx, rcx
    sub rsi, rsi
    
    mov rsi, 0 ;Inicializo el rsi en 0
    mov rcx, 3 ;Inicializo el rcx en 3, siendo esta la cantidad de filas a recorrer

    calcularTraza:
    mov ax, [tabla + rsi]
    add [resultado], ax
    add rsi, 8
    loop calcularTraza

    mov rdi, formatResultado
    mov rsi, [resultado]
    mPrintf

    ret
