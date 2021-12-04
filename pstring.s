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
        movq $0, %r11
        leaq (%rdi,%r8), %r10 # loading pstr[iter] adress into r10
        movzb (%r10),%r11 # loading pstr[iter] value into 11b
        cmp %r11b, %sil #checking if the current char is equal to oldChar
        je .if1
        jmp .endif1
        .if1:
            movb %dl, (%r10) # moving newChar into pstr[iter]
        .endif1:
        addq $1, %r8 # increment iter
        cmp %r8, %r9 #while condition
        jns .while
    movq %rdi, %rax # adress of pstring into rax
    ret



    .globl	pstrijcpy
    .type	pstrijcpy, @function 
pstrijcpy: # Pstring* dst, Pstring* src, char i, char j
    movzb %dl, %r8 # iter = i
    movzb (%rdi), %r11 # r11 = lenn(dst)
    movzb (%rsi), %r10 # r10 = len(src)
    cmp %r11b, %cl # if j >= len(dst) jump .if2
    jge .if2
    cmp %r10b, %cl # if j >= len(src) jump .if2
    jge .if2
    cmp $0, %cl # if i < 0 jump .if2
    js .if2
    cmp %dl, %cl # if j < i jump .if2
    js .if2
    jmp .cont # if all is well, continue
    .if2: # print error
        xorq %rax, %rax
        movq $errout, %rdi
        call printf@plt
        movq $-1, %rax
        ret
    .cont:
        movzb %dl, %r8 #initializing iter to i
        add $1, %r8 # adding 1 to ignore len char at start of string
        add $1, %rcx
        .while2:
            leaq (%rsi, %r8), %r9 # r9 = src + iter
            leaq (%rdi, %r8), %r10 # r10 = dst + iter
            movzb (%r9), %r11
            movb %r11b, (%r10) # dst[r10] = src[r9]
            addq $1, %r8 # iter++
            cmp %r8, %rcx # if iter > j, exit loop
            jns .while2
        movq %rdi, %rax
        ret


    .globl	swapCase
    .type	swapCase, @function
swapCase: # Pstring* p1
    leaq 1(%rdi), %rsi # put address of string into rsi
    movzb (%rdi), %rdx # length of p1 into rdx
    movq $1, %rcx # initializing iter
    .while3:
        leaq (%rdi, %rcx), %rsi # rsi = rdi + iter
        movzb (%rsi), %r8 # r8 = p1[iter]
        cmp $65, %r8  # if A > r8  continue
        jb  .cont2
        cmp $122, %r8  # if z < r8 continue
        jns .cont2
        cmp  $90, %r8 # if r8 < [ make it lower case
        js .upper
        cmp $97, %r8  # if r8 > ' make it upper case
        jns .lower
        jmp .cont2 # if none of the above apply continue
        .lower:
            subq $32, (%rsi) # sub 32 from lower case ascii to make it upper case
            jmp .cont2
        .upper: # add 32 to an uppercase ascii to make it lower case
            addq $32, (%rsi)
        .cont2:
            addq $1, %rcx
            cmp %rcx, %rdx # if iter >= len
            jns .while3
    movq %rdi, %rax
    ret


    .globl	pstrijcmp
    .type	pstrijcmp, @function
pstrijcmp: # Pstring* 1, Pstring* 2, char i, char j
    movzb %dl, %r8 # iter = i
    movzb (%rdi), %r11 # r11 = lenn(1)
    movzb (%rsi), %r10 # r10 = len(2)
    cmp %r11b, %cl # if j >= len(1) jump .if2
    jge .if3
    cmp %r10b, %cl # if j >= len(2) jump .if2
    jge .if3
    cmp $0, %cl # if i < 0 jump .if2
    js .if3
    cmp %dl, %cl # if j < i jump .if2
    js .if3
    jmp .cont5 # if all is well, continue
    .if3: # print error
        xorq %rax, %rax
        movq $errout, %rdi
        call printf@plt
        movq $-2, %rax
        ret
    .cont5:
        movzb %dl, %r8 #initializing iter to i
        add $1, %r8 # adding 1 to ignore len char at start of string
        add $1, %rcx
        .while4:
            leaq (%rsi, %r8), %r9 # r9 = 2 + iter
            leaq (%rdi, %r8), %r10 # r10 = 1 + iter
            movzb (%r9), %r9 # r9 = 2[r9]
            movzb (%r10), %r10 # r10 = 1[r10]
            cmp %r9, %r10
            je .cont4
            js .r9Bigger
            jns .r10Bigger
            .r9Bigger:
                movq $-1, %rax
                ret
            .r10Bigger:
                movq $1, %rax
                ret
            .cont4:
            addq $1, %r8 # iter++
            cmp %r8, %rcx # if iter > j, exit loop
            jns .while4
        movq $0, %rax
        ret


# working print:
    #push %rbxv
    #xorl %eax, %eax
    #movzbl (%rdi), %esi
    #push %rdi
    #movq $strlenout, %rdi
    #call printf
    #pop %rbx
    #ret

