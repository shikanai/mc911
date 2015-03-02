%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

char *concat(int count, ...);

%}
 
%union{
	char *str;
	int  *intval;
}

%token <str> T_STRING
%token T_TEXTBF
%token T_TEXTIT
%token WHITESPACE
%token T_ITEMIZE
%token T_ITEMIZE_END

%start stmt_list

%error-verbose
 
%%

stmt_list: 	stmt_list stmt 
	 |	stmt 
;

stmt:
		text_bf_stmt	{printf("estou no stmt\n");}
;
text_bf_stmt:
		T_TEXTBF '{' expression_st '}'{
		printf("encontrei o T_TEXTBF\n");
	}
;

text_it_stmt:
		T_TEXTIT '{' expression_st '}'{
		printf("encontrei o T_TEXTIT\n");
	}
;

itemize_stmt:
		T_ITEMIZE  item_st_list T_ITEMIZE_END {
		printf("itens\n");
	}
;

item_st_list: item
	| item item_st_list
;

item_st: '\item' item_st_mark expression_st
;
		
item_st_mark: 
		MARCADOR {
		printf("com marcador proprio\n");
	}
;
	
expression_st : T_STRING
      | expression_st T_STRING	{printf("expression_st T_STRING\n");}
;

%%
 
char* concat(int count, ...)
{
    va_list ap;
    int len = 1, i;

    va_start(ap, count);
    for(i=0 ; i<count ; i++)
        len += strlen(va_arg(ap, char*));
    va_end(ap);

    char *result = (char*) calloc(sizeof(char),len);
    int pos = 0;

    // Actually concatenate strings
    va_start(ap, count);
    for(i=0 ; i<count ; i++)
    {
        char *s = va_arg(ap, char*);
        strcpy(result+pos, s);
        pos += strlen(s);
    }
    va_end(ap);

    return result;
}


int yyerror(const char* errmsg)
{
	printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap(void) { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}


