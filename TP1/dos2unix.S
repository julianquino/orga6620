#include <mips/regdef.h>
#include <sys/syscall.h>



#define SALIDA_EXITOSA 0
#define ERROR -1
#define ARCHIVO_NULO -1
#define ENTRADA_ESTANDAR 0
#define SALIDA_ESTANDAR 1

	#int myRead(char *buffer,int cantidad,file)
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

	move	t0,a1
	move	a1,a0
	move	a0,a2
	move	a2,t0
	li		v0,SYS_read
	syscall
	#vemos si hay errores primero
	bne		a3, zero, ErrorEnRead
	bgt		zero,v0, ErrorEnRead
	b		salidaDeMyRead
ErrorEnRead:
	li	v0, SYS_exit
	li	a0, ERROR
	syscall
salidaDeMyRead:
	lw		ra,12($fp)
	lw		$fp, 20(sp)
	addu	sp, sp, 32
	j		ra
	.end	myRead


#int myWrite(char *buffer, int cantidad,file)
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

	move	t0,a1
	move	a1,a0
	move	a0,a2
	move	a2,t0
	li		v0,SYS_write
	syscall
	#vemos si hay errores primero
	bne		a3, zero, ErrorEnWrite
	bgt		zero,v0, ErrorEnWrite
	b		salidaDeMyWrite
ErrorEnWrite:
	li	v0, SYS_exit
	li	a0, ERROR
	syscall
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
	sw		ra,24($fp)
	sw		a0,8($fp)
	sw		a1,12($fp)
	sw 		zero,0($fp)

	#int tamanio=myRead(&buffer,cantidad,file);
	move	a0,$fp
	li		a1,1
	lw		a2,8($fp)
	jal		myRead
	sw 		v0,4($fp)
while:
	lw		v0,4($fp)
	blez 	v0,salidaDeProcessInput

	# -if(buffer=='\r')
	lw 		a0,0($fp)
	sll		a0,a0,24
	sra		a0,a0,24

	li		t0,13
	bne		a0,	t0,escribirElCaracter

	#tamanio=myRead(&buffer,cantidad,file);
	move	a0,$fp
	li		a1,1
	lw		a2,8($fp)
	jal		myRead
	sw 		v0,4($fp)


	#-if(buffer=='\n')
	lw		a0,0($fp)
	sll		a0,a0,24
	sra		a0,a0,24
	li		t0,10
	bne		a0,	t0,escribirRetornoDeCarro

	#myWrite("\n", 1,file);
	la		a0,saltoLinea
	li		a1,1
	lw		a2,12($fp)
	jal		myWrite
	b		obtenerCaracter
escribirRetornoDeCarro:
	la		a0,saltoCarro
	li		a1,1
	lw		a2,12($fp)
	jal		myWrite
escribirElCaracter:
	#myWrite(&buffer, 2,file);
	move	a0,$fp
	li		a1,1
	lw		a2,12($fp)
	jal		myWrite
obtenerCaracter:
	#tamanio=myRead(&buffer,cantidad,file);
	move	a0,$fp
	li		a1,1
	lw		a2,8($fp)
	jal		myRead
	sw 		v0,4($fp)
	b 		while
salidaDeProcessInput:
	li 		v0,0
	lw		ra,24($fp)
	lw		$fp, 20(sp)
	addu	sp, sp, 32
	j		ra
	.end	processInput

#int main(int argc, char *argv[])
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,80,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	subu	sp,sp,80
	.cprestore  16
	sw		$fp,20(sp)
	move	$fp,sp
	sw		ra,12($fp)
	sw		a0,32($fp)
	sw		a1,36($fp)
	sw		s0,52($fp)
	sw		s1,56($fp)
	#int option = 0;
	sw 		zero,40($fp)

	#const char *short_opt = "i:o:hV";
	la		t0,short_opt
	sw		t0,44($fp)

	#struct option long_opt[] =
	la		t0,long_opt
	sw		t0,48($fp)

	#FILE *inputFile = NULL;
	#FILE *outputFile = NULL;
	li		t0,ARCHIVO_NULO
	move	s0,t0
	move	s1,t0

	#while ((option = getopt_long(argc, argv, short_opt, long_opt, NULL)) != -1)
while_option:
	lw		a0,32($fp)
	lw		a1,36($fp)
	lw		a2,44($fp)
	lw		a3,48($fp)
	jal		getopt_long

	li		t0,-1
	beq		t0,v0,salirDeWhile

	#case 'V':
case_V:
	li		t0,86
	bne		t0,v0,case_h
	#lo de V
	la		a0,imprimir_V
	li		a1,132
	jal		myWrite
	li		v0,SALIDA_EXITOSA
	b		salir
case_h:
	li		t0,104
	bne		t0,v0,case_i
	#lo de h
	la		a0,imprimir_h
	li		a1,247
	jal		myWrite
	li		v0,SALIDA_EXITOSA
	b		salir
case_i:
	li		t0,105
	bne		t0,v0,case_o
	#lo de i
	#-if(strcmp(optarg, "-") != 0)
	lw		a0,optarg
	la		a1,guion
	jal		strcmp
	beq 	v0,zero,while_option

	#inputFile = fopen(optarg, "r");
	lw		a0,optarg
	li		a1,0
	li		a2,0
	li		v0,SYS_open
	syscall

	#-if(inputFile == NULL)
	bltz	v0,errorEnArchivoInput
	bnez    a3,errorEnArchivoInput
	move	s0,v0
	b		while_option
errorEnArchivoInput:
	li		v0,SYS_exit
	li		a0,ERROR
	syscall
case_o:
	li		t0,111
	bne		t0,v0,case_default
	#lo de o
	#-if(strcmp(optarg, "-") != 0)
	lw		a0,optarg
	la		a1,guion
	jal		strcmp
	beq 	v0,zero,while_option

	#inputFile = fopen(optarg, "r");
	lw		a0,optarg
	li		a1,577
	li		a2,0
	li		v0,SYS_open
	syscall

	#-if(inputFile == NULL)
	bltz	v0,errorEnArchivoOutput
	bnez    a3,errorEnArchivoOutput
	move	s1,v0
	b		while_option
errorEnArchivoOutput:
	li		v0,SYS_exit
	li		a0,ERROR
	syscall
case_default:
	li		v0,-1
	lw		ra,12($fp)
	b		salir

salirDeWhile:
	sw		s0,0($fp)
	sw		s1,4($fp)

	#-if(inputFile == NULL){
	li		t0,ARCHIVO_NULO
	lw		a0,0($fp)
	bne		t0,a0,procesarOutput
	li		t0,ENTRADA_ESTANDAR
	sw		t0,0($fp)
	move	a0,t0

procesarOutput:
	#-if(inputFile == NULL)
	li		t0,ARCHIVO_NULO
	lw		a1,4($fp)
	bne		t0,a1,procesarArchivo
	li		t0,SALIDA_ESTANDAR
	sw		t0,4($fp)
	move	a1,t0

procesarArchivo:
	#processInput(file input)
	jal		processInput

	#close(input);
	li		t0,ENTRADA_ESTANDAR
	lw		a0,0($fp)
    beq		t0,a0,closeOutput
    li      v0,SYS_close
    syscall
closeOutput:
	#close(output);
	li		t0,SALIDA_ESTANDAR
	lw		a0,4($fp)
    beq		t0,a0,salir
    li      v0,SYS_close
    syscall
salir:
	li		v0,SALIDA_EXITOSA
	lw		ra,12($fp)
	lw		s0,52($fp)
	lw		s1,56($fp)
	lw		$fp, 20(sp)
	addu	sp, sp, 80
	j		ra
	.end	main

.align 2
version:	.asciz  "version"
.align 2
help:		.asciz  "help"
.align 2
input:		.asciz  "input"
.align 2
output:		.asciz  "output"
        .data
        .align  2
long_opt:
    .word   version
    .word   0
    .word   0
    .word   86
    .word   help
    .word   0
    .word   0
    .word   104
    .word   input
    .word   1
    .word   0
    .word   105
    .word   output
    .word   1
    .word   0
    .word   111
    .word   0
    .word   0
    .word   0
    .word   0
.align 2
short_opt:		.asciz  "i:o:hV"
saltoLinea:    	.asciz  "\n"
saltoCarro:    	.asciz  "\r"
imprimir_V:		.asciz "TP #0 de la materia Organización de Computadoras \n"
				.asciz "Alumnos: \n"
				.asciz "	Bobadilla Catalan German\n"
				.asciz "	Del Carril Manuel \n"
				.asciz "	Quino Lopez Julian \n"
.align 2
imprimir_h:		.asciz "Usage: \n"
	            .asciz "	./dos2unix -h\n"
	            .asciz "	./dos2unix -V\n"
	            .asciz "	./dos2unix [options]\n"
	            .asciz "Options: \n"
	            .asciz "	-V, --version  Print version and quit.\n"
	            .asciz "	-h, --help     Print this information.\n"
	            .asciz "	-o, --output   Location of the output file.\n"
	            .asciz "	-i, --input    Location of the input file.\n"
.align 2
guion:			.asciz "-"
