       .file	"pstring.s"
       .data 
       .section  .rodata
errout:
     .string "invalid input!\n"
strlenout:
     .string "len is: %d\n"

	.text

	.globl	pstrlen
	.type	pstrlen, @function
pstrlen: #Pstring* p1
    movb (%rdi), %al
    ret

    .globl	replaceChar
	.type	replaceChar, @function
replaceChar: #Pstring* pstr, char oldChar, char newChar
    movq $1, %r8 #clearing iterator starting from 1 bc. pstr[0] is the length
    movq $0, %r10
    movzbq (%rdi), %r9 #inserting value of pstr.length into r9b
    .while: # r8 < pstr.length(r9b)
        leaq (%rdi,%r8), %r10 # loading pstr[iter] adress into r10
        movb (%r10),%r11b # loading pstr[iter] value into 11b
        test %r11b, %sil #checking if the current char is equal to oldChar
        je .if1
        jmp .endif1
        .if1:
            movb %dl, (%r10) # moving newChar into pstr[iter]
        .endif1:
        addq $1, %r8 # increment iter
        test %r8, %r9 #while condition
        je .while
    movq %rdi, %rax # adress of pstring into rax
    ret



    .globl	pstrijcpy
    .type	pstrijcpy, @function 
pstrijcpy: # Pstring* dst, Pstring* src, char i, char j
    movb %dl, %r8b # iter = i
    cmp (%rdi), %dl # if i is bigger than len(dst) jump .if2
    jns .if2
    cmp (%rsi), %dl # if i is bigger than len(src) jump .if2
    jns .if2
    cmp $0, %cl # if j < 0 jump .if2
    js .if2
    cmp %cl, %dl # if j < i jump .if2
    js .if2
    jmp .cont
    .if2: # print error
        xorq %rax, %rax
        push %rsi
        movq errout, %rsi
        call printf@plt

    .cont:
        
    
# working print:
    #push %rbx
    #xorl %eax, %eax
    #movzbl (%rdi), %esi
    #push %rdi
    #movq $strlenout, %rdi
    #call printf
    #pop %rbx
    #ret

