        .file	"func_select.s"
        .section .rodata
Out50:
    .string "first pstring length: %d, second pstring length: %d\n"
ErrChoice:
    .string "invalid option!\n"
RepInputStr:
    .string " %c"
IntInputStr:
    .string "%d"
PrintStr:
    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
PrintPstrCpy:
    .string "length: %d, string: %s\n"
PrintSwapCase:
    .string "length: %d, string: %s\n"
PrintCmpPstr:
    .string "compare result: %d\n"

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
    xorq %rax, %rax
    push %rbp # pushing stack pointer backup
    push %rsi # save p1 and p2 pointers in stack
    push %rdx
    movq %rsp, %rbp
    subq $8, %rsp # opening 8 bytes on stack for user input
    movq $IntInputStr, %rdi # inputting scanf string
    movq %rsp, %rsi # inputting scanf variable address
    push %rax
    call scanf
    pop %rax
    movzbl (%rsp), %r11d
    push %r11 # push received value 1
    movq $IntInputStr, %rdi # same as first scanf
    leaq 12(%rsp), %rsi
    call scanf
    movq $0, %rcx
    leaq 12(%rsp), %r8
    movzbl (%r8), %ecx # received value 2 into 4th argument
    pop %rdx # popping the first index into 3rd argument
    addq $8, %rsp # returning stack ptr to its place
    pop %rsi # popping the ptr to pstr2 into 2 arg
    pop %rdi # popping the ptr to pstr1 into 1 arg
    call pstrijcmp
    movq $PrintCmpPstr, %rdi
    movq %rax, %rsi
    call printf
    .end2:
    pop %rbp
    ret
.L54:
    push %rbp # save rbp
    movq %rsp, %rbp
    movq %rsi, %rdi # move p1 pointer into appropriate register
    push %rdx # save p2 for later
    call swapCase
    movq %rax, %rsi # save return p1 ptr
    pop %rdi # pop p2 ptr for swapcase
    push %rsi # save p1 ptr
    call swapCase
    pop %rdx # pop p1 ptr
    push %rax # save return p2 ptr
    movzb (%rdx), %rsi # save p1 len for print
    addq $1, %rdx
    movq $PrintSwapCase, %rdi
    push %rax # dummy push for printf stack alignment
    xorq %rax, %rax
    call printf
    pop %rax
    pop %rdx # pop p2 ptr
    movzb (%rdx), %rsi # p2 len for print
    addq $1, %rdx
    movq $PrintSwapCase, %rdi
    xorq %rax, %rax
    call printf
    pop %rbp
    ret


.L53:
    xorq %rax, %rax
    push %rbp # pushing stack pointer backup
    push %rsi # save p1 and p2 pointers in stack
    push %rdx
    movq %rsp, %rbp
    subq $8, %rsp # opening 8 bytes on stack for user input
    movq $IntInputStr, %rdi # inputting scanf string
    movq %rsp, %rsi # inputting scanf variable address
    push %rax
    call scanf
    pop %rax
    movzbl (%rsp), %r11d
    push %r11 # push received value 1
    movq $IntInputStr, %rdi # same as first scanf
    leaq 12(%rsp), %rsi
    call scanf
    movq $0, %rcx
    leaq 12(%rsp), %r8
    movzbl (%r8), %ecx # received value 2 into 4th argument
    pop %rdx # popping the first index into 3rd argument
    addq $8, %rsp # returning stack ptr to its place
    pop %rsi # popping the ptr to p2 into src arg
    pop %rdi # popping the ptr to p1 into dst arg
    push %rsi
    push %rsi
    call pstrijcpy
    cmp $-1, %rax # if return value is -1 exit with error
    je .end
    movq %rax, %rdx
    addq $1, %rdx # getting the address of p1.str into rdx
    movzb (%rax), %rsi # p1.len into rsi
    movq $PrintPstrCpy, %rdi
    call printf # print p1
    movq $PrintPstrCpy, %rdi
    pop %rdx
    pop %rdx
    movzb (%rdx), %rsi
    add $1, %rdx
    call printf # print p2
    .end:
    pop %rbp
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
    push %r9 # need to push r9 but need the stack to stay 16 aligned for scanf,
    push %r9 # so r9 is pushed twice and popped twice
    call scanf
    pop %r9
    pop %r9
    movq $0, %r10
    movb (%rsp), %r10b #move result into r10
    movzbl %r9b, %esi # clear rsi for replacechar and insert the first char
    movzbl %r10b, %edx #  clear rdx for replacechar and insert the second char
    addq $16, %rsp # restoring the stack to pop pointer to p2
    pop %rdi
    push %r9 # saving first and second chars for second replaceChar call
    push %r10
    call replaceChar
    pop %rdx # new char for replaceChar
    pop %rsi # old char
    pop %rdi # extracting pointer to p1 into rdi
    push %rsi # pushing old char and new char for printf later
    push %rdx # new char
    push %rax # saving ptr to p2 for prnting later
    call replaceChar
    pop %rbx # rbx-> p2
    pop %rdx # new char
    pop %rsi # old char
    leaq 1(%rax), %rcx # now rcx -> p1.str
    leaq 1(%rbx), %r8 # r8-> p2.str
    xorq %rax, %rax # clearing rax for printing
    movq $PrintStr, %rdi
    call printf
    pop %rbp # restoring the stack pointer
    ret

.LNULL: # incorrect option picked
   xorq %rax, %rax
   push %rax
   movq $ErrChoice, %rdi
   call printf # print error message and quit
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

