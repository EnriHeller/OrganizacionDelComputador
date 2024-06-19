;Realizar un programa que resuelva X Y teniendo en cuenta que tanto X e Y pueden
;ser positivos o negativos.
bits 64
global main
extern puts
extern gets
extern sscanf
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

%macro mScanNum 2
    mov rdi, %1
    mov rsi, numFormat
    mov rdx, %2

    sub rsp, 8
    call sscanf
    add rsp, 8
%endmacro

%macro mPrintf 0
    sub rsp, 8
    call printf
    add rsp, 8
%endmacro

section .data
    mensajeX db "Ingrese X", 0
    mensajeY db "Ingrese Y", 0

    numFormat   db "%li",0
    resFormat   db "Resultado: %li",10,0

section .bss
    Xs resb 20
    Ys resb 20

    Xn resq 1
    Yn resq 1

    res resq 1


section .text

main:
    mPuts mensajeX
    mGets Xs

    escanearX:
    mScanNum Xs, Xn

    mPuts mensajeY
    mGets Ys

    escanearY:
    mScanNum Ys, Yn

    mov cx, 2   
    mov rax, qword [Xn]
    mov qword [res], rax

    mov cx, [Yn]  ; Cantidad de veces que se desea repetir la instrucción

    sub rax, rax
    mov rax, 1

multSucesiva:
    imul rax, qword [Xn]
    mov qword [res], rax
    loop multSucesiva  ; Decrementa ecx y salta a 'repetir' si ecx no es cero

impresion:
    mov rdi, resFormat
    mov rsi, qword[res]

    mPrintf

    ret
