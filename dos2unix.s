	.file	1 "dos2unix.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"\n\000"
	.align	2
$LC1:
	.ascii	"\r\000"
	.align	2
$LC2:
	.ascii	"%c\000"
	.align	2
$LC3:
	.ascii	"Error fclose: %s\n\000"
	.text
	.align	2
	.globl	processInput
	.ent	processInput
processInput:
	.frame	$fp,48,$31		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$31,40($sp)
	sw	$fp,36($sp)
	sw	$28,32($sp)
	move	$fp,$sp
	sw	$4,48($fp)
	sw	$5,52($fp)
$L18:
	lw	$4,48($fp)
	la	$25,fgetc
	jal	$31,$25
	sw	$2,24($fp)
	lw	$3,24($fp)
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L20
	b	$L19
$L20:
	lw	$3,24($fp)
	li	$2,13			# 0xd
	bne	$3,$2,$L21
	lw	$4,48($fp)
	la	$25,fgetc
	jal	$31,$25
	sw	$2,24($fp)
	lw	$3,24($fp)
	li	$2,10			# 0xa
	bne	$3,$2,$L22
	lw	$4,52($fp)
	la	$5,$LC0
	la	$25,fprintf
	jal	$31,$25
	b	$L18
$L22:
	lw	$4,52($fp)
	la	$5,$LC1
	la	$25,fprintf
	jal	$31,$25
	lw	$4,52($fp)
	la	$5,$LC2
	lw	$6,24($fp)
	la	$25,fprintf
	jal	$31,$25
	b	$L18
$L21:
	lw	$4,52($fp)
	la	$5,$LC2
	lw	$6,24($fp)
	la	$25,fprintf
	jal	$31,$25
	b	$L18
$L19:
	lw	$4,48($fp)
	la	$25,fclose
	jal	$31,$25
	move	$3,$2
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L25
	la	$25,__errno
	jal	$31,$25
	lw	$4,0($2)
	la	$25,strerror
	jal	$31,$25
	la	$4,__sF+176
	la	$5,$LC3
	move	$6,$2
	la	$25,fprintf
	jal	$31,$25
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,28($fp)
	b	$L17
$L25:
	lw	$3,52($fp)
	la	$2,__sF+88
	beq	$3,$2,$L26
	lw	$4,52($fp)
	la	$25,fclose
	jal	$31,$25
	move	$3,$2
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L26
	la	$25,__errno
	jal	$31,$25
	lw	$4,0($2)
	la	$25,strerror
	jal	$31,$25
	la	$4,__sF+176
	la	$5,$LC3
	move	$6,$2
	la	$25,fprintf
	jal	$31,$25
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,28($fp)
	b	$L17
$L26:
	sw	$0,28($fp)
$L17:
	lw	$2,28($fp)
	move	$sp,$fp
	lw	$31,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$31
	.end	processInput
	.size	processInput, .-processInput
	.rdata
	.align	2
$LC5:
	.ascii	"version\000"
	.align	2
$LC6:
	.ascii	"help\000"
	.align	2
$LC7:
	.ascii	"input\000"
	.align	2
$LC8:
	.ascii	"output\000"
	.data
	.align	2
$LC9:
	.word	$LC5
	.word	0
	.word	0
	.word	86
	.word	$LC6
	.word	0
	.word	0
	.word	104
	.word	$LC7
	.word	1
	.word	0
	.word	105
	.word	$LC8
	.word	1
	.word	0
	.word	111
	.word	0
	.word	0
	.word	0
	.word	0
	.globl	memcpy
	.rdata
	.align	2
$LC4:
	.ascii	"i:o:hV\000"
	.align	2
$LC10:
	.ascii	"TP #0 de la materia Organizaci\303\263n de Computadoras "
	.ascii	"\n\000"
	.align	2
$LC11:
	.ascii	"Alumnos: \n\000"
	.align	2
$LC12:
	.ascii	"\tBobadilla Catalan German\n"
	.ascii	"\tDel Carril Manuel \n"
	.ascii	"\tQuino Lopez Julian \n\000"
	.align	2
$LC13:
	.ascii	"Usage: \n\000"
	.align	2
$LC14:
	.ascii	"\t%s -h \n\000"
	.align	2
$LC15:
	.ascii	"\t%s -V \n\000"
	.align	2
$LC16:
	.ascii	"\t%s [options] \n\000"
	.align	2
$LC17:
	.ascii	"Options: \n\000"
	.align	2
$LC18:
	.ascii	"\t-V, --version  Print version and quit. \n\000"
	.align	2
$LC19:
	.ascii	"\t-h, --help     Print this information. \n\000"
	.align	2
$LC20:
	.ascii	"\t-o, --output   Location of the output file. \n\000"
	.align	2
$LC21:
	.ascii	"\t-i, --input    Location of the input file. \n\000"
	.align	2
$LC22:
	.ascii	"-\000"
	.align	2
$LC23:
	.ascii	"r\000"
	.align	2
$LC24:
	.ascii	"Error archivo entrada: %s\n\000"
	.align	2
$LC25:
	.ascii	"w+\000"
	.align	2
$LC26:
	.ascii	"Error archivo salida: %s\n\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,152,$31		# vars= 104, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,152
	.cprestore 24
	sw	$31,144($sp)
	sw	$fp,140($sp)
	sw	$28,136($sp)
	move	$fp,$sp
	sw	$4,152($fp)
	sw	$5,156($fp)
	sw	$0,32($fp)
	la	$2,$LC4
	sw	$2,36($fp)
	addu	$2,$fp,40
	la	$3,$LC9
	move	$4,$2
	move	$5,$3
	li	$6,80			# 0x50
	la	$25,memcpy
	jal	$31,$25
	sw	$0,120($fp)
	sw	$0,124($fp)
$L29:
	addu	$2,$fp,40
	sw	$0,16($sp)
	lw	$4,152($fp)
	lw	$5,156($fp)
	lw	$6,36($fp)
	move	$7,$2
	la	$25,getopt_long
	jal	$31,$25
	sw	$2,32($fp)
	lw	$3,32($fp)
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L31
	b	$L30
$L31:
	lw	$2,32($fp)
	sw	$2,132($fp)
	li	$2,104			# 0x68
	lw	$3,132($fp)
	beq	$3,$2,$L34
	lw	$3,132($fp)
	slt	$2,$3,105
	beq	$2,$0,$L43
	li	$2,86			# 0x56
	lw	$3,132($fp)
	beq	$3,$2,$L33
	b	$L41
$L43:
	li	$2,105			# 0x69
	lw	$3,132($fp)
	beq	$3,$2,$L35
	li	$2,111			# 0x6f
	lw	$3,132($fp)
	beq	$3,$2,$L38
	b	$L41
$L33:
	la	$4,$LC10
	la	$25,printf
	jal	$31,$25
	la	$4,$LC11
	la	$25,printf
	jal	$31,$25
	la	$4,$LC12
	la	$25,printf
	jal	$31,$25
	sw	$0,128($fp)
	b	$L28
$L34:
	la	$4,$LC13
	la	$25,printf
	jal	$31,$25
	lw	$2,156($fp)
	la	$4,$LC14
	lw	$5,0($2)
	la	$25,printf
	jal	$31,$25
	lw	$2,156($fp)
	la	$4,$LC15
	lw	$5,0($2)
	la	$25,printf
	jal	$31,$25
	lw	$2,156($fp)
	la	$4,$LC16
	lw	$5,0($2)
	la	$25,printf
	jal	$31,$25
	la	$4,$LC17
	la	$25,printf
	jal	$31,$25
	la	$4,$LC18
	la	$25,printf
	jal	$31,$25
	la	$4,$LC19
	la	$25,printf
	jal	$31,$25
	la	$4,$LC20
	la	$25,printf
	jal	$31,$25
	la	$4,$LC21
	la	$25,printf
	jal	$31,$25
	sw	$0,128($fp)
	b	$L28
$L35:
	lw	$4,optarg
	la	$5,$LC22
	la	$25,strcmp
	jal	$31,$25
	beq	$2,$0,$L29
	lw	$4,optarg
	la	$5,$LC23
	la	$25,fopen
	jal	$31,$25
	sw	$2,120($fp)
	lw	$2,120($fp)
	bne	$2,$0,$L29
	la	$25,__errno
	jal	$31,$25
	lw	$4,0($2)
	la	$25,strerror
	jal	$31,$25
	la	$4,__sF+176
	la	$5,$LC24
	move	$6,$2
	la	$25,fprintf
	jal	$31,$25
	b	$L29
$L38:
	lw	$4,optarg
	la	$5,$LC22
	la	$25,strcmp
	jal	$31,$25
	beq	$2,$0,$L29
	lw	$4,optarg
	la	$5,$LC25
	la	$25,fopen
	jal	$31,$25
	sw	$2,124($fp)
	lw	$2,124($fp)
	bne	$2,$0,$L29
	la	$25,__errno
	jal	$31,$25
	lw	$4,0($2)
	la	$25,strerror
	jal	$31,$25
	la	$4,__sF+176
	la	$5,$LC26
	move	$6,$2
	la	$25,fprintf
	jal	$31,$25
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,128($fp)
	b	$L28
$L41:
	la	$25,abort
	jal	$31,$25
$L30:
	lw	$2,120($fp)
	bne	$2,$0,$L44
	la	$2,__sF
	sw	$2,120($fp)
$L44:
	lw	$2,124($fp)
	bne	$2,$0,$L45
	la	$2,__sF+88
	sw	$2,124($fp)
$L45:
	lw	$4,120($fp)
	lw	$5,124($fp)
	la	$25,processInput
	jal	$31,$25
	move	$3,$2
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L46
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,128($fp)
	b	$L28
$L46:
	sw	$0,128($fp)
$L28:
	lw	$2,128($fp)
	move	$sp,$fp
	lw	$31,144($sp)
	lw	$fp,140($sp)
	addu	$sp,$sp,152
	j	$31
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
