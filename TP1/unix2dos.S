#include <mips/regdef.h>
#include <sys/syscall.h>
#define SALIDA_EXITOSA 0
#define ERROR -1
#define ARCHIVO_NULO -1
#define ENTRADA_ESTANDAR 0
#define SALIDA_ESTANDAR 1

	#int myRead(file,buffer,cantidad)
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
	sw		ra,24($fp)
	sw		a0,0($fp)
	sw		a1,4($fp)
	sw		a2,8($fp)
	lw		a0,0($fp)
	lw		a1,4($fp)
	lw		a2,8($fp)
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
	lw		ra,24($fp)
	lw		$fp,20(sp)
	addu	sp, sp,32
	j		ra
	.end	myRead

#int myWrite(file, buffer,cantidad)
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
	sw		ra,24($fp)
	sw		a0,0($fp)
	sw		a1,4($fp)
	sw		a2,8($fp)
	lw		a0,0($fp)
	lw		a1,4($fp)
	lw		a2,8($fp)
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
	lw		ra,24($fp)
	lw		$fp, 20(sp)
	addu	sp, sp, 32
	j		ra
	.end	myWrite

#int processInput(file input, file output)
	.text
	.align	2
	.globl	processInput
	.ent	processInput
processInput:
	.frame	$fp,40,ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,40
	.cprestore  24
	sw		$fp,28(sp)
	move	$fp,sp
	sw		ra,32($fp)
	sw 		zero,4($fp)
	#int tamanio=myRead(file,&buffer,cantidad);
	lw		a0,40($fp)
	sw		a0,0($fp)
	addu	a1,$fp,4
	li		a2,1
	jal		myRead
	sw 		v0,16($fp)
while:
	lw		v0,16($fp)
	blez 	v0,salidaDeProcessInput
	# -if(buffer=='\r')
	lw 		a0,4($fp)
	sll		a0,a0,24
	sra		a0,a0,24
	li		t0,13
	bne		a0,	t0,verSiHaySaltoDeLinea
	#int tamanio=myRead(file,&buffer,cantidad);
	lw		a0,40($fp)
	sw		a0,0($fp)
	addu	a1,$fp,4
	li		a2,1
	jal		myRead
	sw 		v0,16($fp)
	#-if(tamanio == 0){
	bgtz 	v0,fijarseSaltoLinea
    #fprintf(outputFile,"\r")
    lw		a0,44($fp)
	sw		a0,0($fp)
	addu	a1,$fp,4
	li		a2,1
	jal		myWrite
	b		salidaDeProcessInput
fijarseSaltoLinea:
	#-if(buffer=='\n')
	lw		a0,4($fp)
	sll		a0,a0,24
	sra		a0,a0,24
	li		t0,10
	bne		a0,	t0,escribirRetornoDeCarro
escribirSaltoYcarro:
	#myWrite(file,"\r\n",cantidad);
	lw		a0,44($fp)
	sw		a0,0($fp)
	la		a1,saltoCarro
	li		a2,1
	jal		myWrite
	lw		a0,44($fp)
	sw		a0,0($fp)
	la		a1,saltoLinea
	li		a2,1
	jal		myWrite
	b		obtenerCaracter
verSiHaySaltoDeLinea:
	#-else if(buffer=='\n')
	lw		a0,4($fp)
	sll		a0,a0,24
	sra		a0,a0,24
	li		t0,10
	bne		a0,	t0,escribirElCaracter
	b		escribirSaltoYcarro
escribirRetornoDeCarro:
	#myWrite(file,"\r",cantidad);
	lw		a0,44($fp)
	sw		a0,0($fp)
	la		a1,saltoCarro
	li		a2,1
	jal		myWrite
escribirElCaracter:
	#myWrite(file,&buffer,cantidad);
	lw		a0,44($fp)
	sw		a0,0($fp)
	addu	a1,$fp,4
	li		a2,1
	jal		myWrite
obtenerCaracter:
	#tamanio=myRead(&buffer,cantidad,file);
	lw		a0,40($fp)
	sw		a0,0($fp)
	addu	a1,$fp,4
	li		a2,1
	jal		myRead
	sw 		v0,16($fp)
	b 		while
salidaDeProcessInput:
	li 		v0,SALIDA_EXITOSA
	lw		ra,32($fp)
	lw		$fp, 28(sp)
	addu	sp, sp, 40
	j		ra
	.end	processInput

#int main(int argc, char *argv[])
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,64,ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,64
	.cprestore  48
	sw		$fp,52(sp)
	move	$fp,sp
	sw		ra,56($fp)
	sw		a0,36($fp)
	sw		a1,40($fp)
	#int option = 0;
	sw 		zero,16($fp)
	#const char *short_opt = "i:o:hV";
	la		t0,short_opt
	sw		t0,20($fp)
	#struct option long_opt[] =
	la		t0,long_opt
	sw		t0,24($fp)
	#FILE *inputFile = NULL;
	#FILE *outputFile = NULL;
	li		t0,ARCHIVO_NULO
	sw		t0,28($fp)
	sw		t0,32($fp)
	#while ((option = getopt_long(argc, argv, short_opt, long_opt, NULL)) != -1)
while_option:
	lw		a0,36($fp)
	lw		a1,40($fp)
	lw		a2,20($fp)
	lw		a3,24($fp)
	jal		getopt_long
	li		t0,-1
	beq		t0,v0,salirDeWhile
	#case 'V':
case_V:
	li		t0,86
	bne		t0,v0,case_h
	la		a0,imprimir_V
	li		a1,132
	jal		myWrite
	li		v0,SALIDA_EXITOSA
	b		salir
case_h:
	li		t0,104
	bne		t0,v0,case_i
	la		a0,imprimir_h
	li		a1,247
	jal		myWrite
	li		v0,SALIDA_EXITOSA
	b		salir
case_i:
	li		t0,105
	bne		t0,v0,case_o
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
	sw		v0,28($fp)
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
	li		a1,1
	li		a2,0
	li		v0,SYS_open
	syscall
	#-if(inputFile == NULL)
	bltz	v0,errorEnArchivoOutput
	bnez    a3,errorEnArchivoOutput
	sw		v0,32($fp)
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
	lw		t0,28($fp)
	sw		t0,0($fp)
	lw		t0,32($fp)
	sw		t0,4($fp)
	#-if(inputFile == NULL){
	li		t0,ARCHIVO_NULO
	lw		a0,0($fp)
	bne		t0,a0,procesarOutput
	li		t0,0
	sw		t0,0($fp)
	move	a0,t0
procesarOutput:
	#-if(inputFile == NULL)
	li		t0,ARCHIVO_NULO
	lw		a1,4($fp)
	bne		t0,a1,procesarArchivo
	li		t0,1
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
	lw		ra,56($fp)
	lw		$fp, 52(sp)
	addu	sp, sp, 64
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
	            .asciz "	./unix2dos -h\n"
	            .asciz "	./unix2dos -V\n"
	            .asciz "	./unix2dos [options]\n"
	            .asciz "Options: \n"
	            .asciz "	-V, --version  Print version and quit.\n"
	            .asciz "	-h, --help     Print this information.\n"
	            .asciz "	-o, --output   Location of the output file.\n"
	            .asciz "	-i, --input    Location of the input file.\n"
.align 2
guion:			.asciz "-"
