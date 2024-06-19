global main

;Realizar un programa en assembler Intel x86 que imprima por pantalla la siguiente
;frase: “El alumno [Nombre] [Apellido] de Padrón N° [Padrón] tiene [Edad] años para
;esto se debe solicitar previamente el ingreso por teclado de:
;Nombre y Apellido
;N° de Padrón
;Fecha de nacimiento 

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

%macro mScanf 0
    sub rsp, 8
    call sscanf
    add rsp, 8
%endmacro

%macro mLimpiarRegistros 0
    sub rsp,8
    call limpiarRegistros
    add rsp,8
%endmacro

%macro mCalcularEdad 0
    sub rsp,8
    call calcularEdad
    add rsp,8
%endmacro

extern puts
extern gets
extern printf
extern sscanf

section .data
    ;Formatos
    nombreApellidoFormat db    "%s %s",0
    padronFormat         db    "%li",0
    nacimientoFormat     db    "%li %li %li",0
    msgFinalFormat       db    "El alumno %s %s de Padrón N° %li tiene %li años",0

    ;Mensajes
    msjNombreApellido    db    "Ingrese nombre y apellido del alumno: ",0
    msjPadron            db    "Ingrese su padrón: (NNNNN)",0
    msjNacimiento        db    "Ingrese fecha de nacimiento: (DD MM AAAA) ",0
    msjDatosInvalidos    db    "Se detectaron datos invalidos, intente nuevamente.",0

    msjPrueba            db    "Todo bien.",0

    ;Datos
    añoActual            dq    2024

section .bss
    nombreApellido      resb  50
    padron              resb  20
    nacimiento          resb  20

    edad                resd  1
    nombre              resb  50
    apellido            resb  50
    diaNacimiento       resd  1
    mesNacimiento       resd  1
    añoNacimiento       resd  1


section .text

main:
    inputDatos:
    mPuts msjNombreApellido
    mGets nombreApellido

    mPuts msjPadron
    mGets padron

    mPuts msjNacimiento
    mGets nacimiento

    parseoDatos:
    
    ;Parseo nombre
    mov rdi, nombreApellido
    mov rsi, nombreApellidoFormat
    mov rdx, nombre
    mov rcx, apellido
    mScanf

    cmp rax, 2
    jne datosInvalidos

    mLimpiarRegistros

    ;Parseo padrón
    mov rdi, padron
    mov rsi, padronFormat
    mov rdx, padron
    mScanf

    cmp rax, 1
    jne datosInvalidos

    mLimpiarRegistros

    ;Parseo nacimiento
    mov rdi, nacimiento
    mov rsi, nacimientoFormat
    lea rdx, [diaNacimiento]
    lea rcx, [mesNacimiento]
    lea r8, [añoNacimiento]
    mScanf

    cmp rax, 3
    jne datosInvalidos

    mLimpiarRegistros

    mCalcularEdad

    mov rdi, msgFinalFormat
    mov rsi, nombre
    mov rdx, apellido
    mov rcx, [padron]
    mov r8, [edad]
    mPrintf

    ret

datosInvalidos:
    mPuts msjDatosInvalidos
    jmp inputDatos

limpiarRegistros:
    sub rdi, rdi
    sub rsi, rsi
    sub rdx, rdx
    sub rcx, rcx
    sub rax, rax
    ret

calcularEdad:
    mov eax, [añoActual]
    sub eax, [añoNacimiento]
    mov dword[edad], eax
    ret