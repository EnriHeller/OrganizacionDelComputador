;las words tienen un tamaño de 2 bytes. 
;Los caracteres tienen tamaño de 1 byte. 
;Cuando se ensambla con el nasm archivo.asm -f elf 64, se crea un archivo objeto archivo.o 
; Con gcc archivo.o -no-pie  compilas.
; El mov no puede copiar de memoria a memoria.