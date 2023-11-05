make lib -C stdio
make lib -C string
make lib -C stdlib

ar -cvqs grace_runtime_lib.a stdio/*.o stdlib/*.o string/*.o
objcopy --redefine-syms=change_syms grace_runtime_lib.a

make distclean -C stdio
make distclean -C stdlib
make distclean -C string