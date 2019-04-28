#include <mips/regdef.h>
#include <sys/syscall.h>


#define ARCHIVO_ENTRADA 0
#define ARCHIVO_SALIDA 1
#define TAMANIO_BUFFER 1

	#int myRead(char *buffer)
	.text
	.align	2
	.globl	myRead
	.ent	myRead
myRead:
	.frame	$fp,32,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	subu	sp,sp,32
	.cprestore  16
	sw		$fp,20(sp)
	move	$fp,sp
	sw		ra,12($fp)

	move	a1,a0
	li		a0,ARCHIVO_ENTRADA
	li		a2,TAMANIO_BUFFER
	li		v0,SYS_read
	syscall
	#vemos si hay errores primero
	bne		a3, zero, ErrorEnRead
	bgt		zero,v0, ErrorEnRead
	b		salidaDeMyRead
ErrorEnRead:
	#li		v0,-1
	#li	v0, SYS_exit
	#li	a0, 1
	#syscall
salidaDeMyRead:
	lw		ra,12($fp)
	lw		$fp, 20(sp)
	addu	sp, sp, 32
	j		ra
	.end	myRead


#int myWrite(char *buffer)
	.text
	.align	2
	.globl	myWrite
	.ent	myWrite
myWrite:
	.frame	$fp,32,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	subu	sp,sp,32
	.cprestore  16
	sw		$fp,20(sp)
	move	$fp,sp
	sw		ra,12($fp)

	move	a1,a0
	li		a0,ARCHIVO_SALIDA
	li		a2,TAMANIO_BUFFER
	li		v0,SYS_write
	syscall
	#vemos si hay errores primero
	bne		a3, zero, ErrorEnWrite
	bgt		zero,v0, ErrorEnWrite
	b		salidaDeMyWrite
ErrorEnWrite:
	#li		v0,-1
	#li	v0, SYS_exit
	#li	a0, 1
	#syscall
salidaDeMyWrite:
	lw		ra,12($fp)
	lw		$fp, 20(sp)
	addu	sp, sp, 32
	j		ra
	.end	myWrite


#int processInput()
.text
	.align	2
	.globl	processInput
	.ent	processInput
processInput:
	.frame	$fp,32,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	subu	sp,sp,32
	.cprestore  16
	sw		$fp,20(sp)
	move	$fp,sp
	sw		ra,12($fp)

	sw 		zero,0($fp)

	#int tamanio=myRead(&buffer);
	move	a0,$fp
	jal		myRead
	sw 		v0,4($fp)
while:
	lw		v0,4($fp)
	blez v0,salidaDeProcessInput

	# -if(buffer=='\r')
	lw 		a0,0($fp)
	sll		a0,a0,24
	sra		a0,a0,24

	li		t0,13
	bne		a0,	t0,escribirElCaracter

	#tamanio=myRead(&buffer);
	move	a0,$fp
	jal		myRead
	sw 		v0,4($fp)


	#-if(buffer=='\n')
	lw		a0,0($fp)
	sll		a0,a0,24
	sra		a0,a0,24
	li		t0,10
	bne		a0,	t0,escribirRetornoDeCarro

	#myWrite("\n", 1);
	la		a0,saltoLinea
	jal		myWrite
	b		obtenerCaracter
escribirRetornoDeCarro:
	#myWrite("\r", 1);
	la		a0,saltoCarro
	jal		myWrite
escribirElCaracter:
	#myWrite(&buffer, 1);
	move	a0,$fp
	jal		myWrite
obtenerCaracter:
	#tamanio=myRead(&buffer);
	move	a0,$fp
	jal		myRead
	sw 		v0,4($fp)
	b 		while
salidaDeProcessInput:
	li 		v0,0
	lw		ra,12($fp)
	lw		$fp, 20(sp)
	addu	sp, sp, 32
	j		ra
	.end	processInput

saltoLinea:    .asciz  "\n"
saltoCarro:    .asciz  "\r"
