SRC=$(wildcard *.c)
OBJ=$(SRC:.c=.o)

CC=clang-16
CFLAGS=-Wall -O3

lib: $(OBJ)
	ar -cvq stdio.a $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

distclean:
	make clean
	rm *.a

clean:
	rm *.o