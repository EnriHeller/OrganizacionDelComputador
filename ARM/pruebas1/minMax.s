    @ constantes
    .equ SWI_Print_Char, 0x00
    .equ SWI_Print_String, 0x02
    .equ SWI_Print_Str, 0x69

    .equ SWI_Open_File, 0x66
    .equ SWI_Close_File, 0x68

    .equ SWI_Print_Int, 0x6B
    .equ SWI_Read_Int, 0x6C

    .equ Stdout,1

    .equ SWI_Exit, 0x11

    @ sección de datos
    .data
filename:
    .asciz "dos_enteros.txt"
min_header:
    .asciz "Min: "
mas_header:
    .asciz "Max: "
eol:
    .asciz "\n"
    .align
InFileHandle:
    .word 0

    @sección de código
    .text
    .global _start

_start:
    ldr r0, =filename @nombre de archivo de entrada
    mov r1, #0 @abrir para lectura
    swi SWI_Open_File @abrir el archivo
    bcs InFileError @Chequeo si hubo error. si hay acarreo, bifurca a sección indicada.  

    @Para guardar en memoria el handler necesito guardarme la dirección en memoria donde quiero guardar previamente en un registro (ldr) y luego (como me queda en r0 el handler) y guardo en la dirección que tengo en r1, en este caso:
    
    ldr r1, =InFileHandle @Cargo dirección donde almacene el handler. 
    str r0, [r1] @almaceno handler

    bl read_int 
    mov r2, r0 @me guardo un numero en r2

    bl read_int
    mov r3, r0 @me guardo el otro numero en r3

    cmp r2, r3
    @si r2 es menor que r3 (r2 - r3 < 0) r2 está el más chico
    blt print_result

    mov r1, r2 @si llego hasta acá, en r2 está el mayor, asi que lo pongo en r1
    mov r2, r3 @como en r3 está el menor y lo quiero en r2, lo muevo ahi
    mov r3, r1  @el r1 que use de pivot, pongo el mayor en r3. 

print_result:
    ldr r0, =Stdout

    @para imprimir un texto, pone la dirección del texto en r1
    ldr r1, =min_header
    swi SWI_Print_Str
    @en r2 me queda el valor menor
    mov r1, r2
    bl print_r1_int

    ldr r0, = Stdout
    ldr r1, =max_header
    swi SWI_Print_Str
    mov r1, r3
    bl print_r1_int

@Leo entero desde archivo
read_int:
    stmfd sp!, {lr}

    ldr r0, =InFileHandle
    ldr r0, [r0]

    @para usar el read int tengo que tener en el r0 el handler
    swi SWI_Read_Int
    @el resultado me queda en r0

    ldmfd sp!, {pc}



print_r1_int:
    stmfd sp!, {r0,r1, lr}
    ldr r0, =Stdout
    swi SWI_Print_Int
    ldr r1, =eol
    swi SWI_Print_Str
    ldmfd sp!, {r0,r1, pc}

InFileError:
EofReached:
    swi SWI_Exit
    .end 