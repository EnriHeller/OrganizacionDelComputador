;Realizar un programa en assembler Intel x86 que imprima por pantalla la siguiente
;frase: “El alumno [Nombre] [Apellido] de Padrón N° [Padrón] tiene [Edad] años para
;esto se debe solicitar previamente el ingreso por teclado de:
;Nombre y Apellido
;N° de Padrón
;Fecha de nacimiento 

global main
extern puts
extern gets
extern    printf
extern    sscanf


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

%macro mSscanf 0
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
    msjNombre db "Decime el nombre", 0
    msjPadron db "Decime el padron", 0
    msjNacimiento db "Decime tu fecha de nacimiento", 0 ;dd/mm/aaaa
    msjFinal db "El alumno %s de Padrón N° %s tiene %li años", 0
    formatNacimiento    db    "%li/%li/%li", 0
    anoActual dw   2024


section .bss
    nombre  resb 100
    padron  resb 100
    nacimiento  resb 100
    dia         resq 1
    mes         resq 1
    ano         resq 1
    edad        resq 1

section .text

main:

    mPuts msjNombre
    mov rdi, nombre
    mGets


    mPuts  msjPadron
    mov rdi, padron
    mGets

    mPuts msjNacimiento
    mov rdi, nacimiento
    mGets

    mov     rdi, nacimiento
    mov     rsi, formatNacimiento
    mov     rdx, dia
    mov     rcx, ano
    mov     r8, mes
    mSscanf

    mov r9, [anoActual]
    sub r9, [ano]

    mov [edad],r9

    mov rdi, msjFinal
    mov rsi, nombre
    mov rdx, padron
    mov rcx, [edad]
    mPrintf


    ret