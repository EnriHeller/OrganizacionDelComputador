;Se cuenta con un archivo "listado.dat" en fomrato binario con información de autos. Cada registro tiene los campos:
; - Marca: 20 caracteres ascii
; - Modelo: 20 caracteres ascii
; - Año fabricación: 2 bytes en bpf s/s
;
;Se pide realizar un programa que pida ingresar por teclado una marca de automovil e imprima por pantalla todos los autos de dicha marca que se encuentran en el archivo.
;
; Las marcas válidas de autos posible son Fiat, Ford, Chevrolet y Peugeot y se deberá validar que la marca ingresada sea alguna de ellas previo a al búsqueda en el archivo. 

%macro mPuts 1
    mov rdi, %1

    sub rsp, 8
    call puts
    add rsp, 8
%endmacro 

%macro mGets 1
    mov rdi, %1

    sub rsp, 8
    call gets
    add rsp, 8
%endmacro 

%macro mStrLen 1
    mov rdi, %1

    sub rsp, 8
    call strLen
    add rsp, 8
%endmacro

%macro mValidator 0
    lea rdi, [marca10Chars]
    lea rsi,[marcas]

    sub rsp, 8
    call validator
    add rsp, 8
%endmacro

%macro mFopen 0
    mCleanRx
    mov rdi, fileAutos
    mov rsi, modeListado

    sub rsp, 8
    call fopen
    add rsp, 8
%endmacro

%macro mCleanRx 0
    sub rsp,8
    call cleanRx
    add rsp,8
%endmacro

global main
extern puts
extern gets
extern strLen
extern validator
extern fopen
extern fread
extern printf
extern fclose


section .data
    msgInMarca                  db "Ingrese una marca de auto:",0
    marcas                      db "Fiat      Ford      Chevrolet Peugeot   ",0
    marca10Chars    times 10    db " "

    msgValido                   db "Marca Validada.",0
    msgInvalido                 db "Marca invalida, intente nuevamente.",0

    fileAutos		            db	"listado.dat",0
    modeListado		            db	"rb",0	
    msgErrOpenLis       	    db	"Error en apertura de archivo Listado",0
    msgDataAuto                 db  "%s %hi",10,0

    marcaModelo     times 20    db  " "
    endStr                      db   0

section .bss
    inputMarca resb 200

    handleListado           resq 1
    regListado      times 0 resb 1  ;Cabecera del registro (con times 0 para q no reserve espacio)
        marca                 resb 10 ;Campo donde se guardara la marca leida del archivo
        modelo                resb 10 ;Campo donde se guardara el modelo leido del archivo
        anioFabric            resb 2  ;Campo donde se guardara el año de fabricacion leido del archivo

section .text
main:
    mPuts msgInMarca
    mGets inputMarca
    mStrLen inputMarca

formateo:
    ;me guardo con un espacio de 10 reservado lo que ingrese
    mov rcx, rax ;Cargo el strLen al rcx
    lea rsi, [inputMarca] ;copio lo que tengo en inputMarca
    lea rdi, [marca10Chars];Al marca10Chars
    rep movsb

    mCleanRx

comparo:
    mValidator
    cmp rax, 1
    jne noIguales

Iguales:
    mPuts msgValido
    mFopen
    cmp rax, 0
    jle errorOpenLis ; si me da 0 o menos hay error al abrir.
    mov [handleListado], rax ; me traigo el ID del archivo

;Leo un registro del archivo
readNexRegister:
    mov     rdi,regListado          ;Param 1: campo de memoria para guardar el registro q se leerá del archivo
    mov     rsi,22                  ;Param 2: Tamaño del registro en bytes (10 bytes para la marca, 10 para el modelo y 2 que no se)
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
    mov     rcx,10
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

errorOpenLis:
    mPuts   msgErrOpenLis
	jmp		endProg

endProg:
ret

noIguales:
    mPuts msgInvalido
    ret

cleanRx:
    sub rax, rax
    sub rcx, rcx
    sub rsi, rsi
    sub rdi, rdi
    ret

