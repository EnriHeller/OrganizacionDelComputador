@Práctica 6. Mostrar cálculos aritméticos y lógicos
@Escribir el código ARM que ejecutado bajo ARMSim# realice las siguientes operaciones
@aritméticas y lógicas sobre dos enteros almacenados en un archivo: Suma, Resta,
@Multiplicación, AND, OR, XOR, Shift Izquierda, Shift Derecha, Shift Derecha Aritmética. Imprimir
@por pantalla los resultados de las operaciones en sus propias líneas.

.equ SWI_Open_File, 0x66
.equ SWI_Close_File, 0x68
.equ SWI_Print_Str, 0x69
.equ SWI_Print_Int, 0x6B
.equ SWI_Read_Int, 0x6C
.equ SWI_Exit, 0x11

    .data
fileName:
    .asciz "dos_enteros.txt"

inFileHandle:
    .word 0

eol:
    .asciz "\n"
    .align

    .text
    .global _start

_start:
    @abro archivo
    ldr r0, =fileName
    mov r1, #0 @modo entrada
    swi SWI_Open_File
    bcs InFileError

    @guardo handle
    ldr r1, =inFileHandle
    str  r0, [r1]

    @cargo n1
    ldr r0, =inFileHandle
    ldr r0,[r0]
    swi SWI_Read_Int
    bcs EofReached
    mov r2, r0

    @cargo n2
    ldr r0, =inFileHandle
    ldr r0,[r0]
    swi SWI_Read_Int
    bcs EofReached
    mov r3, r0

    @suma
    add r4,r2,r3
    bl print_res

    @resta
    sub r4, r2, r3
    bl print_res

    @multiplicacion
    mul r4, r2,r3 
    bl print_res

    @and
    and r4, r2, r3
    bl print_res

    @or
    orr r4, r2, r3
    bl print_res

    @xor
    eor r4, r2, r3
    bl print_res

    @shift izquierda
    lsl r4, r2, r3
    bl print_res

    @shift derecha
    lsr r4, r2, r3
    bl print_res

    asr r4, r2, r3
    bl print_res

EofReached:
InFileError:
    swi SWI_Close_File
    swi SWI_Exit

print_res:
    stmfd sp!, {r0,r1,r2,r3,r4,lr}

    mov r0, #1 @stdout
    mov r1,r4
    swi SWI_Print_Int

    ldr r1, =eol
    swi SWI_Print_Str

    ldmfd sp!, {r0,r1,r2,r3,r4,pc}