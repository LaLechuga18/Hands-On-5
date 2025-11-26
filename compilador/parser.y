%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int ival;
    char *str;
}

/* Tokens */
%token <str> ID
%token <ival> NUMBER

%token INT FLOAT DOUBLE CHAR VOID SHORT
%token RETURN INCLUDE DEFINE
%token IF ELSE
%token INCREMENT

/* Precedencia de operadores */
%left '+' '-'
%left '*' '/'

%type <ival> expr

%%

program:
      decl_list
    ;

decl_list:
      decl_list decl
    | decl
    ;

decl:
      global_decl
    | func_decl
    ;

/* ---------------------- */
/* DECLARACIONES GLOBALES */
/* ---------------------- */
global_decl:
      type ID ';'
        { printf("Declaración global: %s\n", $2); }
    ;

/* -------------- */
/* TIPOS DE DATO  */
/* -------------- */
type:
      INT
    | FLOAT
    | DOUBLE
    | CHAR
    | VOID
    | SHORT
    ;

/* ----------------------- */
/* DECLARACION DE FUNCION */
/* ----------------------- */
func_decl:
      type ID '(' param_list_opt ')' block
        { printf("Función declarada: %s\n", $2); }
    ;

/* Parametros */
param_list_opt:
      /* vacio */
    | param_list
    ;

param_list:
      param_list ',' param
    | param
    ;

param:
      type ID
        { printf("Parámetro: %s\n", $2); }
    ;

/* -------- */
/* BLOQUES  */
/* -------- */
block:
      '{' local_decl_list stmt_list '}'
    ;

/* declaraciones locales dentro de funciones */
local_decl_list:
      local_decl_list local_decl
    | /* vacío */
    ;

local_decl:
      type ID ';'
        { printf("Variable local: %s\n", $2); }
    ;

/* ----------- */
/* INSTRUCCIONES */
/* ----------- */
stmt_list:
      stmt_list stmt
    | /* vacio */
    ;

stmt:
      expr ';'
    | ID '=' expr ';'
        { printf("Asignación a: %s\n", $1); }
    | RETURN expr ';'
        { printf("Return statement\n"); }
    | func_call ';'
    | block
    | if_stmt
    ;

/* ----------------- */
/* SENTENCIAS IF     */
/* ----------------- */
if_stmt:
      IF '(' expr ')' stmt
    | IF '(' expr ')' stmt ELSE stmt
    ;

/* ----------------- */
/* LLAMADAS A FUNCION */
/* ----------------- */
func_call:
      ID '(' arg_list_opt ')'
        { printf("Llamada a función: %s\n", $1); }
    ;

arg_list_opt:
      /* vacio */
    | arg_list
    ;

arg_list:
      arg_list ',' expr
    | expr
    ;

/* ----------------- */
/* EXPRESIONES       */
/* ----------------- */
expr:
      NUMBER
        { $$ = $1; }
    | ID
        { $$ = 0; }
    | func_call
        { $$ = 0; }
    | expr '+' expr
        { $$ = $1 + $3; }
    | expr '-' expr
        { $$ = $1 - $3; }
    | expr '*' expr
        { $$ = $1 * $3; }
    | expr '/' expr
        { $$ = $1 / $3; }
    | '(' expr ')'
        { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    extern int linea;
    fprintf(stderr, "Error de sintaxis en linea %d: %s\n", linea, s);
}

int main(int argc, char **argv) {
    printf("=================================================\n");
    printf("  COMPILADOR BÁSICO - Lexer + Parser\n");
    printf("=================================================\n\n");
    
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            fprintf(stderr, "Error: No se pudo abrir el archivo '%s'\n", argv[1]);
            return 1;
        }
        yyin = f;
        printf("Analizando archivo: %s\n\n", argv[1]);
    } else {
        printf("Leyendo desde entrada estandar...\n\n");
    }
    
    int result = yyparse();
    
    if (result == 0) {
        printf("\n=================================================\n");
        printf("  ✓ Analisis completado exitosamente\n");
        printf("=================================================\n");
    } else {
        printf("\n=================================================\n");
        printf("  ✗ Analisis completado con errores\n");
        printf("=================================================\n");
    }
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return result;
}