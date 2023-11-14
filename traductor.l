%{

#include "traductor.tab.h" // Archivo de encabezado generado por Bison
#include <string.h>

int line_number_flex = 1; // Inicialiar número de línea de código

int yyinput(void) {
    return getc(yyin); // yyin is the default input stream in Flex
}

int yywrap() {
    return 1; // Indicates the end of input
}

%}

/* ======= Definición de palabras clave ======= */
Inicio		"Inicio"
Fin		"Fin"	

Si              "Si"
Entonces        "Entonces"
SiNo		"SiNo"
FinSi           "FinSi"

Mientras        "Mientras"
Hacer		"Hacer"
FinMientras     "FinMientras"

Logico          "Logico"
Entero          "Entero"
Real            "Real"
Caracter        "Caracter"
Cadena          "Cadena"

Leer            "Leer"
Escribir        "Escribir"

Proceso         "Proceso"
FinProceso      "FinProceso"		
/* ======= Fin definición de palabras clave ======= */

/* ======= Definición de expresiones regulares ======= */
digito          [0-9]
numero		{digito}+(\.{digito}+)?
letra           [a-zA-Z]
simbolo         [a-zA-Z_]
nombre_variable {simbolo}{letra}*
espacio         [ \t]+
eol             \n
/* ======= Fin definición de expresiones regulares ======= */

%%

{espacio}       ; 				//Ignorar espacios y tabulaciones
{eol}           { line_number_flex++; } 	//Ignora saltos de linea

{Inicio}	{ return INICIO; }
{Fin}		{ return FIN; }

{Si}            { return SI; }
{Entonces}      { return ENTONCES; }
{SiNo}		{ return SINO; }
{FinSi}         { return FINSI; }

{Mientras}      { return MIENTRAS; }
{Hacer}		{ return HACER;	}
{FinMientras}   { return FINMIENTRAS; }

{Logico}        { return TIPO_BOOLEAN; }
{Entero}        { return TIPO_INTEGER; }
{Real}          { return TIPO_FLOAT; }
{Caracter}      { return TIPO_CHAR; }
{Cadena}        { return TIPO_STRING; }

{Leer}          { return LEER; }
{Escribir}      { return ESCRIBIR; }

{Proceso}       { return PROCESO; }
{FinProceso}    { return FINPROCESO; }

{numero}        {
                    yylval.str = strdup( yytext );
                    return NUMERO;
                }
                
{nombre_variable} { 
                    yylval.str = strdup( yytext );
                    return NOMBRE_VARIABLE; 
                }

\(              { return P1; }
\)              { return P2; }

"+"		{return MAS;}
"-"		{return MENOS;}
"*"		{return POR;}
"/"		{return DIV;}
"="		{return IGUAL;}
">"		{return MAYOR;}
"<"		{return MENOR;}

,               { return ','; }
;               { return ';'; }

"//"            {
                    while (1) {
                        char c = yyinput(); // Leer siguiente caracter
                        if (c == '\n') 
                        {
                            line_number_flex++; 
                            break;
                        }
                        if (c == EOF) {
                            break;
                        }
                    }
                }

"/*"            {
                    while (1) {
                        char c = yyinput(); // Leer siguiente caracter
                        if (c == '\n') 
                        {
                            line_number_flex++;
                            continue;
                        }
                        if(c == '*')
                        {
                            if(yyinput() == '/')
                            {
                                break;
                            }
                        }
                        if (c == EOF) 
                        {
                            fprintf(stderr, "FLEX: Error detectado en la línea %d - Comentario no cerrado correctamente.\n", line_number_flex);
                            exit(1);
                        }
                    }
                }

.               { 
                    fprintf(stderr, "FLEX: Error detectado en la línea %d - Carácter no reconocido.\n", line_number_flex); 
                    exit(1);
                }

%%

/* ======= Código usuario ======= */
//int main() {
//    yylex();
//    return 0;
//}
/* ======= Fin código usuario ======= */
