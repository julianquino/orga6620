#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <getopt.h>
#include <stdbool.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

#define ERROR -1
#define SALIDA_EXITOSA 0


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
                printf(" Quino Lopez Julian\n German bobadilla\n ");
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
                inputFile = fopen(optarg, "r");
                if (inputFile == NULL) {
                	fprintf(stderr, "Error archivo entrada: %s\n", strerror(errno));
                }
                break;
            case 'o':
                // verifico si existe el archivo
                if (access(optarg, W_OK) != -1) {
                    outputFile = fopen(optarg, "w+");
                    if (outputFile == NULL) {
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

    if (inputFile == NULL) {
        inputFile = stdin;
    }

    if (outputFile == NULL) {
        outputFile = stdout;
    }

    //lo que piden

    /*FILE *f;
    FILE *fNuevo;
    int c;
    char direccion[] = "/home/german/Documentos/texto/docLinux";
    char direccionNueva[] = "/home/german/Documentos/texto/docNuevo";
    f = fopen(direccion,"r");
    fNuevo = fopen(direccionNueva,"w");

    while((c=fgetc(f))!=EOF){
        if(c=='\n'){
            fprintf(fNuevo,"\r\n");
        }
        else{
            fprintf(fNuevo,"%c",c);
        }
    }

    fclose(f);
    fclose(fNuevo);

    return 0;
    */



    return SALIDA_EXITOSA;
}
