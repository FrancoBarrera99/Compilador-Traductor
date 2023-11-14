%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int line_number_bison = 1; // Initialize line number
%}

%token SI ENTONCES FINSI MIENTRAS HACER FINMIENTRAS LEER ESCRIBIR PROCESO FINPROCESO EOL INICIO FIN SINO
%token P1 P2 ',' ';' MAS MENOS POR DIV IGUAL MAYOR MENOR
%token <str> NOMBRE_VARIABLE NUMERO
%token <str> TIPO_BOOLEAN TIPO_CHAR TIPO_FLOAT TIPO_STRING TIPO_INTEGER

%type <str> main tipo programa sentencia condicion expresion subprograma
%left MAS MENOS POR DIV IGUAL MAYOR MENOR

%union {
    char *str; // Define a member 'str' for string values
}

%start main

%%

main:
    INICIO programa FIN		{ printf("#include <stdio.h>\n#include <string.h>\n#include <stdlib.h>\n\nint main(){\n%s}", $2); }
    | INICIO NOMBRE_VARIABLE FIN	{ printf("Mauri"); }
    ;

programa: 
    programa sentencia		{
		char temp[256];
		sprintf(temp, "%s \t%s", $1, $2);
		$$ = strdup(temp);
	}
    | sentencia			{
		char temp[256];
		sprintf(temp, "\t%s", $1);
		$$ = strdup(temp);
	}
    ;

subprograma:
    subprograma sentencia	{
		char temp[256];
		sprintf(temp, "%s \t\t%s", $1, $2);
		$$ = strdup(temp);
	}
    | sentencia		{
		char temp[256];
		sprintf(temp, "\t\t%s", $1);
		$$ = strdup(temp);
	}
    ;

sentencia:
    SI P1 condicion P2 ENTONCES subprograma FINSI ';'		{
		char temp[256];
		sprintf(temp, "if (%s) {\n%s\t};\n", $3, $6);
		$$ = strdup(temp);
	}
    | SI P1 condicion P2 ENTONCES subprograma SINO subprograma FINSI ';'		{
		char temp[256];
		sprintf(temp, "if (%s){\n%s\t}else{\n%s\t};\n", $3, $6, $8);
		$$ = strdup(temp);
	}
    | MIENTRAS P1 condicion P2 HACER subprograma FINMIENTRAS ';'	{
		char temp[256];
		sprintf(temp, "do {\n%s\t} while (%s);\n", $6, $3);
		$$ = strdup(temp);
	}
    | PROCESO NOMBRE_VARIABLE subprograma FINPROCESO ';'		{
		char temp[256];
		sprintf(temp, "function %s() {\n%s\t};\n", $2, $3);
		$$ = strdup(temp);
	}
    | tipo NOMBRE_VARIABLE ';'						{
		char temp[256];
		sprintf(temp, "%s %s;\n", $1, $2);
		$$ = strdup(temp);
	}
    | LEER P1 NOMBRE_VARIABLE P2 ';'					{
		char temp[256];
		sprintf(temp, "scanf (\"valores\", &%s);\t\t//Modificar valores\n", $3);
		$$ = strdup(temp);
	}
    | ESCRIBIR P1 NOMBRE_VARIABLE P2 ';'				{
		char temp[256];
		sprintf(temp, "printf (\"texto\", %s);\t\t//Modificar texto\n", $3);
		$$ = strdup(temp);
	}
    | NOMBRE_VARIABLE IGUAL expresion ';'					{
		char temp[256];
		sprintf(temp, "%s = %s;\n", $1, $3);
		$$ = strdup(temp);
	}								
    ;

tipo:
    TIPO_BOOLEAN 	{$$ = "boolean";}
    | TIPO_INTEGER	{$$ = "int";}
    | TIPO_FLOAT	{$$ = "float";}
    | TIPO_CHAR		{$$ = "char";}
    | TIPO_STRING	{$$ = "string";}
    ;

condicion:
    expresion IGUAL expresion						{
		char temp[256];
		sprintf(temp, "%s == %s", $1, $3);
		$$ = strdup(temp);
	}
    |  expresion MAYOR expresion						{
		char temp[256];
		sprintf(temp, "%s > %s", $1, $3);
		$$ = strdup(temp);
	}
    |  expresion MENOR expresion						{
		char temp[256];
		sprintf(temp, "%s < %s", $1, $3);
		$$ = strdup(temp);
	}
    |  expresion MAYOR IGUAL expresion						{
		char temp[256];
		sprintf(temp, "%s >= %s", $1, $4);
		$$ = strdup(temp);
	}
    |  expresion MENOR IGUAL expresion						{
		char temp[256];
		sprintf(temp, "%s <= %s", $1, $4);
		$$ = strdup(temp);
	}
    ;

expresion:
    NUMERO				{ $$ = $1;}
    | NOMBRE_VARIABLE			{ $$ = $1;}
    | expresion MAS expresion						{
		char temp[256];
		sprintf(temp, "%s + %s", $1, $3);
		$$ = strdup(temp);
	}				
    | expresion MENOS expresion						{
		char temp[256];
		sprintf(temp, "%s - %s", $1, $3);
		$$ = strdup(temp);
	}				
    | expresion POR expresion						{
		char temp[256];
		sprintf(temp, "%s * %s", $1, $3);
		$$ = strdup(temp);
	}				
    | expresion DIV expresion						{
		char temp[256];
		sprintf(temp, "%s / %s", $1, $3);
		$$ = strdup(temp);
	}				
    | P1 expresion P2						{
		char temp[256];
		sprintf(temp, "(%s)", $2);
		$$ = strdup(temp);
	}				
    ;

%%

int main() {	//Se hizo un bucle esta parte para que no salga del programa cuando se presiona enter
    while (1) {
        printf("Ingrese el codigo en Pseudocodigo:\n\n ");
        yyparse();
	if (feof(stdin)) {
            // End of input (EOF) reached
            printf("\nEOF reached.\n");
            break;
        }
    }
    return 0;
}

int yyerror(const char *msg) {
    fprintf(stderr, "Bison: Error en la linea %d: %s\n", line_number_bison, msg);
    return 1;
}
