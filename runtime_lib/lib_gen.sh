make lib -C stdio
make lib -C stdlib
make lib -C string

ar -cvqs grace_runtime_lib.a stdio/*.o stdlib/*.o
objcopy --redefine-syms=change_syms grace_runtime_lib.a

make distclean -C stdio
make distclean -C stdlib
make distclean -C string

# clang-16 -Wall -nostdinc -nostdlibinc -nobuiltininc -o program program.c grace_runtime_lib.a