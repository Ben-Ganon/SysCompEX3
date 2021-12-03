#include "pstring.s"
        .file	"func_select.s"
        .section .rodata
Out50:
    .string "first pstring length: %d, second pstring length: %d\n"
ErrChoice:
    .string "invalid option!\n"
RepInputStr:
    .string " %c"
PrintStr:
    .string "string is: %s\n"

.text
.global run_func
run_func: # opt in rdi, p1 in rsi, p2 in rdx
    movq %rdi, %rcx
    subq $50, %rcx
    cmp  $11, %rcx
    jns .LNULL
    cmp $0, %rcx
    js .LNULL
    jmpq *.switch(,%rcx, 8)
    ret
    

.L50:
    movq %rsi, %rdi # move first string into rdi for strlen
    call pstrlen
    movzbl %al, %esi # move reult of strlen into esi for pritnf
    movq %rdx, %rdi # move second string into rdi for strlen
    call pstrlen
    movzbl %al, %edx # result into edx
    push %r15 # for printf alignment
    xorl %eax, %eax # zero rax
    movq $Out50, %rdi # move print string into rdi
    call printf
    pop %r15
    ret
.L55:

.L54:

    call replaceChar
.L53:
    xorl %eax, %eax


    ret
.L52:
    movq $0, %r9
    xorq %rax, %rax # rax = 0
    push %rbp # push bottom of stack
    movq %rsp, %rbp
    push %rsi # save pointer to p1
    push %rdx # save pointer to p2
    subq $16, %rsp # open space for 2 chars on stack wih 16 alignment
    movq $RepInputStr, %rdi # put scanf string into rdi
    leaq 1(%rsp), %rsi #put the adress of first char into rsi
    call scanf
    leaq 1(%rsp), %rsi
    movb (%rsi), %r9b#move result into r9
    movq $RepInputStr, %rdi
    movq %rsp, %rsi
    xorq %rax, %rax # rax = 0
    push %r9
    push %r9
    call scanf
    pop %r9
    pop %r9
    movq $0, %r10
    movb (%rsp), %r10b #move result into r10
    leaq 24(%rsp), %rdi
    movzbl %r9b, %esi
    movzbl %r10b, %edx
    call replaceChar
    leaq 1(%rax), %rsi
    xorq %rax, %rax
    movq $PrintStr, %rdi
    call printf
    ret

.LNULL:
   xorq %rax, %rax
   push %rax
   movq $ErrChoice, %rdi
   call printf
   pop %rax
   ret
        
    
.section .rodata
    .align 8
.switch:
    .quad  .L50
    .quad  .LNULL
    .quad  .L52
    .quad  .L53
    .quad  .L54
    .quad  .L55
    .quad  .LNULL
    .quad  .LNULL
    .quad  .LNULL
    .quad  .LNULL
    .quad  .L50

