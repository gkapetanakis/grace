extern void strcpy(char*, const char*);
extern void writeString(const char*);

int main() {
  char dest[15];
  char src[15] = {
    'd','e','e','z','\0'
  };

  strcpy(dest, src);
  writeString(dest);
  writeString("\n");
  writeString(src);
  writeString("\n");

  return 0;
}
