#include <stdio.h>
extern int _fprintf(FILE *stream, const char *format, ...);
extern int _fscanf(FILE *stream, const char *format, ...);
extern int _fclose(FILE *stream);
extern int _fopen(const char *filename, const char *mode);
extern int _scanf(const char *format, ...);
extern int _printf(const char *format, ...);

int main() {

  char file_name[] = "meu_lidinho_arquivinho.txt";

  int p1 = 10;
  float p2 = 32.6;
  char p3[] = "aiaiaiai minha stringinha!!!";
  long int p4 = 97;
  char p5 = 'J';
  long double p6 = 789.90;

  int res = _printf("%ld %d %s %c", p4, -24324, p3, p5);
  printf("\nQuantidade de caracteres no _printf: %d\n", res);
  return 0;
}
