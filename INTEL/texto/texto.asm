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
;le sumas y le restas 8 al registro rsp (registro que apunta al tope del stack) por cuestiones de convención para hacer callings. Reservas ese espacio en memoria en caso que la función precise utilizarlo. 

%macro mPuts 0
    sub rsp, 8 ;Esto va siempre para que ande. Reservas espacio en la pila.
    call puts ;Con call llamas a las funciones. Puts es una funcion externa por ende la importo con extern. Es una función de C para imprimir por consola.
    add rsp,8 ;Esto va siempre para que ande. "Liberas" espacio reservado previamente.
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
    msgInText   db "Ingrese un texto por teclado (max 99 caracteres)", 0 ;db se pone siempre para decirle "define byte", es una pseudo instrucción para definir un campo. El 0 va siempre al final ya que es la marca de fin de string. 
    msgInChar   db "Ingrese un caracter: ", 0
    textLength  dq  0 ;(define quad o cuar,  no se que pingo dijo)
    counterChar dq  0
    msgReversedText db "Texto invertido: %s",10,0
    
    ;otroTexto dw "abc" -> Cada caracter te ocupa un byte y por eso se recomienda usar db. Si usas dw te sobra espacio en blanco al final.


;Aca se declaran datos sin valor inicial
section .bss
    text    resb 500 // resb sirve para guardarte area en memoria que despues vas a utilizar. Como este campo lo voy a usar para la función gets, reservo un espacio grande por el problema que tiene que sobreescribe memoria si se ingresa mas caracteres de los que se reservaron. 
    char    resb 50
    reversedText resb 500
section .text

main:


    mov rdi, msgInText ;Me traigo al rdi, la dirección de donde está mi mensaje (si estuviera entre corchetes seria el contenido). Allí lo va a ir a buscar la función puts y lo imprime
    mPuts

    mov rdi, text ;en el rdi copias la direccion del espacio en memoria que reservaste antes, para luego lo ingresado en el gets se aloje allí.
    mGets

    mov rdi, msgInChar
    mPuts

    mov rdi, char
    mGets

    ;Voy a querer pararme al inicio de la cadena alojada en text. Para eso utilizo el registro indice, que lo inicializo en 0. 
    mov rsi,0 

nextCharFindLast:
    cmp byte[text + rsi], 0 ;Todos los string terminan en 0. Quiero comparar el byte guardado en text + lo que tenga en el rsi. De esta manera, a medida que aumento el rsi voy a poder ver si ya llegue al 0 que marca el fin de string.

    je  endString ;bifurca si es igual (jump equal). Se fija que arrojó la función anterior, dado que la misma deja ciertas marcas en el registro de Flags que después la jump interpreta.  chequeando condicion de fin, Jumpeo a la etiqueta "endCopy"

    inc rsi ;incremento el puntero en uno

    jmp  nextCharFindLast

endString:
    mov rdi,0 ;El rdi en 0 inicializado para la linea 97.
    mov [textLength], rsi //Me guardo en textLength el contenido del rsi, ya que donde deje el programa me fue acumulando cuanto avance.

charCopy:
    cmp rsi, 0 ; ver si termino el recorrido de atrás para adelante. Voy restando todos los caracteres, termino cuando estoy en 0.

    je  endCopy ; chequeando condicion de fin, Jumpeo a la porción de código "endCopy"

    mov al,[text + rsi - 1] ;lo que tengo que copiar esta en text y quiero que termine en reversedText. Uso registro al como pivot. Le resto 1 para que apunte al ultimo caracter del texto, teniendo en cuenta que el rsi apunta al 0 binario.Esto copia el char corriente al registro pivote "al"

    mov [reversedText + rdi], al ; copia el caracter guardado en "al" a la siguiente posicion de reversedText. Al principio el rdi esta en 0

    cmp al,[char] ;copia los primeros 8bits (1 byte) del al, al char. Comparo caracteres, veo si el caracter al que apunto es igual al ingresado por teclado. (no tiene que ver con dar vuelta la cadena). 

    jne movePointers 

    add qword[counterChar],1 ;si son iguales incremento contador de caracteres. podria haber sido la instrucción inc. Sumo uno al contador del caracter. 

movePointers:
    inc rdi
    dec rsi
    jmp charCopy

endCopy:
    mov byte[reversedText + rdi],0 ;le pones el 0 al final para marcar el fin de string al reversedText.  

    ;imprimo texto invertido
    mov rdi,msgReversedText
    mov rsi,reversedText
    mPrintf

    ;;La instrucción ret se necesita para finalizar el programa
    ret

;La idea para revertir la cadena es tener dos punteros: Uno al final del string ingresado por teclado y otro puntero al inicio del espacio guardado para el string invertido. A medida que voy copiando, voy decrementando la direccion del puntero que esta al final de la cadena original y aumentando la dirección del puntero del string nuevo invertido. 

;nextCharFindLast: para revertir la cadena, tengo que pararme al principio, recorrer byte a byte hasta encontrar el 0 que añadió el get por defecto. Ahi se que me paré al final. con cmp comparas el caracter que este en [text + desplazamiento ] y el otro será el 0. al lado del mas le pones el desplazamiento, alojado en el registro indice rsi. Despues usas la instrucción mov para traer ese registro. Le pones byte al principio, para acceder al primer byte al principio y despues ir moviendolo con el rsi que lo vas cambiando.  

;endString: A partir de aca no entendi un pingo. 

;Para compilar:
; nasm texto.asm -f elf64 (esto te lo ensambla)
; gcc texto.o -no-pie (esto te compila el archivo ejecutable)
; ./a.out (este es el archivo ejecutable, si no le pones nombre es "a" por defecto)


