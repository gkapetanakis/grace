.DEFAULT_GOAL := all

runtime_lib/libgrace.a:
	cd runtime_lib && make && make clean

runtime: runtime_lib/libgrace.a

runtime_keep_all_files:
	cd runtime_lib && make

gracec:
	@ dune build

install: runtime gracec
	@ dune install
	@ dune clean

install_keep_all_files: runtime gracec
	@ dune install

uninstall: install_keep_all_files
	@ dune uninstall
	@ dune clean

all: runtime gracec

clean:
	cd runtime_lib && make clean
	@ dune clean

distclean:
	cd runtime_lib && make distclean
	@ dune clean

.PHONY: all clean distclean
