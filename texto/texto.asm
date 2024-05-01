;************************** CONSIGNA *************************************
;
;Ingresar por teclado un texto y luego un caracter e imprimir por pantalla:

;-El texto de forma invertida
;-La cantidad de apariciones del caracter en el texto
;-El porcentaje de esas apariciones respecto de la longitud total del texto
;
;
;**************************************************************************

;Aca pones codigo que quieras repetir. Donde esta el 0 en la firma, es un parámetro que no uso, por eso le pongo 0. 

%macro mPuts 0
    sub rsp,8
    call puts
    add rsp,8
%endmacro

;El problema de gets es que te puede llegar a pisar memoria de campos que no queres que eso suceda. Hay que definir un espacio lo suficientemente grande para que esto no suceda
%macro mGets 0
    sub rsp,8
    call gets
    add rsp,8
%endmacro

%macro mPrintf 0
    sub rsp,8
    call    printf
    add rsp,8
%endmacro

;El global main lo necesita el compilador GCC para leer el programa
global main
extern puts
extern gets
extern printf

;Aca se declaran datos con valor inicial
;El mensaje inicial lo guardo aca porque es un valor fijo.
section .data
    msgInText   db "Ingrese un texto por teclado (max 99 caracteres)", 0 ;db se pone siempre para decirle "define byte"
    msgInChar   db "Ingrese un caracter: ", 0
    textLength  dq  0 ;(define quad o cuar,  no se que pingo dijo)
    counterChar dq  0
    msgReversedText db "Texto invertido: %s",10,0
    
    ;otroTexto dw "abc" -> Cada caracter te ocupa un byte y por eso se recomienda usar db. Si usas dw te sobra espacio en blanco al final.


;Aca se declaran datos sin valor inicial
section .bss
    text    resb 500
    char    resb 50
    reversedText resb 500
section .text

main:
;La instrucción ret se necesita para finalizar el programa

    mov rdi, msgInText ;Me traigo el contenido de la variable al rdi. 
    mPuts
    ;remplazo lo de abajo por mi bloque de codigo que probablemente quiera repetir (mPuts)
    
    ;sub rsp, 8 ;Esto va siempre para que ande. Reservas espacio en la pila.
    ;call puts ;Con call llamas a las funciones. Puts es una funcion externa por ende la importo con extern. Es para imprimir por consola.
    ;add rsp,8 ;Esto va siempre para que ande. "Liberas" espacio reservado previamente.

    mov rdi, text
    mGets

    mov rdi, msgInChar
    mPuts

    mov rdi, char
    mGets

    mov rsi,0

nextCharFindLast:
    cmp byte[text + rsi], 0 ;Fin de string.
    je  endString ;bifurca si es igual (jump equal). Interactuas con el registro de Flags
    inc rsi ;incremento el puntero en uno
    jmp  nextCharFindLast

endString:
    mov rdi,0 ;tengo que tener el rdi inicializado en 0 para que apunte al primer caracter de reversedText
    mov [textLength],rsi

charCopy:
    cmp rsi,0 ; ver si termino el recorrido de atrás para adelante. 
    je  endCopy ;chequeando condicion de fin
    mov al,[text + rsi - 1] ;lo que tengo que copiar esta en text y quiero que termine en reversedText. Uso registro al como pivot. Le resto 1 para que apunte al ultimo caracter del texto, teniendo en cuenta que el rsi apunta al 0 binario.Esto copia el char corriente al registro pivote "al"
    mov [reversedText + rdi],al ; copia del char corriente en la siguiente posicion de reversedText

    cmp al,[char] ;copia los primeros 8bits del campo char tal que al es de 8 bits. Comparo caracteres, veo si el caracter corriente es igual al ingresado por teclado.

    jne movePointers 
    add qword[counterChar],1 ;si son iguales incremento contador de caracteres. podria haber sido la instrucción inc. Sumo uno al contador del caracter. 

movePointers:
    inc rdi
    dec rsi
    jmp charCopy

endCopy:
    mov byte[reversedText + rdi],0 ;le pones el 0 al final para marcar el fin de string. 

    ;imprimo texto invertido
    mov rdi,msgReversedText
    mov rsi,reversedText
    mPrintf

    ret

;nextCharFindLast: para revertir la cadena, tengo que pararme al principio, recorrer byte a byte hasta encontrar el 0 que añadió el get por defecto. Ahi se que me paré al final. con cmp comparas el caracter que este en [text + ] y el otro será el 0. al lado del mas le pones el desplazamiento, alojado en el registro indice rsi. Despues usas la instrucción mov para traer ese registro. Le pones byte al principio, para acceder al primer byte al principio y despues ir moviendolo con el rsi que lo vas cambiando.  

;endString: A partir de aca no entendi un pingo. 


;Para compilar:
; nasm texto.asm -f elf64 (esto te lo ensambla)
; gcc texto.o -no-pie (esto te compila el archivo ejecutable)
; ./a.out (este es el archivo ejecutable, si no le pones nombre es "a" por defecto)


