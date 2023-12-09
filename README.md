# Compiler for the Grace programming language implemented in OCaml

The compiler works as follows:
    - Lexical analysis is the first step and is implemented using ocamllex
    - Parsing is done along with the lexical analysis and is implemented using Menhir
    - Semantic analysis is done alongside the parsing
    - After the entire AST has been created and the semantic analysis has concluded,
      it is translated into LLVM IR, using the OCaml LLVM bindings.
    - The IR is (optionally) optimized before being translated to the assembly used by the host machine
    - LLVM emits LLVM IR code (in a .imm file), host machine assembly code (in a .asm file),
      as well as an object file (in a .o file)
    - Clang is finally used to link the .o file with the Grace runtime library and the C runtime library
      and create the final executable (in a .exe file)
    - If any errors are encoutered at any phase of the compilation,
      an error message is output to stderr and the compilation fails
