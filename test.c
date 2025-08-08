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

  _printf("p1 = %d, p2 = %f, p3 = %s, p4 = %ld, p5 = %c, p6 = %lf", p1, p2, p3,
          p4, p5, p6);
  return 0;
}
