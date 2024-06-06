global main
extern puts

section .data
    tabla db     "FKD", "EJG"
    t1    db       "HIQ", "LMN"
    t2    db        "OCR", "ABP"
    desplaz db 0
    val1 times 3    db 0


section .text

main:
    mov rbx,3
    mov rcx,2

    dec     rbx
    imul    rbx,6

    sub     rcx,1
    imul    rcx,2

    add     rbx,rcx
    lea     rax,[tabla]
    add     rax,rbx

    sub rcx,2

    mov     rsi,rax
    mov rdi, val1
    
    rep   movsb

    mov rdi,val1
    sub rsp,8
    call puts
    add rsp,8

    sub rax,rax
    mov ax,[tabla + 3]

    ret
