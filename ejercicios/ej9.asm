global main

extern puts
extern printf

%macro mPuts 1
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro

section .data
    tabla dw 1, 0, 0, 0, 0
          dw 0, 7, 0, 0, 0
          dw 0, 0, 13, 0,0
          dw 0, 0, 0, 19,0
          dw 0, 0, 0, 0, 20

    msjEsTInferior db "La matriz es triangular inferior", 10, 0
    msjNoEsTInferior db "La matriz no es triangular inferior", 10, 0

    msjEsTSuperior db "La matriz es triangular superior", 10, 0
    msjNoEsTSuperior db "La matriz no es triangular superior", 10, 0

    esTInferior db 1
    esTSuperior db 1

    longFila      db 10 ; longFila = longElemento (2) * cantidad de Columnas (5)
    longElemento  db 2

section .text
main:
    ; Inicialización de variables
    mov rdi, 0 ; fila (i)
    mov rsi, 0 ; columna (j)

    mov byte [esTInferior], 1
    mov byte [esTSuperior], 1

    ; Recorrido de la matriz
recorrer_filas:
    cmp rdi, 5
    je verificacionFinal

    mov rsi, 0
recorrer_columnas:
    cmp rsi, 5
    je siguiente_fila

    ; Calculo del desplazamiento en la matriz
    mov rbx, rdi
    imul rbx, 10
    add rbx, rsi
    imul rbx, 2

    movzx rax, word [tabla + rbx]

    ; Verificar triangular inferior
    cmp rdi, rsi
    jl verificar_superior
    je siguiente_columna
    cmp rax, 0
    jne no_es_inferior
    jmp siguiente_columna

no_es_inferior:
    mov byte [esTInferior], 0

verificar_superior:
    cmp rdi, rsi
    jg verificar_elemento_superior
    jmp siguiente_columna

verificar_elemento_superior:
    cmp rax, 0
    jne no_es_superior
    jmp siguiente_columna

no_es_superior:
    mov byte [esTSuperior], 0

siguiente_columna:
    inc rsi
    jmp recorrer_columnas

siguiente_fila:
    inc rdi
    jmp recorrer_filas

verificacionFinal:
    ; Verificación final de la matriz
    cmp byte [esTInferior], 1
    je imprimir_inferior
    mPuts msjNoEsTInferior
    jmp verificar_superior_final

imprimir_inferior:
    mPuts msjEsTInferior

verificar_superior_final:
    cmp byte [esTSuperior], 1
    je imprimir_superior
    mPuts msjNoEsTSuperior
    jmp fin

imprimir_superior:
    mPuts msjEsTSuperior

fin:
    ret
