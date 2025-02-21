@Escribir el código ARM que ejecutado bajo ARMSim# imprima dos cadenas de caracteres
@predefinidas en memoria incluyendo salto de línea “Hola” y ”Chau” utilizando una subrutina
@que imprima un string cuya dirección esté en el R3.

.equ SWI_Print_Str, 0x02
.equ SWI_Exit, 0x11

    .data
saludo:
    .asciz "Hola"
despedida:
    .asciz "Chau"
eol:
    .asciz "\n"
    .align

    .text
    .global _start

_start:

    @Ok tengo que armarme la subrutina que como parámetro agarre lo que esta en r3

    ldr r3, =saludo
    bl imprimir_cadena
    ldr r3, =despedida
    bl imprimir_cadena
    swi SWI_Exit

imprimir_cadena:
    stmfd sp!, {r0, r3, lr}
    mov r0,r3
    swi SWI_Print_Str
    ldr r0, =eol
    swi SWI_Print_Str
    ldmfd sp!, {r0, r3, pc}
    
    .end