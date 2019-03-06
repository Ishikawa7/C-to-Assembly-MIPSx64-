;#include <stdio.h>
;#include <string.h>
;int processa(char *str, int d)
;{ 	int i,conta;
;	conta=0;
;	for(i=0;i<d;i++)
;	if(str[i]<58) //numeri
;		conta=conta+1;
;	else if(str[i]<91) // lettere maiuscole
;		conta = conta + 2;
;	else conta = conta +3;
;	return conta;
;}

;main( {
;	char STRINGHE[3][24];
;	int dim,A[3],B[3], i, ris;
;	for(i=0;i<3;i++)
;	{ 	printf("Inserire un numero <= 24\n");
;		scanf("%d", &A[i]);
;		do{
;			printf("Inserire una stringa con %d caratteri\n",A[i]);
;			gets(STRINGHE[i]);
;		} while (strlen(STRINGHE[i])!=A[i]);
;	}
;	for(i=0;i<3;i++)
;	{ 	ris = processa(STRINGHE[i],A[i]);
;		if(ris< A[i]*2)
;		B[i]=ris;
;	else B[i]=A[i]*2;
;	}
;	for(i=0;i<3;i++)
;	printf("A[%d]= %d B[%d]= %d\n", i,A[i],i,B[i]);

; NO OPTIMIZATION MERE TRANSLATE
.data
strings: .space 72
A: .space 24
B: .space 24

msg1: .asciiz "Inserire un numero <= 24 \n"
msg2: .asciiz "Inserire una stringa con %d caratteri \n"
msg3: .asciiz "A[%d]= %d B[%d]= %d\n "

par1s5: .space 8
val1: .space 8
val2: .space 8
val3: .space 8
val4: .space 8

par1s3: .word 0
addrs3: .space 8
dims3: .word 24

stack: .space 24

.code

daddi $sp r0 stack
daddi $sp r0 32

ini_for1:
	daddi $s0 r0 0
	daddi $s1 r0 0
for1:
	slti $t0 $s0 24
	beq $t0 r0 ini_for2
	daddi $t0 r0 msg1
	sd $t0 par1s5(r0)
	daddi r14 r0 par1s5
	syscall 5
	jal InputUnsigned
	sd r1 A($s0)
	dadd $s3 r1 r0
	do:
		daddi $t0 r0 msg2
		sd $t0 par1s5(r0)
		sd $s3 val1(r0)
		daddi r14 r0 par1s5
		syscall 5
		daddi $t0  $s1 strings
		sd $t0 addrs3(r0)
		daddi r14 r0 par1s3
		syscall 3
		bne r1 $s3 do
incr_for_1:
	daddi $s0 $s0 8
	daddi $s1 $s1 24
	j for1

ini_for2:
	daddi $s0 r0 0
	daddi $s1 r0 0
for2:
	slti $t0 $s0 24
	beq $t0 r0 ini_for3
	daddi $a0 $s1 strings
	ld $a1 A($s0)
	jal computes
	ld $t0 A($s0)
	dadd $t0 $t0 $t0
	slt $t1 r1 $t0
	beq $t1 r0 save_A2
	save_ris:	sd r1 B($s0)
	j incr_for2
	save_A2: sd $t0 B($s0)
incr_for2:
	daddi $s0 $s0 8
	daddi $s1 $s1 24
	j for2
ini_for3:
	daddi $s0 r0 0
	daddi $s1 r0 0
for3:
	slti $t0 $s0 3
	beq $t0 r0 end
	daddi $t0 r0 msg3
	sd $t0 par1s5(r0)
	ld $t0 A($s1)
	sd $t0 val2(r0)
	ld $t0 B($s1)
	sd $t0 val4(r0)
	sd $s0 val1(r0)
	sd $s0 val3(r0)
	daddi r14 r0 par1s5
	syscall 5
incr_for3:
	daddi $s0 $s0 1
	daddi $s1 $s1 8
	j for3
end: syscall 0

computes:
	daddi $sp $sp -32
	sd $a0 0($sp)
	sd $a1 8($sp)
	sd $s0 16($sp)
	sd $s1 24($sp)

	ini_for_f:
		daddi $s0 r0 0
		daddi $s1 r0 0
	for_f:
		slt $t0 $s0 $a1
		beq $t0 r0 return
		dadd $t0 $a0 $s0
		lbu $t1 0($t0)
		slti $t2 $t1 58
		bne $t2 r0 count1
		slti $t2 $t1 91
		bne $t2 r0 count2
		count3:
			daddi $s1 $s1 1
			j incr_for_f
		count1:
			daddi $s1 $s1 2
			j incr_for_f
		count2:
			daddi $s1 $s1 3
			j incr_for_f
	incr_for_f:
		daddi $s0 $s0 1
		j for_f
	return:
		dadd r1 $s1 r0
		ld  $a0 0($sp)
		ld $a1 8($sp)
		ld $s0 16($sp)
		ld $s1 24($sp)
		daddi $sp r0 32
		jr $ra

#include InputUnsigned.s
