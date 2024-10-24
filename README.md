# Grace
This project is a compiler for the (made-up) Grace programming language, built using OCaml and the LLVM back-end. It was created as part of the Compilers course of the [School of Electrical and Computer Engineering](https://www.ece.ntua.gr/en) of the [National Technical University of Athens](https://ntua.gr/en/) during the academic year 2022-2023.

#### Contributors
* `dimjimitris` - Dimitris Georgousis
* `gkapetanakis` - George Kapetanakis (me)

#### Grade
The project was graded with a 10 out of 10.

## Jump to a Section
* [Repository Contents](#repository-contents)
* [Setup Guide](#setup-guide)
* [Usage Guide](#usage-guide)
* [Testing Guide](#testing-guide)
* [A High-level Overview](#a-high-level-overview)
* [Some Low-level Details](#some-low-level-details)

## Repository Contents
* `bin`: Contains the code of the main executable.
* `handouts`: Contains a PDF with the project description and the Grace language's specification in Greek.
* `lib`: Contains the rest of the code (most of the code is here: lexing, parsing, AST and code generation, optimizations). 
* `runtime_lib`: Contains the code for Grace's runtime library, written in C.
* `sample_programs`: Some sample `.grc` programs that the compiler can compile into executables.
* `test`: Contains code used for testing the semantic analysis part of the compiler.

## Setup Guide
### Software Requirements
* LLVM 14
* Clang 14 (`clang-14` should be in the PATH)
* opam (the OCaml Package Manager)

### Installation Instructions
* Clone the repository wherever you like (e.g. `./`) and `cd` into it.
* Run `opam install dune menhir llvm.14.0.6 ctypes-foreign` (this might take a while to finish).
* Run `make -C runtime_lib/ && make -C runtime_lib/ clean`.
* Run `dune build`.

## Usage Guide
After building, the compiler can be run as follows:
* `dune exec gracec -- [compiler options] <compiler input>` (try running `dune exec gracec -- --help`)

The compiler can also be installed as an opam package using `dune install` inside `./`.
After that, it can be run using as follows:
* `gracec [options] <input>` (again, try `gracec --help`)

## Testing Guide
When the compiler is built (`dune build`) some semantic tests are run automatically. You can also execute the semantic tests by running `dune runtest` in `./`.

## High-level Overview
The compiler works as follows:
* Lexical analysis is the first step and is implemented using ocamllex
* Parsing is done along with the lexical analysis and is implemented using Menhir
* Semantic analysis is done alongside the parsing
* After the entire AST has been created and the semantic analysis has concluded, it is translated into LLVM IR (= intermediate representation), using the OCaml LLVM bindings.
* The IR is (optionally) optimized before being translated to the assembly used by the host machine
* LLVM emits LLVM IR code (in a `.imm` file), host machine assembly code (in a `.asm` file), as well as an object file (in a `.o` file)
* Clang is finally used to link the `.o` file with the Grace runtime library and the C runtime library and create the final executable (in a `.exe` file)
* If any errors are encountered at any phase of the compilation, an error message is output to stderr and the compilation fails

In short, two intermediate representations are used, one that closely matches
the grammar of the language, and LLVM IR.

## Some Low-level Details
### Data Flow
* `lexer.mll` tokenizes the input and passes the tokens to `parser.mly`
* The functions of `parser.mly` call functions from `wrapper.ml`
* The functions of `wrapper.ml` call functions from `sem.ml`, `symbol.ml`
* The AST is created
* `codegen.ml` does the rest

### Nested Functions
LLVM does not support nested functions, but Grace does.
In order to use LLVM for optimizing and translating to assembly/machine code the following workaround is used:

Consider a simple Grace program:
```
fun f(): nothing
    var i: int;
    var c: char;
    fun g(arg: int)
        fun h(): nothing
        {
            c <- 'a';
        }
    {
        i <- 5;
        h();
    }
{
    g(2);
}
```

The equivalent LLVM representation (written using C syntax) is:
```
struct struct_f {
    void* parent;
    int* i;
    char* c;
};

struct struct_g {
    void* parent;
    int* arg;
};

struct struct_h {
    void* parent;
};

void h(struct_g* parent) {
    *(parent->parent->c) = 'a';
}

void g(struct_f* parent, int arg) {
    *(parent->i) = 5;

    struct_g sg = {
        .parent = parent,
        .arg = &arg,
    };

    h(sg);
}

void f() {
    int i;
    char c;

    struct_f sf = {
        .parent = NULL,
        .i = &i,
        .c = &c,
    };

    g(sf, 2);
}
```

The code that does this can be found in `codegen.ml`

### Virtual Main
The linkage of the emitted object file with the Grace and C runtime libraries is done using clang.
The linker of clang expects to find an 'int main()' function that signifies the entrypoint of the program.
The way the compiler handles that is as follows:

Consider a simple Grace program
```
fun f(): nothing {}
```

The equivalent LLVM representation (written using C syntax) is:
```
void main_f() {}

int main() {
    main_f();
}
```

The code that does this can be found in `wrapper.ml` (`insert_virtual_main` function) (admittedly probably not the most fitting place for it).

### Function Name Resolution
In Grace, the following is allowed:
```
fun f(): nothing
    fun f(): nothing
        fun f(): nothing
        {}
    {}
{}
```

When un-nesting functions (as shown previously) the names of the functions need to change.
The current implementation would produce the following LLVM IR (in C syntax, ignoring the virtual main for simplicity):
```
void global.f.f.f() {}
void global.f.f() {}
void global.f() {}
```
### Runtime library
The runtime library is implemented in C except for the functions `strlen`, `strcmp`, `strcpy`, `strcat`, which are linked to our program implicitly by clang.
