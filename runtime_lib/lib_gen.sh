make lib -C stdio
make lib -C stdlib
make lib -C string

ar -cvqs libgrace.a stdio/*.o stdlib/*.o
objcopy --redefine-syms=change_syms libgrace.a

make distclean -C stdio
make distclean -C stdlib
make distclean -C string

# clang-14 -Wall -nostdinc -nostdlibinc -nobuiltininc -o program program.c libgrace.a