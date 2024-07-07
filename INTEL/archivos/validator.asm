global validator

section .text
validator:
    xor rbx, rbx
    xor rax, rax
compare:
    mov rcx, 10
    lea rsi,[rsi + rbx]
    lea rdi,[rdi]

    repe cmpsb
    je equal

    cmp rbx, 40
    je notEqual
    add rbx, 10

    xor rcx, rcx
    jmp compare

equal:
    mov rax, 1
    ret

notEqual:
    ret
