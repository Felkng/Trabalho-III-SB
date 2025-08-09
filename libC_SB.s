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


# CONSTANTES NO GERAL
.equ NUMERO_STRING_BUFFER, 64

.section .text
.globl _fprintf
.globl _fclose
.globl _fscanf
.globl _fopen
.globl _printf
.globl _scanf



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

_int_to_string:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rbx #string
  pushq %r12 #10
  pushq %r13 #sinal
  pushq %r14 #final da string
  movq %rdx, %rax #rax = numero

  movq $10, %r12
  movq %rcx, %rbx
  movq %rbx, %r14
  movq $0, %r13

  cmp $0, %rax
  jne _not_zero1

  _is_zero1:
    movb $'0', (%rbx)  
    incq %rbx
    movb $0, (%rbx)
    movq %rbx, %rax
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    popq %rbp
    ret
  _not_zero1:

  cmp $0, %rax
  jge _integer_conversor
  movq $1, %r13
  imulq $-1, %rax

  _integer_conversor:
    addq $63, %r14
    movb $0, (%r14)

    _for2:
      movq $0, %rdx
      divq %r12

      addb $'0', %dl
      subq $1, %r14
      movb %dl, (%r14)

      cmp $0, %rax
      jne _for2
    _end_for2:

    cmp $1, %r13
    jne _end_is_negative1
    _is_negative1:
      subq $1, %r14
      movb $'-', (%r14)
    _end_is_negative1:
    movq %r14, %rax

    popq %r14
    popq %r13
    popq %r12
    popq %rbx
  popq %rbp
ret


_handle_print_formatter:
# rdi = string
# rsi = posição da string
# rdx = proximo parâmetro do printf
# rcx = buffer de string para impressao
  pushq %rbp
  movq %rsp, %rbp
  pushq %rbx
  pushq %r12
  movb (%rdi, %rsi, 1), %bl
  movq $0, %r12

  _is_long:
    cmp $'l', %bl
    jne _end_long_check
    
    incq %rsi
    movb (%rdi, %rsi, 1), %bl
    _if2:
      cmp $'f', %bl
      jne _else_if2
      movq $1, %r12
      jmp _case_float
    _else_if2:
      movq $2, %r12
      jmp _case_integer
  _end_long_check:

  _handler_print:
    _case_integer:
      cmp $'d', %bl
      jne _case_string
      call _int_to_string
      movq %rax, %rcx 
      movq %rax, %rdi 
      call _get_string_len
      jmp _end_handler_print

    _case_string:
      cmp $'s', %bl
      jne _case_char 

      #faz alguma coisa 
      jmp _end_handler_print

    _case_char:
      cmp $'c', %bl    
      jne _case_float

      #faz alguma coisa
      jmp _end_handler_print

    _case_float:
      cmp $'f', %bl
      jne _end_handler_print

      #faz alguma coisa

  _end_handler_print:
  popq %r12
  popq %rbx
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
  pushq %r14 #paramters pointer
  pushq %r15 #contador de caractere

  movq $-40, %r14
  movq $0, %r12
  movq -48(%rbp), %r13
  movq $0, %r15
  _for1:
    movb (%r13, %r12, 1), %bl
    cmp $0, %bl
    je _end_for1
    
    _checkpercent:
      cmp $'%', %bl
      jne _normal_caracter
    
      _if1:
        cmp $0, %r14
        jne _end_if1
        movq $16, %r14
      _end_if1:
      
      incq %r12 # já pega o caracter depois do %
      movq %r13, %rdi #rdi = string
      movq %r12, %rsi #rsi = posicao atual da string
      movq (%rbp,%r14), %rdx #rdx = proximo parametro do printf
      subq $NUMERO_STRING_BUFFER, %rsp
      movq %rsp, %rcx #string para salvar o parâmetro formatado
      
      call _handle_print_formatter

      movq %rax, %rdx #quantidade de caracteres para imprimir
      addq %rax, %r15
      movq %rcx, %rsi
      movq $SYS_WRITE, %rax
      movq $STDOUT, %rdi
      syscall
      addq $NUMERO_STRING_BUFFER, %rsp

      addq $8, %r14

      jmp _inc_for1

    _normal_caracter:
      incq %r15
      leaq (%r13, %r12, 1), %rsi
      movq $SYS_WRITE, %rax
      movq $STDOUT, %rdi
      movq $1, %rdx
      syscall

    _inc_for1:

    incq %r12
    jmp _for1
  _end_for1:

  movq %r15, %rax

  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %rbx
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %r8
  popq %r9
  popq %rbp
ret
