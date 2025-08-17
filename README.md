## Objetivo do trabalho:
O trabalho consiste na implementação das funções printf, scanf fopen,
fclose, fprintf e fscanf da biblioteca libC utilizando a linguagem de montagem
(Assembly) da arquitetura de conjunto de instrução x86_64.
As variantes do tipo inteiro válidas nas funções são: char, short, int, long int.
As variantes do tipo real válidas nas funções são: float e double.

## Problema:
A biblioteca padrão do C (conhecida como libc) é uma biblioteca de rotinas
padronizada da linguagem de programação C que contém operações comuns
como tratamento de entrada/saída, operações matemáticas e cadeia de
caracteres.
A entrada e saída de dados são os meios de comunicação do programa com o
ambiente externo, a forma com que o programa recebe os dados a serem
processados de um dispositivo externo e devolve a este a resposta.

- A entrada pode ser feita pelo teclado, mouse, arquivos de texto —
através do redirecionamento da entrada padrão, por exemplo — e de
outros dispositivos físicos de entrada.
- A saída pode ser feita no monitor, na impressora, arquivos texto —
através do redirecionamento da saída padrão.

O controle da entrada e saída (E/S) de dados dos dispositivos é uma das
funções principais de um sistema operacional. Para promover o
compartilhamento seguro do uso dos recursos, não é permitido aos
processos o acesso direto aos dispositivos de entrada e saída. Assim,
cabe ao SO oferecer serviços (chamadas de sistema) que permitam ler e
escrever dados.
A interação dos programas com o SO para o acesso aos dispositivos pode
ocorrer enviando e recebendo bytes de/para dispositivos de caractere, ou
realizando operações de arquivos em dispositivos de bloco

Entrada e saída padrão

Processos comumente solicitam dados de entrada que devem ser fornecidos
pelos usuários. Também é comum a exibição de dados (mensagens) para os
usuários durante a execução de um programa.
Para isso, no Unix, há o conceito de arquivos padrão para entrada, saída e
saída de erros, chamados, respectivamente, de STDIN, STDOUT e STDERR,
esses 3 arquivos estão comumente associados ao terminal (teclado ou
monitor), ou à janela em que o programa foi iniciado.

O trabalho consiste na implementação das funções printf, scanf fopen,
fclose, fprintf e fscanf da biblioteca libC utilizando a linguagem de montagem
(Assembly) da arquitetura de conjunto de instrução x86_64.
Protótipos das funções:
- int printf(const char *format, ...);
- int scanf(const char *format, ...);
- fopen(const char *filename, const char *mode);
- fclose(FILE *stream);
- int fprintf(FILE *stream, const char *format, ...);
- int fscanf(FILE *stream, const char *format, ...);

## Forma de executar o código

Utilizando gcc para compilar os arquivos:

```
gcc -c -g libC_SB.s -o libC_SB.o && gcc -g test.c libC_SB.o

./a.out
```

  
