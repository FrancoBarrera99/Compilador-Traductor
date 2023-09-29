%{
#include "y.tab.h" // Archivo de encabezado generado por Bison

int line_number = 1; // Inicialiar numero de linea de codigo
%}

/* ======= Definición de palabras clave ======= */
Si              "Si"
Entonces        "Entonces"
FinSi           "FinSi"
Mientras        "Mientras"
FinMientras     "FinMientras"
SubProceso      "SubProceso"
FinSubproceso   "FinSubproceso"
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
letra           [a-zA-Z]
simbolo         [a-zA-Z_]
id_variable     {simbolo}{letra}*
tipo_variable   {Logico|Entero|Real|Caracter|Cadena}
espacio         [ \t]+
eol             \n
tab             \t
/* ======= Fin definición de expresiones regulares ======= */

%%

/* ======= Definición de producciones ======= */
{espacio}       ; // Ignorar espacios y tabulaciones

{eol}           { 
                    line_number++; 
                    return EOL; 
                } 

{tab}           { return TAB; }

{Si}            { return SI; }
{Entonces}      { return ENTONCES; }
{FinSi}         { return FINSI; }

{Mientras}      { return MIENTRAS; }
{FinMientras}   { return FINMIENTRAS; }

{SubProceso}    { return SUBPROCESO; }
{FinSubproceso} { return FINSUBPROCESO; }

{Logico}        { return TIPO_VARIABLE; }
{Entero}        { return TIPO_VARIABLE; }
{Real}          { return TIPO_VARIABLE; }
{Caracter}      { return TIPO_VARIABLE; }
{Cadena}        { return TIPO_VARIABLE; }

{Leer}          { return LEER; }
{Escribir}      { return ESCRIBIR; }

{Proceso}       { return PROCESO; }
{FinProceso}    { return FINPROCESO; }

{id_variable}   {id_variable} { return ID_VARIABLE; }

\(              { return 'OPEN_PAREN'; }

\)              { return 'CLOSE_PAREN'; }

,               { return ','; }
;               { return ';'; }

"//"            {
                    while (1) {
                        char c = yyinput(); // Leer siguiente caracter
                        if (c == '\n') 
                        {
                            line_number++; 
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
                            line_number++;
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
                            fprintf(stderr, "FLEX: Error detectado en la línea %d - Comentario no cerrado correctamente.\n", line_number, yytext);
                            exit(1);
                        }
                    }
                }

.               { 
                    fprintf(stderr, "FLEX: Error detectado en la línea %d - Carácter no reconocido '%s'.\n", line_number, yytext); 
                    exit(1);
                }
/* ======= Fin definición de producciones ======= */

%%

/* ======= Codigo usuario ======= */
int main() {
    yylex();
    return 0;
}
/* ======= Fin codigo usuario ======= */
