;Realizar una rutina interna que reciba como parámetro un campo PACK en formato
;de Decimal Empaquetado de 2 bytes y devuelva en un campo RESULT en formato
;carácter de 1 byte, indicando una ‘S’ en caso que sea un empaquetado válido, y en
;caso contrario una ‘N’

global main

extern puts
extern gets

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

section .data
    msjInput    db "Ingrese un Decimal Empaquetado de 2 bytes.",0
    letrasSigno db  "C","A","F","E","B","D",0    

section .bss
    ;Reservo un espacio de mas porque habrá un byte para el 0 
    ;y no quiero que se sobrescriba con lo de abajo:

    RESULT  resb 2 
    PACK    resb 3

section .text
main:

    sub rsp, 8
    call transformar
    add rsp, 8

    ret

transformar:
    mPuts msjInput
    mGets PACK
    jo  caracterInvalido

    inicio:
    mov r9b,[PACK+3] ;Me desplazo al tercer caracter
    
    mov rcx, 0;Inicializo rcx en 0
    verificoLetras:
    mov r8b, [letrasSigno + rcx];Me paro en la letra que toca en el ciclo

    ;Si llegue al 0, complete el ciclo
    cmp r8b, 0
    je finDelCiclo

    ;Si no coinciden las letras paso a la siguiente
    cmp r8b,r9b
    jne siguienteLetra
    ;Si coinciden, dejo una S en RESULT
    mov byte[RESULT], "S"

    finDelCiclo:
    cmp byte[RESULT], "S"
    jne caracterInvalido ;Si no guardo una "S" antes, es caracter invalido
    mPuts RESULT
    ret
    

caracterInvalido:
    mov byte[RESULT], "N"
    mPuts RESULT
    ret

siguienteLetra:
    inc rcx
    jmp verificoLetras