;las words tienen un tamaño de 2 bytes. 
;Los caracteres tienen tamaño de 1 byte. 
;Cuando se ensambla con el nasm archivo.asm -f elf 64, se crea un archivo objeto archivo.o 
; Con gcc archivo.o -no-pie  compilas.
; El mov no puede copiar de memoria a memoria.

;GDB:

; nasm -f elf64 -g -F dwarf -l archivo.lst -o archivo.o archivo.asm
; gcc -no-pie -o test archivo.o

; nasm -f elf64 -g -F dwarf -l ej2.lst -o ej2.o ej2.asm
; gcc -no-pie -o test ej2.o