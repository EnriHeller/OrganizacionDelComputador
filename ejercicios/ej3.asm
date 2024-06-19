;Realizar un programa que resuelva X Y teniendo en cuenta que tanto X e Y pueden
;ser positivos o negativos.
bits 64;
global main
extern puts
extern gets

%macro mPuts 1
    mov rdi, %1

    sub rsp, 8
    call puts
    add rsp, 8

%endmacro


%macro mGets 0
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro

section .data
    mensajeX db "Ingrese X", 0
    mensajeY db "Ingrese Y", 0

section .bss
    X resb 3
    Y resb 3

section .text

main:
    mPuts mensajeX
    mov rdi, X 
    mGets

    mPuts mensajeY
    mov rdi, Y
    mGets

    mov ecx, [Y]  ; Cantidad de veces que se desea repetir la instrucción
repetir:
    ; Tu instrucción aquí
    ; Por ejemplo:
    inc eax     ; Incrementar el valor en el registro eax
    
    loop repetir  ; Decrementa ecx y salta a 'repetir' si ecx no es cero


    ret
