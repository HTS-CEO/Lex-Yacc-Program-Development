%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* For parser */
int yylex();
int yyparse();
void yyerror(const char *s);
FILE *yyin;

/* Global flags */
int is_valid_email = 0;
int in_parser_mode = 0;

%}

/* Lexer patterns */
DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          [a-zA-Z_][a-zA-Z0-9_]*
EMAIL_PART  [a-zA-Z0-9._%+-]
DOMAIN      [a-zA-Z0-9.-]+
TLD         [a-zA-Z]{2,}

/* Parser tokens */
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM
%token EXTERN FLOAT FOR GOTO IF INT LONG REGISTER RETURN SHORT SIGNED
%token SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%token NUMBER IDENTIFIER

%%

/* Character/Digit Identification Mode */
<INITIAL>{
    {LETTER}    { if (!in_parser_mode) printf("Letter: %s\n", yytext); }
    {DIGIT}     { if (!in_parser_mode) printf("Digit: %s\n", yytext); }
}

/* Email Validation Mode */
<INITIAL>{
    ^{EMAIL_PART}+@{DOMAIN}\.{TLD}$ {
        is_valid_email = 1;
        printf("Valid email: %s\n", yytext);
    }
    
    ^.*$ {
        if (!is_valid_email && !in_parser_mode) {
            printf("Invalid email: %s\n", yytext);
        }
        is_valid_email = 0;
    }
}

/* C/C++ Parser Mode */
<INITIAL>{
    "auto"     { if (in_parser_mode) return AUTO; }
    "break"    { if (in_parser_mode) return BREAK; }
    /* Add all other C/C++ keywords similarly */
    
    {DIGIT}+   { if (in_parser_mode) { yylval.num = atoi(yytext); return NUMBER; } }
    {ID}       { if (in_parser_mode) { yylval.id = strdup(yytext); return IDENTIFIER; } }
    
    [ \t\n]    ; /* skip whitespace */
    .          { if (in_parser_mode) return yytext[0]; }
}

%%

/* Parser Grammar */
void parse_program() {
    /* Simplified C/C++ grammar implementation */
    printf("Parser started...\n");
    yyparse();
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        if (strcmp(argv[1], "--parse") == 0) {
            in_parser_mode = 1;
            if (argc > 2) {
                yyin = fopen(argv[2], "r");
                if (!yyin) {
                    perror("Error opening file");
                    return 1;
                }
            }
            parse_program();
            if (argc > 2) fclose(yyin);
            return 0;
        }
    }

    /* Default mode: character/digit and email validation */
    printf("Enter text for analysis (Ctrl+D to end):\n");
    yylex();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parser Error: %s\n", s);
}

int yywrap() {
    return 1;
}
