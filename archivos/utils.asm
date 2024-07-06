global strLen

;Por calling convention:
;rdi: dir inicio de string
;El valor de retorno por calling convention va en el rax (endStrLen)

section .text
strLen:
    mov     rax,0
nextChar:
    cmp     byte[rdi + rax],0
    je      endStrLen
    inc     rax
    jmp     nextChar
endStrLen:
    ret
