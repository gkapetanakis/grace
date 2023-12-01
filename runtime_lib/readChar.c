#include <stdio.h>

char readChar() {
    char c;
    if (scanf("%c", &c) > 0) return c;
    return -1;
}
