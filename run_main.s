       .file	"run_main.s"
       .data
       .section  .rodata
PrintInput:
    .string "enter length and string\n"
ScanInNum:
    .string "%d"
ScanInString:
    .string "%s"
PrintSelect:
    .string "select function\n"
.text
.globl	run_main
.type	run_main, @function
run_main:
    push %rbp
    movq %rsp, %rbp
    subq $528, %rsp # 256 bytes of pstring x2 plus 4 bytes for opt plus 12 for stack alignment (scanf requires 16)
    movq $ScanInNum, %rdi # scanf string
    leaq (%rsp), %rsi # address of p1.len
    call scanf
    movq $ScanInString, %rdi
    leaq 1(%rsp), %rsi # address of p1.str
    call scanf
    movq $ScanInNum, %rdi # scanf string
    leaq 256(%rsp), %rsi # address of p2.len
    call scanf
    movq $ScanInString, %rdi
    leaq 257(%rsp), %rsi # address of p2.str
    call scanf
    movq $ScanInNum, %rdi
    leaq 512(%rsp), %rsi # address of opt
    call scanf
    leaq 512(%rsp), %rax #address of opt into rax
    movzbl (%rax), %rdi # value of opt into first arg of run_func
    leaq (%rsp), %rsi # address of p1 into run_func second arg
    leaq 256(%rsp), %rdx # address of p2 into run_func third arg
    call run_func # call func select with opt input
    addq $528, %rsp # return stack to oriinal
    pop %rbp
    ret