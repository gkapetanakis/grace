extern void __strcpy(char*, const char*);
extern void writeString(const char*);

int main() {
  char dest[15];
  char src[15] = {
    'd','e','e','z','\0'
  };

  __strcpy(dest, src);

  writeString(dest);
  writeString("\n");
  writeString(src);

  return 0;
}
