%{
#include <stdio.h>
#include <string.h>

/* Contador de líneas y columnas */
int linea = 1;
int columna = 1;

/* Función para actualizar columna */
void actualizar_columna() {
    columna += yyleng;
}

/* Función para imprimir tokens */
void imprimir_token(const char* tipo, const char* valor) {
    printf("%-20s %-20s Linea: %d, Columna: %d\n", tipo, valor, linea, columna);
    actualizar_columna();
}
%}

/* Definiciones de patrones */
DIGITO          [0-9]
LETRA           [a-zA-Z]
IDENTIFICADOR   {LETRA}({LETRA}|{DIGITO}|_)*
NUMERO_ENTERO   {DIGITO}+
NUMERO_REAL     {DIGITO}+\.{DIGITO}+
ESPACIO         [ \t]+

%%

    /* Comentarios */
"/*"([^*]|\*+[^*/])*\*+"/"  { 
    imprimir_token("COMENTARIO_BLOQUE", yytext); 
}

"//".*                      { 
    imprimir_token("COMENTARIO_LINEA", yytext); 
}

    /* Palabras reservadas */
"int"           { imprimir_token("PALABRA_RESERVADA", yytext); }
"float"         { imprimir_token("PALABRA_RESERVADA", yytext); }
"double"        { imprimir_token("PALABRA_RESERVADA", yytext); }
"char"          { imprimir_token("PALABRA_RESERVADA", yytext); }
"void"          { imprimir_token("PALABRA_RESERVADA", yytext); }
"short"         { imprimir_token("PALABRA_RESERVADA", yytext); }
"return"        { imprimir_token("PALABRA_RESERVADA", yytext); }
"include"       { imprimir_token("PALABRA_RESERVADA", yytext); }
"define"        { imprimir_token("PALABRA_RESERVADA", yytext); }

    /* Identificadores */
{IDENTIFICADOR} { imprimir_token("IDENTIFICADOR", yytext); }

    /* Literales numéricos */
{NUMERO_REAL}   { imprimir_token("LITERAL_REAL", yytext); }
{NUMERO_ENTERO} { imprimir_token("LITERAL_ENTERO", yytext); }

    /* Operadores */
"++"            { imprimir_token("OPERADOR_INCR", yytext); }
"+"             { imprimir_token("OPERADOR_SUMA", yytext); }
"-"             { imprimir_token("OPERADOR_RESTA", yytext); }
"*"             { imprimir_token("OPERADOR_MULT", yytext); }
"/"             { imprimir_token("OPERADOR_DIV", yytext); }
"="             { imprimir_token("OPERADOR_ASIG", yytext); }

    /* Delimitadores */
"("             { imprimir_token("DELIMITADOR", yytext); }
")"             { imprimir_token("DELIMITADOR", yytext); }
"{"             { imprimir_token("DELIMITADOR", yytext); }
"}"             { imprimir_token("DELIMITADOR", yytext); }
";"             { imprimir_token("DELIMITADOR", yytext); }
","             { imprimir_token("DELIMITADOR", yytext); }

    /* Directivas de preprocesador */
^"#".*          { imprimir_token("PREPROCESADOR", yytext); }

    /* Espacios en blanco */
{ESPACIO}       { columna += yyleng; }

    /* Nueva linea */
\n              { linea++; columna = 1; }

    /* Cualquier otro carácter */
.               { 
    printf("ERROR: Caracter no reconocido '%s' en linea %d, columna %d\n", 
           yytext, linea, columna);
    columna++;
}

%%

int yywrap() {
    return 1;
}