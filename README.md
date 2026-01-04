# Computer Organization - Notes and Exercises

This repository contains notes, exercises, and solved problems from the **Computer Organization** course at FIUBA (Facultad de Ingeniería, Universidad de Buenos Aires). The materials cover assembly language programming for ARM and x86 (Intel) architectures, including practical exercises, finals, and tests.

## Repository Structure

- **`ARM/`**: Assembly code for ARM architecture.
  - **`practicas/`**: Practice exercises, including basic I/O, arithmetic operations, loops, recursion, and array manipulations.
  - **`finales/`**: Final exam problems and solutions.
  - **`pruebas1/`** and **`pruebas2/`**: Additional test files and exercises for practice.
- **`INTEL/`**: Assembly code for x86 (Intel) architecture.
  - **`apunte/`**: Notes on functions and other concepts in C and assembly.
  - **`ejercicios/`**: Solved exercises (ej1 to ej19).
  - **`archivos/`**: Code for file handling and utilities.
  - **`holaMundo/`**: Basic "Hello World" example.
  - **`pruebas/`**: Test programs.
  - **`sumaMatriz/`**: Matrix summation example.
  - **`tablas/`**: Table manipulation and simulation code.
  - **`texto/`**: Text processing examples.

## Prerequisites

- **ARM**: ARM assembler (e.g., `as` or `arm-none-eabi-as`) and linker. For Raspberry Pi or similar, use `gcc` for compilation.
- **x86**: NASM or MASM assembler, and a linker like `ld` or Visual Studio tools.

## Compilation and Execution

### ARM Examples

1. Assemble and link:
   ```bash
   as -o program.o program.s
   ld -o program program.o
   ./program
   ```

2. For programs with I/O, ensure proper setup for stdin/stdout.

### x86 Examples

1. Using NASM:
   ```bash
   nasm -f elf64 program.asm -o program.o
   ld program.o -o program
   ./program
   ```

2. On Windows, use MASM with Visual Studio.

Refer to individual files for specific instructions, as some may require input files (e.g., `.txt` files in the directories).

## Topics Covered

- Basic assembly syntax and instructions.
- Arithmetic and logical operations.
- Control structures (loops, conditionals).
- Functions and recursion.
- Memory management and pointers.
- File I/O.
- Array and string manipulations.
- System calls.

## Author

- **Enrique Heller** - [EnriHeller](https://github.com/EnriHeller)

## License

This repository is for educational purposes. Feel free to use and modify the code, but cite the source if used in academic work.

## Contributing

If you find errors or want to add more exercises, feel free to open an issue or pull request.