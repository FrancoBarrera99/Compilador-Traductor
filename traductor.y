%{
#include <stdio.h>
%}

%token SI ENTONCES FINSI MIENTRAS FINMIENTRAS SUBPROCESO FINSUBPROCESO TIPO_VARIABLE LEER ESCRIBIR PROCESO FINPROCESO EOL HACER
%token DIGITO ID_VARIABLE OPEN_PAREN CLOSE_PAREN ',' ';'

%%

programa: 
    | programa sentencia EOL
    ;

sentencia:
    SI condicion ENTONCES programa FINSI
    | MIENTRAS condicion HACER programa FINMIENTRAS
    | SUBPROCESO ID_VARIABLE programa FINSUBPROCESO
    | TIPO_VARIABLE ID_VARIABLE ';'
    | LEER ID_VARIABLE ';'
    | ESCRIBIR ID_VARIABLE ';'
    | PROCESO ID_VARIABLE programa FINPROCESO
    ;

condicion:
    OPEN_PAREN expresion CLOSE_PAREN
    ;

expresion:
    DIGITO
    | ID_VARIABLE
    | expresion '+' expresion
    | expresion '-' expresion
    | expresion '*' expresion
    | expresion '/' expresion
    | OPEN_PAREN expresion CLOSE_PAREN
    ;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(const char *msg) {
    fprintf(stderr, "Bison: Error en la línea %d: %s\n", line_number, msg);
    return 1;
}
