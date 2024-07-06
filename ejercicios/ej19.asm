;Se cuenta con una matriz (M) de 20x20 cuyos elementos son BPFC/S de 16 bits y
;un archivo (carbina.dat) cuyos registros están conformados por los siguientes
;campos:

;• Cadena de 16 bytes de caracteres ASCII que representa un BPFc/s de 16 bits
;• BPF s/s de 8 bits que indica el número de fila de M
;• BPF s/s de 8 bits que indica el número de columna de M

;Se pide codificar un programa que lea los registros del archivo y complete la matriz
;con dicha información. Como el contenido de los registros puede ser inválido
;deberá hacer uso de una rutina interna (VALREG) para validarlos (los registros
;inválidos serán descartados y se procederá a leer el siguiente). Luego realizar la
;sumatoria de la diagonal secundaria e imprimir el resultado por pantalla.

;Nota: Se deberá inicializar M con ceros por si no se lograra completar todos los
;elementos con la información provista en el archivo.

global main
extern fopen
extern fread
extern fclose

%macro mFopen 0
    mov rdi, file
    mov rsi, modeListado

    sub rsp, 8
    call fopen
    add rsp, 8
%endmacro

section .data
    file                        db  "carbina.dat",0
    msgErrOpenLis       	    db	"Error en apertura de archivo Listado",0


section .bss
    M  times 400 resw 

    handleListado           resq 1
    regListado   times 0    resb 1  ;Cabecera del registro (con times 0 para q no reserve espacio)
        cadena              resb 16 ;Campo donde se guardara la cadena
        fila                resb 8  ;Campo donde se guardara el numero de fila
        columna             resb 8  ;Campo donde se guardara el numero de columna

section .text

main:
    mFopen
    cmp rax, 0
    jle errorOpenLis ; si me da 0 o menos hay error al abrir.
    mov [handleListado], rax ; me traigo el ID del archivo

readNexRegister:
    mov     rdi,regListado          ;Param 1: campo de memoria para guardar el registro q se leerá del archivo
    mov     rsi, 16                  ;Param 2: Tamaño del registro en bytes
    mov     rdx,1                   ;Param 3: Cantidad de registros a leer (** usamos siempre 1 **)
	mov		rcx,[handleListado]     ;Param 4: id o handle del archivo (obtenido en fopen)

    sub		rsp,8  
	call    fread
	add		rsp,8

    cmp     rax,0
    je      closeFile

    ;Comparo la marca ingresada por teclado con el campo marca del registro leido del archivo
    mov     rsi,marca
    mov     rdi,marca10Chars
    mov     rcx,16
    repe cmpsb

    jne     readNexRegister

    ;Copio la marca y modelo en un campo q finalice con 0 binario (para poder usarlo en printf)
    mov     rsi,marca
    mov     rdi,marcaModelo
    mov     rcx,20 ;copio 20 bytes por lo tanto se copia marca y modelo
    rep movsb

    ;Imprimo los datos del auto encontrado en el archivo
    mov     rdi,msgDataAuto
    mov     rsi,marcaModelo
    xor     rdx,rdx
    mov     dx,[anioFabric]
    sub     rsp,8
    call    printf
    add     rsp,8
    
    jmp     readNexRegister


    ;Cierro el archivo
closeFile:
    mov     rdi,[handleListado]
    sub     rsp,8
    call    fclose
    add     rsp,8

    jmp     endProg