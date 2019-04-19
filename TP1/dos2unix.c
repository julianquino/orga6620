#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#define ERROR -1
#define SALIDA_EXITOSA 0


/**
 * Procesa el archivo de entrada o el stream ingresado por stdin
 *
 * @param inputFile
 * @param outputFile
 * @return un código
 */



//********************************CODIGO EN ASSEMBLER***********************
//esto en el .S
#define ARCHIVO_ENTRADA 0
#define ARCHIVO_SALIDA 1
#define TAMANIO_BUFFER 1

int myRead(char *buffer){
	int size_byte=read(ARCHIVO_ENTRADA,buffer,TAMANIO_BUFFER);
	if (size_byte < 0 ){
		//error ver que tipo de error
		exit(0);
	}
	return size_byte;
}
int myWrite(char *buffer,int tamanio){
	int size_byte=write(ARCHIVO_SALIDA,buffer,tamanio);
		if (size_byte < 0 ){
			//error ver que tipo de error
			exit(0);
		}
	return size_byte;
}
int processInput() {
	unsigned char buffer;
	int tamanio=myRead(&buffer);
    while(tamanio>0){
        if(buffer=='\r'){
        	tamanio=myRead(&buffer);
        	if(buffer=='\n'){
        		myWrite("\n", 1);
        	}
        	else{
        		myWrite("\r", 1);
				myWrite(&buffer, 1);
        	}
        }
        else{
        	myWrite(&buffer, 1);
        }
        tamanio=myRead(&buffer);
    }
    return SALIDA_EXITOSA;
}
//**********************************FIN ASSEMBLER****************************




int main(int argc, char *argv[]) {
    int option = 0;
    const char *short_opt = "i:o:hV";
    struct option long_opt[] = {
            {"version", no_argument,       NULL, 'V'},
            {"help",    no_argument,       NULL, 'h'},
            {"input",   required_argument, NULL, 'i'},
            {"output",  required_argument, NULL, 'o'},
            {NULL, 0,                      NULL, 0}
    };
    FILE *inputFile = NULL;
    FILE *outputFile = NULL;

    while ((option = getopt_long(argc, argv, short_opt, long_opt, NULL)) != -1) {
        switch (option) {
            case 'V':
                printf("TP #0 de la materia Organización de Computadoras \n");
                printf("Alumnos: \n");
                printf("	Bobadilla Catalan German\n	Del Carril Manuel \n	Quino Lopez Julian \n");
                return 0;
            case 'h':
                printf("Usage: \n");
                printf("	%s -h \n", argv[0]);
                printf("	%s -V \n", argv[0]);
                printf("	%s [options] \n", argv[0]);
                printf("Options: \n");
                printf("	-V, --version  Print version and quit. \n");
                printf("	-h, --help     Print this information. \n");
                printf("	-o, --output   Location of the output file. \n");
                printf("	-i, --input    Location of the input file. \n");
                return 0;
            case 'i':
            	if(strcmp(optarg, "-") != 0){
					inputFile = fopen(optarg, "r");
					if(inputFile == NULL) {
						fprintf(stderr, "Error archivo entrada: %s\n", strerror(errno));
						return ERROR;
					}
            	}
                break;
            case 'o':
            	if(strcmp(optarg, "-") != 0){
					outputFile = fopen(optarg, "w+");
					if(outputFile == NULL) {
						fprintf(stderr, "Error archivo salida: %s\n", strerror(errno));
						return ERROR;
					}
            	}
                break;
            default:
                // así está en el manual de getopt
                abort();
        }
    }

    if(inputFile == NULL) {
        inputFile = stdin;
    }

    if(outputFile == NULL) {
        outputFile = stdout;
    }

    if(processInput() == ERROR) {
    	return ERROR;
    }

    return SALIDA_EXITOSA;
}
