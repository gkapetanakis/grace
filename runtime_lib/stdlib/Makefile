SRC=$(wildcard *.c)
OBJ=$(SRC:.c=.o)

CC=clang-14
CFLAGS=-Wall -O3

lib: $(OBJ)
	ar -cvq stdlib.a $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

distclean:
	make clean
	rm *.a

clean:
	rm *.o