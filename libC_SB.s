.section .data
nome_arquivo: .string "ola mundo.txt"
mensagem: .string "primeira mensagem"
.section .bss

# CHAMADAS DE SISTEMA
.equ EXIT, 60
.equ SYS_READ, 0 # ler caracteres / rdi = file descriptor (STDIN é o padrão) / rsi = endereço dos caracteres / rdx = conta os caracteres lidos com sucesso
.equ SYS_WRITE, 1 # escreve caracteres / rdi = file descriptor (STDOUT é o padrão) / rsi = endereço dos caracteres / rdx = conta os caracteres escritos com sucesso
.equ SYS_OPEN, 2 # abre o arquivo / rdi = endereço de NULL terminado com o nome do arquivo / rsi = flag de status do arquivo (O_RDONLY é o padrão)
.equ SYS_CLOSE, 3 # fecha arquivo / rdi = file descriptor
.equ SYS_CREATE, 85 # abre ou cria arquivo / rdi = endereço de NULL terminado com o nome do arquivo / rsi = flags de modo de arquivo
.equ SYS_LSEEK, 8 # reposiciona ponteiro para ler/escrever no arquivo / rdi = file descriptor / rsi = offset / rdx = origem

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

# PLANO DE JOGO
# Para o printf e o scanf precisa ler o conteúdo caractere por caractere e identificar os %d, %f, %c, etc. E fazer a conversão
# Para o fprintf e o fscanf só precisa ler a string do arquivo ou escrever a string no arquivo
# o fopen e o fclose são apenas chamadas de sistema básicas.

.section .text
.globl _start

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

_fopen:
  pushq %rbp
  movq %rsp, %rbp
  lea nome_arquivo(%rip), %rdi
  movq $(O_CREAT | O_WRONLY), %rsi
  movq $(S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH), %rdx
  movq $SYS_OPEN, %rax
  syscall
  popq %rbp
ret

_fclose:
  pushq %rbp
  movq %rsp, %rbp
  lea nome_arquivo(%rip), %rdi
  movq $SYS_CLOSE, %rax
  syscall
  popq %rbp
ret

_fwrite:
  pushq %rbp
  movq %rsp, %rbp
  pushq %r13

  movq %rdi, %r13 
  lea mensagem(%rip), %rdi
  call _get_string_len
  movq %rax, %rdx
  lea mensagem(%rip), %rsi
  movq %r13, %rdi
  movq $SYS_WRITE, %rax
  syscall

  popq %r13
  popq %rbp
ret

_start:
  pushq %rbp
  movq %rsp, %rbp
  call _fopen 
  movq %rax, %rdi
  movq $SYS_CLOSE, %rax
  syscall 
movq $EXIT, %rax
syscall
