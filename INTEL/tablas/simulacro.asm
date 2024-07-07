global main
extern puts

section .data
    t       db     "ABCDEFGH", "IJKLMNOP", "QRSTUVWX"
    code    db     40
    desplaz dd     0


section .text

main:
    mov rax,3
    mov rbx,2

    dec     rax
    imul    rax,8

    sub     rbx,1
    imul    rbx,4

    add     rbx,rax
    lea     r8,[t]
    add     r8,rbx

    mov     rdi,r8
    sub     rsp,8
    call    puts
    add     rsp,8

    ret
