.section .data

.section .bss

# CHAMADAS DE SISTEMA
.equ EXIT, 60
.equ SYS_READ, 0 # ler caracteres / rdi = file descriptor (STDIN é o padrão) / rsi = endereço dos caracteres / rdx = conta os caracteres lidos com sucesso
.equ SYS_WRITE, 1 # escreve caracteres / rdi = file descriptor (STDOUT é o padrão) / rsi = endereço dos caracteres / rdx = conta os caracteres escritos com sucesso
.equ SYS_OPEN, 2 # abre o arquivo / rdi = endereço de NULL terminado com o nome do arquivo / rsi = flag de status do arquivo (O_RDONLY é o padrão)
.equ SYS_CLOSE, 3 # fecha arquivo / rdi = file descriptor
.equ SYS_CREATE, 85 # abre ou cria arquivo / rdi = endereço de NULL terminado com o nome do arquivo / rsi = flags de modo de arquivo
.equ SYS_LSEEK, 8 # reposiciona ponteiro para ler/escrever no arquivo / rdi = file descriptor / rsi = offset / rdx = origem

# PERMISSÕES DE ARQUIVO
.equ O_CREATE, 64 # se o arquivo não existe cria uma versão truncada (vazia) dele (Read only)
.equ O_TRUNC, 512 # se o arquivo já existe, trunca ele (write only) 
.equ APPEND, 1024 # antes da operação de escrita, coloca o ponteiro no final do arquivo (Read/Write)


.section .text
.globl _start

_start:

movq EXIT, %rax
syscall
