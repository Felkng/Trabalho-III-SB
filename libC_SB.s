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
.equ FLOAT_PRECISION, 6
.equ MAX_BUFFER_INPUT, 1024
.equ MAX_STRING_BUFFER, 256

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
# rdi = numero
# rsi = buffer da string
# retorna a string
  pushq %rbp
  movq %rsp, %rbp
  pushq %rbx #string
  pushq %r12 #10
  pushq %r13 #sinal
  pushq %r14 #final da string
  movq %rdi, %rax #rax = numero

  movq $10, %r12
  movq %rsi, %rbx
  movq %rbx, %r14
  movq $0, %r13

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


_float_to_string:
# xmm0 = numero
# rdi = buffer da string
# retorna a string
  pushq %rbp
  movq %rsp, %rbp

  pushq %rbx
  pushq %r12 # buffer da parte inteira
  pushq %r13 # buffer da parte decimal
  pushq %r14 # numero parte inteira
  pushq %r15 # numero parte decimal

  movq %rdi, %rbx

  subq $NUMERO_STRING_BUFFER, %rsp
  movq %rsp, %r12

  subq $NUMERO_STRING_BUFFER, %rsp
  movq %rsp, %r13

  movq $10, %rax
  cvtsi2sd %rax, %xmm1 # xmm1 = 10
  cvttsd2si %xmm0, %r14 
  
  cvtsi2sd %r14, %xmm2
  subsd %xmm2, %xmm0

  _retira_negativo_do_xmm:
    cmp $0, %r14
    jge _xmm_nao_negativo
    movq $-1, %rax
    cvtsi2sd %rax, %xmm2
    mulsd %xmm2, %xmm0
  _xmm_nao_negativo:
  
  movq %r14, %rdi
  movq %r12, %rsi
  call _int_to_string
  movq %rax, %r12

  movq $0, %rax
  movq %r13, %rsi
  movb $'.', (%rsi)
  incq %rsi

  _for_get_depois_da_virgula:  
    cmp $FLOAT_PRECISION, %rax
    jge _end_for_get_depois_da_virgula

    mulsd %xmm1, %xmm0
    cvttsd2si %xmm0, %r15

    movq %r15, %rdi
    addb $'0', %r15b
    movb %r15b, (%rsi)
    incq %rsi

    cvtsi2sdq %rdi, %xmm2
    subsd %xmm2, %xmm0
    
    incq %rax
    jmp _for_get_depois_da_virgula
  _end_for_get_depois_da_virgula:


  movq %rbx, %rdi
  movq %rdi, %rax
  movq $0, %r14
  movq $0, %r15

  _for_join_two_buffers1:
  movb (%r12, %r14, 1), %bl
  cmp $0, %bl
  je _end_for_join_two_buffers1

  movb %bl, (%rax)
  incq %rax
  incq %r14
  jmp _for_join_two_buffers1
  _end_for_join_two_buffers1:
 

  _for_join_two_buffers2:
  movb (%r13, %r15, 1), %bl
  cmp $0, %bl
  je _end_for_join_two_buffers2

  movb %bl, (%rax)
  incq %rax
  incq %r15
  jmp _for_join_two_buffers2
  _end_for_join_two_buffers2:
  
  movb $0, (%rax)
  movq %rdi, %rax


  addq $NUMERO_STRING_BUFFER, %rsp
  addq $NUMERO_STRING_BUFFER, %rsp
  popq %r15
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
  pushq %r13
  movb (%rdi, %rsi, 1), %bl

  _is_long:
    cmp $'l', %bl
    jne _end_long_check
    
    incq %rsi
    movb (%rdi, %rsi, 1), %bl
    _if2:
      cmp $'f', %bl
      jne _else_if2
      movq (%r10,%r9), %xmm0 #rdx = proximo parametro do printf | r8 = parametro normal | r9 = parametro de xmm | r10 = referencia de rbp em printf
      jmp _is_long_float
    _else_if2:
      movq (%r10,%r8), %rdx #rdx = proximo parametro do printf | r8 = parametro normal | r9 = parametro de xmm | r10 = referencia de rbp em printf
      jmp _is_long_int

  _end_long_check:

  _handler_print:
    _case_integer:
      cmp $'d', %bl
      jne _case_string

      movq (%r10,%r8), %rdx #rdx = proximo parametro do printf | r8 = parametro normal | r9 = parametro de xmm | r10 = referencia de rbp em printf
      movslq %edx, %rdx
      _is_long_int:
      
      movq %rdx, %rdi
      movq %rsi, %r13
      movq %rcx, %rsi
      call _int_to_string
      movq %r13, %rsi
      movq %rax, %rcx

      movq %rax, %rdi
      call _get_string_len
      addq $8, %r8
      jmp _end_handler_print

    _case_string:
      cmp $'s', %bl
      jne _case_char

      movq (%r10,%r8), %rdx #rdx = proximo parametro do printf | r8 = parametro normal | r9 = parametro de xmm | r10 = referencia de rbp em printf
      movq %rdx, %rcx
      movq %rdx, %rdi
      call _get_string_len
      addq $8, %r8
      jmp _end_handler_print

    _case_char:
      cmp $'c', %bl
      jne _case_float

      movq (%r10,%r8), %rdx #rdx = proximo parametro do printf | r8 = parametro normal | r9 = parametro de xmm | r10 = referencia de rbp em printf
      movq %rdx, (%rcx)
      incq %rcx
      movq $0, (%rcx)
      decq %rcx
      movq $1, %rax
      addq $8, %r8
      jmp _end_handler_print

    _case_float:
      cmp $'f', %bl
      jne _end_handler_print

      movq (%r10,%r9), %xmm0 #rdx = proximo parametro do printf | r8 = parametro normal | r9 = parametro de xmm | r10 = referencia de rbp em printf
      cvtsd2ss %xmm0, %xmm0
      _is_long_float:

      movq %rcx, %rdi
      movq %rsi, %r13
      call _float_to_string
      movq %r13, %rsi
      movq %rax, %rcx

      movq %rax, %rdi
      call _get_string_len
      addq $8, %r9

  _end_handler_print:
  popq %r13
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
  subq $8, %rsp
  movsd %xmm7, (%rsp) # -56(%rbp)
  subq $8, %rsp
  movsd %xmm6, (%rsp) # -64(%rbp)
  subq $8, %rsp
  movsd %xmm5, (%rsp) # -72(%rbp)
  subq $8, %rsp
  movsd %xmm4, (%rsp) # -80(%rbp)
  subq $8, %rsp
  movsd %xmm3, (%rsp) # -88(%rbp)
  subq $8, %rsp
  movsd %xmm2, (%rsp) # -96(%rbp)
  subq $8, %rsp
  movsd %xmm1, (%rsp) # -104(%rbp)
  subq $8, %rsp
  movsd %xmm0, (%rsp) # -112(%rbp)
  pushq %rbx

  movq $-40, %r8  #paramters pointer
  movq $-112, %r9  #xmm pointer
  movq %rbp, %r10 # referencia de rbp em r10 

  pushq %r12 # iterador
  pushq %r13 # string
  pushq %r14 # contador de caractere

  movq -48(%rbp), %r13
  movq $0, %r14
  movq $0, %r12 #r12 = iterador
  _for1:
    movb (%r13, %r12, 1), %bl
    cmp $0, %bl
    je _end_for1
    
    _checkpercent:
      cmp $'%', %bl
      jne _normal_caracter
    
      _if1:
        cmp $0, %r8
        jne _end_if1
        _check_r9_pointing_stack:
        cmp $-48, %r9
        jl _r9_still_not_pointing
        
        _r9_already_pointing:
        movq %r9, %r8
        jmp _end_if1
  
        _r9_still_not_pointing:
        movq $16, %r8

      _end_if1:

      _if3:
        cmp $-48, %r9 #verifica se acabou os registradores xmm passados por parâmetro
        jne _end_if3 # se r9 for menor que -48 ele ainda não tá apontado para a pilha
        _check_r8_pointing_stack:
          cmp $0, %r8
          jl _r8_still_not_pointing # se r8 for menor que 0 ele ainda não tá apontando para pilha

        _r8_already_pointing:
          movq %r8, %r9 #passa o ponteiro de r8 para r9
          jmp _end_if3

        _r8_still_not_pointing:
          movq $16, %r9 # se o r8 não tiver apontando para a pilha ainda, o r9 começa a apontar primeiro

      _end_if3:

      _if4:
        cmp $0, %r8
        jl _end_if4
        cmp $-48, %r9
        je _end_if4

        # verifica qual dos dois é maior e sincroniza o menor com o maior
        cmp %r8, %r9
        jle _sinc_r9_to_r8

        _sinc_r8_to_r9:
          movq %r9, %r8 
          jmp _end_if4

        _sinc_r9_to_r8:
          movq %r8, %r9

      _end_if4:
      
      incq %r12 # já pega o caracter depois do %
      movq %r13, %rdi #rdi = string
      movq %r12, %rsi #rsi = posicao atual da string
      subq $NUMERO_STRING_BUFFER, %rsp
      movq %rsp, %rcx #string para salvar o parâmetro formatado
      
      # r8 = paarametros normais 
      # r9 = parametros de xmm
      call _handle_print_formatter

      movq %rsi, %r12
      
      movq %rax, %rdx #quantidade de caracteres para imprimir
      addq %rax, %r14
      movq %rcx, %rsi
      movq $SYS_WRITE, %rax
      movq $STDOUT, %rdi
      syscall
      addq $NUMERO_STRING_BUFFER, %rsp

      jmp _inc_for1

    _normal_caracter:
      incq %r14
      leaq (%r13, %r12, 1), %rsi
      movq $SYS_WRITE, %rax
      movq $STDOUT, %rdi
      movq $1, %rdx
      syscall

    _inc_for1:

    incq %r12
    jmp _for1
  _end_for1:

  movq %r14, %rax
  
  popq %r14
  popq %r13
  popq %r12
  popq %rbx
  addq $64, %rsp #desaloca xmm
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %r8
  popq %r9
  popq %rbp
ret



_get_percent_count:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rbx

  movq $0, %rax
  movq $0, %rsi
  _for_ler_qtd_percents:
    movb (%rdi, %rsi, 1), %bl
    cmp $0, %bl
    je _inc_end_for_ler_qtd_percents
    _verifica_percent:
    cmp $'%', %bl
    jne _inc_end_for_ler_qtd_percents
    incq %rax
    
  _inc_end_for_ler_qtd_percents:
  incq %rsi
  _end_for_ler_qtd_percents:
  
  popq %rbx
  popq %rbp
ret


_get_isolated_string:
  #rdi = input buffer
  #rsi = string buffer
  pushq %rbp
  movq %rsp, %rbp
  pushq %rbx
  pushq %r12
  pushq %r13
  pushq %r14
  movq %rdi, %r13
  movq %rsi, %r14
  movq $0, %r12

  _iterate_string:
    movb (%r13, %r12, 1), %bl
    cmp $' ', %bl
    je _end_of_string
    cmp $'\t', %bl
    je _end_of_string
    cmp $'\n', %bl
    je _end_of_string
    cmp $0, %bl
    je _end_of_string
    movb %bl, (%r14)
    incq %r14
    incq %r12
    jmp _iterate_string
  _end_of_string:

    movb $0, (%r14)
    movq %rsi, %rax

  popq %r14
  popq %r13
  popq %r12
  popq %rbx
  popq %rbp
ret



_handler_scanf:
# rdi = string
# rsi = tamanho da string
pushq %rbp
movq %rsp, %rbp
pushq %rbx
pushq %r12

movq $0, %r12
incq %r9
movb (%r9, %r12, 1), %bl

cmp $'l', %bl
jne _case_scan_d
incq %r9
movb (%r9, %r12, 1), %bl

_case_scan_ld:
cmp $'d', %bl
jne _case_scan_lf
incq %r9

_case_scan_lf:
cmp $'f', %bl
jne _case_scan_d
incq %r9

_case_scan_d:
cmp $'d', %bl
jne _case_scan_d
incq %r9

_case_scan_c:
cmp $'c', %bl
jne _case_scan_s
incq %r9

_case_scan_s:
cmp $'s', %bl
jne _case_scan_d
incq %r9

_case_scan_f:
cmp $'f', %bl
jne _end_handler_scan
incq %r9

_end_handler_scan:
  
  popq %r12
  popq %rbx
  popq %rbp
ret



_scanf:
  pushq %rbp
  movq %rsp, %rbp
  pushq %r9 # -8(%rbp)
  pushq %r8 # -16(%rbp)
  pushq %rcx # -24(%rbp)
  pushq %rdx # -32(%rbp)
  pushq %rsi # -40(%rbp)
  pushq %rdi # -48(%rbp)
  subq $MAX_BUFFER_INPUT, %rsp
  pushq %rbx
  pushq %r12 # input buffer
  pushq %r13 # contador de dados lidos
  pushq %r15
  movq -48(%rbp), %r8 # (apontador para variáveis)
  movq -48(%rbp), %r9 # formatador atual

  movq %rbp, %r10 # cópia de rbp (CAMISA 10)

  _read_input:
    movq %rsp, %rsi
    movq $SYS_READ, %rax
    movq $STDIN, %rdi
    movq $MAX_BUFFER_INPUT, %rdx
    syscall
    movq %rsi, %r12
    movq %r12, %r15
  
  _for_read_buffer_input:
    movq $0, %rax
    movb (%r15, %rax, 1), %bl
    cmp $0, %bl
    je _end_read_buffer_input

    movq %r15, %rdi
    subq $MAX_STRING_BUFFER, %rsp
    movq %rsp, %rsi
    call _get_isolated_string
    movq %rax, %rdi
    call _get_string_len
    movq %rax, %rcx
    addq $MAX_STRING_BUFFER, %rsp #DESALOCA TAMANHO MÁXIMO DE STRING PORQUE AGORA SABE O TAMANHO CERTO
    subq %rcx, %rsp
    movq %r15, %rdi
    movq %rsp, %rsi
    call _get_isolated_string
    movq %rax, %rdi # rdi = string lida | rcx = tamanho da string (UTILIZAR PARA CONTINUAR LENDO O RESTO DO BUFFER)
    lea (%r12, %rcx), %r15
    incq %r15
    
    movq %rcx, %rsi
    call _handler_scanf

    jmp _for_read_buffer_input
  _end_read_buffer_input:

  popq %r15
  popq %r13
  popq %r12
  popq %rbx
  addq $MAX_BUFFER_INPUT, %rsp
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %r8
  popq %r9
  popq %rbp
ret

