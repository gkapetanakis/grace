#include <stdio.h>

void _readString(int n, char* s) {
    int i = 0;
    while (i < n - 1) {
        char c = getchar();

        if (c == '\n') { // newline
            break; // stop reading
        }

        if (c < 32) { // control characters are discarded
            if (c == 8) { // backspace
                if (i > 0) { // if not at beginning of string
                    i--; // go back one character
                    s[i] = '\0'; // set current character to null
                }
            }
        }
        else {  // printable character
            s[i] = c; // add character to string
            i++; // increment index
        }
    }
    s[i] = '\0';
}