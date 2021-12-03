#include "pstring.s"
        .file	"func_select.s"
        .section .rodata
Out50:
    .string "first pstring length: %d, second pstring length: %d\n"

.text
.global run_func
run_func:
    movq $60, %rcx
    subq %rdi, %rcx
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
    xorq %rax, %rax
    ret

.LNULL:
   xorq %rax, %rax
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

