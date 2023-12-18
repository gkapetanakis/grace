# Compiler for the Grace programming language implemented in OCaml

## Software (Requirements/Prerequisites)

This software module works in an environment such as the following:

```
$ dune --version
3.11.1
$ ocamlc --version
4.14.1
$ opam --version
2.1.2
$ clang-14 --version
Ubuntu clang version 14.0.6
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin
$ llvm-config-14 --version
14.0.6
$ opam info llvm

<><> llvm: information on all versions ><><><><><><><><><><><><><><><><><><><><>
name                   llvm
all-installed-versions 14.0.6 [default]
all-versions           3.4  3.5  3.6  3.7  3.8  3.9  4.0.0  5.0.0  6.0.0  7.0.0  8.0.0  9.0.0  10.0.0  11.0.0  12.0.1  13.0.0  14.0.6  15.0.7+nnp-2  16.0.6+nnp

<><> Version-specific details <><><><><><><><><><><><><><><><><><><><><><><><><>
version      14.0.6
repository   default
url.src      "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/llvm-project-14.0.6.src.tar.xz"
url.checksum "sha256=8b3cfd7bc695bd6cea0f37f53f0981f34f87496e79e2529874fd03a2f9dd3a8a"
homepage     "http://llvm.moe"
doc          "http://llvm.moe/ocaml"
bug-reports  "http://llvm.org/bugs/"
dev-repo     "git+http://llvm.org/git/llvm.git"
authors      "whitequark <whitequark@whitequark.org>" "The LLVM team"
maintainer   "Kate <kit.ty.kate@disroot.org>"
license      "MIT"
depends      "ocaml" {>= "4.00.0"}
             "ctypes" {>= "0.4"}
             "ounit" {with-test}
             "ocamlfind" {build}
             "conf-llvm" {build & = version}
             "conf-python-3" {build}
             "conf-cmake" {build}
conflicts    "base-nnp" "ocaml-option-nnpchecker"
synopsis     The OCaml bindings distributed with LLVM
description  Note: LLVM should be installed first.
```

## Usage

You may use the `dune build system` or the `Makefile`, which is essentially a wrapper of dune commands, to build the compiler.

Suppose you execute `make all`. Now you can use the Compiler as follows:
    - `dune exec gracec -- <options passed to compiler>`
    - `dune exec bin/main.exe -- <options passed to compiler>`
    - `dune exec _build/default/bin/main.exe -- <options passed to compiler>`

Installing the compiler will install it as an ocaml module in the `opam directory`.
If you install the compiler you can also execute:
    - `gracec <options passed to compiler>`

`<options passed to compiler>` are the options specified in the language documentation.

Whichever way you may pick to run the compiler, you should do it from the `root directory` of this
project. More specifically, the same directory that contains the `dune-project` file.

`make uninstall` might give you an error:
`Error: Directory /home/<user>/.opam/default/bin is not empty, cannot delete (ignoring).`
Which should be ignored, since it is expected that you usually have more things installed in `opam/default/bin`
directory.

## Overview

The compiler works as follows:
    - Lexical analysis is the first step and is implemented using ocamllex
    - Parsing is done along with the lexical analysis and is implemented using Menhir
    - Semantic analysis is done alongside the parsing
    - After the entire AST has been created and the semantic analysis has concluded,
      it is translated into LLVM IR, using the OCaml LLVM bindings.
    - The IR is (optionally) optimized before being translated to the assembly used by the host machine
    - LLVM emits LLVM IR code (in a `.imm` file), host machine assembly code (in a `.asm` file),
      as well as an object file (in a `.o` file)
    - Clang is finally used to link the `.o` file with the Grace runtime library and the C runtime library
      and create the final executable (in a `.exe` file)
    - If any errors are encountered at any phase of the compilation,
      an error message is output to stderr and the compilation fails

In short, two intermediate representations are used, one that closely matches
the grammar of the language, and LLVM IR.

## Testing

When the compiler is built some semantic tests are run, which the compiler should pass. You can also execute
our semantic tests -both erroneous and correct programs- by running `dune runtest` from the root directory of the project.

## Data Flow

`lexer.mll` tokenizes the input and passes the tokens to `parser.mly`
The functions of `parser.mly` call functions from `wrapper.ml`
The functions of `wrapper.ml` call functions from `sem.ml`, `symbol.ml`
The AST is created
`codegen.ml` does the rest

## Nested Functions

LLVM does not support nested functions, but Grace does.
In order to use LLVM for optimizing and translating to
assembly/machine code the following workaround is done:

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

## Virtual Main

The linkage of the emitted object file with the Grace and C
runtime libraries is done using clang.
The linker of clang expects to find an 'int main()'
function that signifies the entrypointof the program.
The way the compiler handles that is as follows:

Consider a simple Grace program
```
fun f(): nothing {}

// The equivalent LLVM representation (written using C syntax) is:
void main_f() {}

int main() {
    main_f();
}
```

The code that does this can be found in `wrapper.ml`
(admittedly probably not the most fitting place for it)

## Function Name Resolution

In Grace, the following is allowed:
```
fun f(): nothing
    fun f(): nothing
        fun f(): nothing
        {}
    {}
{}
```

When un-nesting functions (as shown previously)
the names of the functions need to change.
The current implementation would produce the following
LLVM IR (in C syntax, ignoring the virtual main for simplicity):
```
void global.f.f.f() {}
void global.f.f() {}
void global.f() {}
```
## Runtime library
The runtime library is implemented in C except for functions:
    - `strlen`
    - `strcmp`
    - `strcpy`
    - `strcat`
which are linked to our program implicitly by clang.