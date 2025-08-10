#include <stdio.h>
extern int _fprintf(FILE *stream, const char *format, ...);
extern int _fscanf(FILE *stream, const char *format, ...);
extern int _fclose(FILE *stream);
extern int _fopen(const char *filename, const char *mode);
extern int _scanf(const char *format, ...);
extern int _printf(const char *format, ...);

int main() {

  char file_name[] = "meu_lidinho_arquivinho.txt";

  char p3[] = "aiaiaiai minha stringinha!!!";

  //  int res = _printf("%lf, %f, %f, %f, %f, %f, %f, %lf, %f, %f, %f, %d, %c,
  //  %c, "
  //                    "%c, %s, %d, %d, %s, %s, %lf, %ld",
  //                    1.2, 2.3, 12.0, -12.6, 90.1, -2.0, 0.0, 0.043, 90.0,
  //                    -1242.1242342, 178.2, 0, 'k', 'b', 'c', p3, 10, 90, p3,
  //                    p3, 12432.90313, 92983712);
  // printf("\nQuantidade de caracteres no _printf: %d\n", res);

  int lula;
  int meu_lar;
  int minha_casa;
  char testeC;
  char lala[300];
  _scanf("%s", &lala);
  _printf("%s\n", lala);

  return 0;
}
