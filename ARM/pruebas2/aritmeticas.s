@Escribir el código ARM que ejecutado bajo ARMSim# realice las siguientes operaciones
@aritméticas y lógicas sobre dos números cargados en memoria: Suma, Resta, Multiplicación,
@AND, OR, XOR, Shift Izquierda, Shift Derecha, Shift Derecha Aritmética. Dejar el resultado de
@las operaciones en los registros del R2 al R10.

.equ SWI_Exit, 0x11

    .data
x:
    .word 5
y:
    .word 6

    .text
    .global _start
_start:
    ldr r0, =x
    ldr r1, =y
    ldr r0, [r0]        @ Cargar el valor de x desde memoria a R0 (R0 = 5)
    ldr r1, [r1]  

    add r2, r0, r1
    sub r3, r0, r1
    mul r4, r0, r1
    and r5, r0, r1
    orr r6, r0, r1
    eor r7,r0,r1
    LSL r8, r0, r1
    LSR r9, r0, r1
    ASR r10, r0, r1

    swi SWI_Exit