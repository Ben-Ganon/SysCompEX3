.extern "func_select.s"
.extern "stdio.h"
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

.globl	run_main
.type	run_main, @function
run_main:
    push %rbp
    movq %rsp, %rbp
    movq $PrintInput, %rdi
    call printf
