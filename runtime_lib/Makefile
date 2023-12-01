CC = clang-14
CFLAGS = -Wall -Werror -Wextra
ASFLAGS = -S

SRC_FILES = $(wildcard *.c)
ASM_FILES = $(SRC_FILES:.c=.s)
OBJ_FILES = $(SRC_FILES:.c=.o)
LIBRARY_NAME = libgrace.a

all: $(ASM_FILES) $(OBJ_FILES) $(LIBRARY_NAME)

%.s: %.c
	$(CC) $(CFLAGS) $(ASFLAGS) $< -o $@

%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

$(LIBRARY_NAME): $(OBJ_FILES)
	ar rcs $@ $^

clean:
	rm -f $(ASM_FILES) $(OBJ_FILES) $(LIBRARY_NAME)

distclean: clean
	rm -f *.a

.PHONY: all clean
