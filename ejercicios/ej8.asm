;Dada una matriz de 4x4 de números almacenados en BPF c/s de 16 bits, calcule la
;diagonal inversa e imprimirla por pantalla.

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

tabla   dw 1,2,3,4
        dw 5,6,7,8
        dw 9,10,11,12
        dw 13,14,15,16


formatResultado db "La diagonal inversa es: %li",10,0

longFila      db 8 ;longFila = longElemento (2) * cantidad de Columnas (4)
longElemento  db 2
resultado     dw 0

section .text
main:
    sub rax, rax
    sub rcx, rcx
    sub rsi, rsi
    
    mov rsi, 6 ;Inicializo el rsi en 6
    mov rcx, 4 ;Inicializo el rcx en 4, siendo esta la cantidad de filas a recorrer

    calcularDInversa:
    mov ax, [tabla + rsi]
    add [resultado], ax
    add rsi, 6
    loop calcularDInversa

    mov rdi, formatResultado
    mov rsi, [resultado]
    mPrintf

    ret
