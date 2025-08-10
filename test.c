#include <limits.h>
#include <stdint.h>
#include <stdio.h>
extern int _fprintf(FILE *stream, const char *format, ...);
extern int _fscanf(FILE *stream, const char *format, ...);
extern int _fclose(FILE *stream);
extern FILE *_fopen(const char *filename, const char *mode);
extern int _scanf(const char *format, ...);
extern int _printf(const char *format, ...);

void test_printf() {
  _printf("Testes _printf:\n");
  int n = _printf(
      ">>>Teste 1:\ninteiro 1: %d\ninteiro 2: %d\ninteiro 3: %d\ninteiro 4: "
      "%d\ninteiro "
      "5: %d\ninteiro 6: %d\nlong int 1: %ld\nlong int 2: %ld\n",
      12, 32, 0, -900, INT32_MIN, INT32_MAX, LONG_MAX, LONG_MIN);
  _printf("Quantidade de caracteres impressos: %d\n\n", n);
  n = _printf(
      ">>>Teste 2:\nstring 1: %s\nstring 2: %s\ncaractere 1: %c\ncaractere 2: "
      "%c\nstring 3: %s\ncaractere 3: %c\n",
      "Um carro vermelho", "Um carro amarelo", 'A', 'b', "Um carro azul", 'C');
  _printf("Quantidade de caracteres impressos: %d\n\n", n);
  n = _printf(
      ">>>Teste 3:\nfloat 1: %f\nfloat 2: %f\nfloat 3: %f\nfloat 4: "
      "%f\nfloat 5: %f\ndouble 1: %lf\ndouble 2: %lf\nstring 1: %s\ncaractere "
      "1: %c\ninteiro 1: %d\nstring 2: %s\ncaractere 2: %c\nlong int 1: "
      "%ld\n",
      3.14, 0.0, -15.0, 0.0002, 212.008, 2198323.1, -23484.001,
      "Meu carro rosa", 'M', 0, "Minha carroça", 'l', 100);
  _printf("Quantidade de caracteres impressos: %d", n);
}

void test_scanf() {
  int a;
  long int b;
  char c[100];
  char d;
  float e;
  double f;
  _printf("Teste _scanf (não utilizar string[3º parâmetro] com espaço)\n");
  _printf(
      ">>>Digite: int, long int, string (sem espaços), char, float e double: ");
  int n = _scanf("%d%ld%s%c%f%lf", &a, &b, &c, &d, &e, &f);
  _printf("\nint: %d\nlong int: %ld\nstring: %s\nchar: %c\nfloat: %f\ndouble: "
          "%lf\n",
          a, b, c, d, e, f);
  _printf("Quantidade de leituras realizadas: %d", n);
}

void test_fprintf(char nome_arquivo[]) {
  FILE *arquivo = _fopen(nome_arquivo, "w");
  _fprintf(arquivo, "Testes _printf:\n");

  _printf("Testes _fprintf:\n");
  int n = _fprintf(
      arquivo,
      ">>>Teste 1:\ninteiro 1: %d\ninteiro 2: %d\ninteiro 3: %d\ninteiro 4: "
      "%d\ninteiro "
      "5: %d\ninteiro 6: %d\nlong int 1: %ld\nlong int 2: %ld\n",
      12, 32, 0, -900, INT32_MIN, INT32_MAX, LONG_MAX, LONG_MIN);
  _printf("Quantidade de caracteres impressos: %d\n", n);
  n = _fprintf(
      arquivo,
      ">>>Teste 2:\nstring 1: %s\nstring 2: %s\ncaractere 1: %c\ncaractere 2: "
      "%c\nstring 3: %s\ncaractere 3: %c\n",
      "Um carro vermelho", "Um carro amarelo", 'A', 'b', "Um carro azul", 'C');
  _printf("Quantidade de caracteres impressos: %d\n", n);
  n = _fprintf(
      arquivo,
      ">>>Teste 3:\nfloat 1: %f\nfloat 2: %f\nfloat 3: %f\nfloat 4: "
      "%f\nfloat 5: %f\ndouble 1: %lf\ndouble 2: %lf\nstring 1: %s\ncaractere "
      "1: %c\ninteiro 1: %d\nstring 2: %s\ncaractere 2: %c\nlong int 1: "
      "%ld\n",
      3.14, 0.0, -15.0, 0.0002, 212.008, 2198323.1, -23484.001,
      "Meu carro rosa", 'M', 0, "Minha carroça", 'l', 100);
  _printf("Quantidade de caracteres impressos: %d", n);
  _fclose(arquivo);
}

void test_fscanf() {
  _printf("Testes _fscanf:\n");
  FILE *arquivo = _fopen("felipe-rodrigues-teste-_fscanf.txt", "w");
  _fprintf(arquivo, "%s %c %d %ld %f %lf", "stringuinha", 'L', INT32_MAX,
           LONG_MIN, 9023.2, -983432.123);
  _fclose(arquivo);
  char a[100];
  char b;
  int c;
  long int d;
  float e;
  double f;
  _fopen("felipe-rodrigues-teste-_fscanf.txt", "r");
  int n = _fscanf(arquivo, "%s%c%d%ld%f%lf", &a, &b, &c, &d, &e, &f);
  _printf(
      "string: %s\nchar: %c\nint: %d\nlong int: %ld\nfloat: %f\ndouble: %lf", a,
      b, c, d, e, f);
  _printf("\nQuantidade de leituras realizadas: %d", n);
  _fclose(arquivo);
}

int main() {
  _printf(
      "\n===================================================================="
      "==================\n");
  test_printf();
  _printf(
      "\n===================================================================="
      "==================\n");
  test_scanf();
  _printf(
      "\n===================================================================="
      "==================\n");
  test_fprintf("felipe-rodrigues-teste-_fprintf.txt");
  _printf("\n=================================================================="
          "====================\n");
  test_fscanf();
  _printf("\n=================================================================="
          "====================\n");
  return 0;
}
