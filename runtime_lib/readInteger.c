#include <stdio.h>

int readInteger() {
    int i;
    if (scanf("%d", &i) > 0) return i;
    return -1;
}
