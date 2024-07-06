bits 64
global main
extern puts

section .data
    ddd db "*"
    val db 0,0,0,0

section .text

main:
    mov rbx,3 ; cargo 3 al registro base
    mov rcx,3 ; cargo 3 al registro C

    dec     rbx ;resto 1 al registro base
    imul    rbx,6 ;multiplico por 6 al registro base -> rbx = 2*6 = 12 

    sub     rcx,1 ;resto 1 al registro base
    imul    rcx,2 ; multiplico por 2 -> rcx 2*2 = 4

    add     rbx,rcx ;calculo el desplazamiento sobre rbx
    lea     rax,[tabla] ;copio dirección de tabla al rax
    add     rax,rbx ; me muevo en la dirección hasta el final

    sub rcx,2 ; Tenia 4 en el rcx, me queda 2

    mov rsi,rax ;muevo al rci Direccion de BP
    mov rdi, val1 ; muevo al rdi donde arranca el val1
    
    rep movsb ;Copio el contenido dentro de la dirección del rsi (BP) a donde apunta el RDI.ahora val1 arranca con BP

    mov rdi,val1 ; muevo al RDI dirección de val1 
    sub rsp,8
    call puts
    add rsp,8

    ;imprime BP

    sub rax,rax ; vacio acumulador
    mov ax,[tabla + 3] ;muevo a ax la dirección de tabla + 3
    
    ret


;Para compilar:

; nasm dale.asm -f elf64 
; gcc dale.o -no-pie 
; ./a.out 

