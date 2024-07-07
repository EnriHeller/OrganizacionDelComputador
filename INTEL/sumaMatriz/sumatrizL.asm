;*****************************************************************************
; sumatriz.asm

; Dada una matriz de 5x5 cuyos elementos son números enteros de 2 bytes (word)
; se pide solicitar por teclado un nro de fila y columna y realizar
; la sumatoria de los elementos de la fila elegida a partir de la
; columan elegida y mostrar el resultado por pantalla.

; Se deberá validar mediante una rutina interna que los datos ingresados por
; teclado sean validos.

;*****************************************************************************

global	main
extern	printf
extern	gets
extern	sscanf
extern	puts

section	.data

    ;matriz  dw  1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5
    matriz  dw  1,1,1,1,1
			dw  2,2,2,2,2
			dw	3,3,3,3,3
			dw	4,4,4,4,4
			dw	5,5,5,5,5
    msjIngFilCol	db	"Ingrese fila (1 a 5) y columna (1 a 5) separados por un espacio: ",0
    formatInputFilCol	db	"%hi %hi",0
    msjErrorInput       db  "Los datos ingresados son inválidos.  Intente nuevamente."
	sumatoria		dd 0
	msjSumatoria	db	"La sumatoria es: %i",10,0    

section	.bss
	inputFilCol		resb	50
   	fila			resw	1
	columna			resw	1 	
    inputValido     resb    1   ;S valido N invalido
    desplaz			resw	1

section	.text
main:
	mov		rdi,msjIngFilCol ; copio mensaje al rdi

	sub		rsp,8
	call	printf ; Imprimo mensaje del rdi.
	add		rsp,8

    mov		rdi,inputFilCol	;Cargo espacio reservado para el numero de fila y columna
	sub		rsp,8	
    call    gets    
	add		rsp,8	    

    sub     rsp,8
    call    validarFyC ;Valido fila y columna cargada al rdi. Llamo a rutina interna.
    add     rsp,8

    cmp     byte[inputValido],'S'
    je      continuar

    mov     rdi,msjErrorInput
    sub     rsp,8
    call    puts
    add     rsp,8	

    jmp     main
continuar:
; sumatoria
	sub		rsp,8
    call	calcSumatoria
	add		rsp,8

;mostrar por pantalla
    mov		rdi,msjSumatoria
	sub		rsi,rsi
	mov		esi,[sumatoria]
	sub		rsp,8
	call	printf
	add		rsp,8  


ret ;FIN DE PROGRAMA
;*********************************

; RUTINAS INTERNAS
;*********************************
validarFyC:
    mov     byte [inputValido], 'N'  ; Inicialmente marcamos el input como no válido

    mov     rdi, inputFilCol
    mov     rsi, formatInputFilColinputFilCol         
    mov     rdx, fila                
    mov     rsi, columna            

    sub     rsp, 8                   ; Ajustamos el stack para la llamada
    call    scanf                    ; Llamamos a scanf
    add     rsp, 8                   ; Restauramos el stack

    cmp     rax, 2                   ; Comparamos el número de conversiones exitosas
    jl      invalido                 ; Si es menor que 2, saltamos a "invalido"

    cmp     word [fila], 1           ; Comparamos la fila con 1
    jl      invalido                 ; Si es menor que 1, saltamos a "invalido"
    cmp     word [fila], 5           ; Comparamos la fila con 5
    jg      invalido                 ; Si es mayor que 5, saltamos a "invalido"

    cmp     word [columna], 1        ; Comparamos la columna con 1
    jl      invalido                 ; Si es menor que 1, saltamos a "invalido"
    cmp     word [columna], 5        ; Comparamos la columna con 5
    jg      invalido                 ; Si es mayor que 5, saltamos a "invalido"

    mov     byte [inputValido], 'S'  ; Si todas las condiciones se cumplen, marcamos el input como válido

invalido:
    ret                              ; Retornamos de la función

invalido:
ret ;termina la rutina y deja el inputValido en N
;*********************************

calcDesplaz:
;  [(fila-1)*longFila]  + [(columna-1)*longElemento]
;  longFila = longElemento * cantidad columnas
    mov     bx,[fila]
    1sub     bx,1
    imul    bx,bx,10    ;en bx tengo el desplazamiento a la fila

    mov     [desplaz],bx

    mov     bx,[columna]
    dec     bx
    imul    bx,bx,2

    add     [desplaz],bx    ;en desplaz tengo el desplazamiento total
ret

;*********************************
calcSumatoria:
	sub		rsp,8
    call	calcDesplaz
	add		rsp,8
;jmp FIN_NO_OLVIDAR_REMOVER
    mov     rcx,6 ;cargo el 6 al registro cx
    sub     cx,[columna] ;Al hacer cs - la columna, tengo a partir de que columna tengo que hacer la sumatoria
    mov     ebx,[desplaz] ; cargo al ebx el desplazamiento
sumarSiguiente:
    sub     eax,eax ;limpio el registro eax
    mov     ax,[matriz + ebx]   ; cargo el elemento de la matriz q es de 2 bytes
    add     [sumatoria],eax     ;actualizo la sumatoria con un campo de 4 bytes
    add     ebx,2
    loop    sumarSiguiente
FIN_NO_OLVIDAR_REMOVER:    
ret






