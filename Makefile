.PHONY: all install uninstall clean distclean

all:
	cd runtime_lib && make
	@ dune build @install

uninstall:
	@ dune uninstall

clean:
	cd runtime_lib && make clean
	@ dune clean

install: all
	@ dune install

distclean:
	cd runtime_lib && make distclean
	@ dune clean