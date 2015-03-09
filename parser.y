%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

char *concat(int count, ...);
char *title;

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
%token T_GRAPHICS
%token T_ITEM
%token T_MARCADOR
%token T_BIBLIOGRAPHY
%token T_BIBLIOGRAPHY_END
%token T_MAKETITLE
%token T_TITLE
%token T_CITE
%token T_DOCUMENT_END
%token T_DOCUMENT

%type <str> stmt text_bf_stmt text_it_stmt expression_stmt math_mode_stmt title_stmt make_title_stmt document_stmt stmt_list

%start start_stmt

%error-verbose
 
%%

//string antiga: STRING ([a-z]|[A-Z])([a-zA-Z0-9])*

//comeca a maquina de estados
start_stmt:	document_stmt
	|		title_stmt document_stmt
;

//inicia o documento
document_stmt:	T_DOCUMENT stmt_list T_DOCUMENT_END	{printf("encontrei um document_stmt\n");}
;

stmt_list: 	stmt_list stmt
	 |	stmt {	} 
;

//aqui eh onde coloca todos os tipos de stmts diferentes
stmt:
		//escrever html de texto em negrito.
			text_bf_stmt		{printf("Texto em negrito: %s\n",$1);}
		//escrever html de texto em italico.
		|	text_it_stmt 		{printf("%s\n",$1);}
		|	graphics_stmt		{printf("encontrei graphics_stmt\n");}
		|	make_title_stmt		{printf("%s\n",$1);}
		|	cite_stmt		{printf("encontrei cite_stmt\n");}	
		|	math_mode_stmt	{printf("%s\n",$1);}
		//escrever html de texto.
		|	T_STRING		{
			//$$ = concat(2,$$,$1);
			printf("%s ",$1);
		}
;

//aqui ja eh um fork do stmt
text_bf_stmt:
		T_TEXTBF '{' expression_stmt '}'{
			$$ = $3;
			//printf("encontrei o T_TEXTBF\n");
		}
;

text_it_stmt:
		T_TEXTIT '{' expression_stmt '}'{
			$$ = concat(2,"texto em italico: ",$3);
			//printf("encontrei o T_TEXTIT\n");
		}
;

title_stmt:
		T_TITLE '{' expression_stmt '}'{
			//$$ = $3;
			int title_size = 0;
			title_size = strlen($3);
			
			//Copia titulo para variavel global
			//printf("titulo: %s\n", $3);
			title = (char *) malloc (title_size+1);
			memcpy(title,$3,title_size);
			title[title_size] = '\0';
			//printf("titulo copiado: %s\n", title);
		}
;

make_title_stmt:
		T_MAKETITLE{
			//printf("title: %s\n", title);
			$$ = title;
		}
;

cite_stmt:
		T_CITE '{' expression_stmt '}'{
			printf("encontrei cite, adicionar numero de referencia que se encontra no thebibliography\n");
		}
;

math_mode_stmt:
		'$' expression_stmt '$' {
			$$ = concat(2,"math_mode: ",$2);
		}

//itemize_stmt:
//		T_ITEMIZE  item_st_list T_ITEMIZE_END {
//		printf("itemize_stmt\n");
//	}
//;

//item_st_list: item_st
//	| item_st item_st_list
//;

//item_st: T_ITEM item_st_mark expression_stmt
//	| T_ITEM item_st_mark expression_stmt item_st_list
//;
		
//item_st_mark: 
//		T_MARCADOR {
//		printf("encontrei marcador\n");
//	}
//;
	
expression_stmt : T_STRING		{$$ = $1;}
      | expression_stmt T_STRING	{$$ = concat(3,$1," ",$2);}
;

graphics_stmt:
	T_GRAPHICS '{' expression_stmt '}' {
		printf("Imagem aqui\n");
	}
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


