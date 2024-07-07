    .equ SWI_Print_String, 0x02
    .equ SWI_Exit, 0x11

    .data
first_string:
    .asciz "Hola\n"

second_string:
    .asciz "Chau\n"

    .text
    .global _start

_start:
    ldr r3, =first_string  @ Carga la dirección de first_string en r3
    bl  print_r3           @ Llama a la subrutina print_r3
    
    ldr r3, =second_string @ Carga la dirección de second_string en r3
    bl  print_r3           @ Llama a la subrutina print_r3
    b   fin                @ Salta a la etiqueta fin

print_r3:
    stmfd sp!, {r0,lr} @Al stack pointers se carga r0 y el registro desde donde se saltó. Es como que me guardo donde estaba antes en el lr
    mov r0, r3 @El valor de la cadena necesito que este en r0, por ende lo muevo desde r3 a r0
    swi SWI_Print_String
    ldmfd sp!, {r0,pc} @Acá llamas a lo que está en el stack y recuperas lo que está en r0 y el program counter. El program counter justamente está para volver a donde estaba. 

fin:
    swi SWI_Exit
    .end