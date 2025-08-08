.section .data
nome_arquivo: .string "ola mundo.txt"
mensagem: .string "primeira mensagem aiai ai ui ui ui"
.section .bss

# CHAMADAS DE SISTEMA
.equ EXIT, 60
.equ SYS_READ, 0 # ler caracteres / rdi = file descriptor (STDIN é o padrão) / rsi = endereço dos caracteres / rdx = conta os caracteres lidos com sucesso
.equ SYS_WRITE, 1 # escreve caracteres / rdi = file descriptor (STDOUT é o padrão) / rsi = endereço dos caracteres / rdx = conta os caracteres escritos com sucesso
.equ SYS_OPEN, 2 # abre o arquivo / rdi = endereço de NULL terminado com o nome do arquivo / rsi = flag de status do arquivo (O_RDONLY é o padrão)
.equ SYS_CLOSE, 3 # fecha arquivo / rdi = file descriptor
.equ SYS_CREATE, 85 # abre ou cria arquivo / rdi = endereço de NULL terminado com o nome do arquivo / rsi = flags de modo de arquivo
.equ SYS_LSEEK, 8 # reposiciona ponteiro para ler/escrever no arquivo / rdi = file descriptor / rsi = offset / rdx = origem
.equ STDOUT, 1
.equ STDIN, 0

# PERMISSÕES DE ARQUIVO E FLAGS DE MODO
.equ O_RDONLY, 0        # somente leitura
.equ O_WRONLY, 1        # somente escrita
.equ O_RDWR, 2          # leitura e escrita
.equ O_CREAT, 64        # criar o arquivo se ele não existir
.equ O_TRUNC, 512       # truncar o arquivo para tamanho 0 se ele existir
.equ O_APPEND, 1024     # anexar dados ao final do arquivo

# PERMISSÕES O_CREAT
.equ S_IRUSR, 0400      # permissão de leitura para o proprietário
.equ S_IWUSR, 0200      # permissão de escrita para o proprietário
.equ S_IRGRP, 0040      # permissão de leitura para o grupo
.equ S_IROTH, 0004      # permissão de leitura para outros


.section .text
.globl _fprintf
.globl _fclose
.globl _fscanf
.globl _fopen
.globl _printf
.globl _scanf

_get_string_len:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rbx
  pushq %r12
  xorq %r12, %r12
  _for_len_string:
    movb (%rdi, %r12, 1), %bl
    cmp $0, %bl 
    je _end_for_len_string
    incq %r12
    jmp _for_len_string
  _end_for_len_string:
  movq %r12, %rax
  popq %r12
  popq %rbx
  popq %rbp
ret

#parâmetros de func:(SOMENTE APLICADO PARA INTEIROS, STRINGS E CHAR)
#1º rdi
#2º rsi, 
#3º rdx, 
#4º rcx, 
#5º r8, 
#6º r9, 
#7º+ stack

#parâmetros de float e double:
#1º xmm0
#2º xmm1
#3º xmm2
#4º xmm3

_handle_formatter:
  pushq %rbp
  movq %rsp, %rbp



  popq %rbp
ret

#parâmetros de long float/double vão para o xmm 
_printf:
  pushq %rbp
  movq %rsp, %rbp
  pushq %r9 # -8(%rbp)
  pushq %r8 # -16(%rbp)
  pushq %rcx # -24(%rbp)
  pushq %rdx # -32(%rbp)
  pushq %rsi # -40(%rbp)
  pushq %rdi # -48(%rbp)
  pushq %rbx
  pushq %r12 #iterador
  pushq %r13 #string
  xor %r12, %r12
  movq -48(%rbp), %r13
  _for1:
    movb (%r13, %r12, 1), %bl
    cmp $0, %bl
    je _end_for1
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    leaq (%r13, %r12, 1), %rsi
    movq $1, %rdx
    syscall

    incq %r12
    jmp _for1
  _end_for1:
  popq %r12
  popq %r13
  popq %rbx
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %r8
  popq %r9
  popq %rbp
ret
