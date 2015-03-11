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
%token T_OMEGA
%token T_BIBITEM
%token T_ENTER

%type <str> stmt text_bf_stmt text_it_stmt expression_stmt math_mode_stmt title_stmt make_title_stmt document_stmt stmt_list
%type <str> bibliography_stmt bibitem_stmt T_ENTER //enter_stmt_valid

%start start_stmt

%error-verbose
 
%%

//comeca a maquina de estados
start_stmt:	document_stmt
	| 		enter_stmt document_stmt
	| 		document_stmt enter_stmt
	| 		enter_stmt document_stmt enter_stmt
	|		title_stmt document_stmt
	|		enter_stmt title_stmt document_stmt
	|		title_stmt enter_stmt document_stmt
	|		title_stmt document_stmt enter_stmt
	|		enter_stmt title_stmt enter_stmt document_stmt
	|		enter_stmt title_stmt document_stmt enter_stmt
	|		title_stmt enter_stmt document_stmt enter_stmt
	|		enter_stmt title_stmt enter_stmt document_stmt enter_stmt
;

//ignore enter antes do document statement
enter_stmt:	enter_stmt T_ENTER
		|	T_ENTER
;

//enter_stmt_valid: enter_stmt_valid T_ENTER {$$ = concat(2,$1,$2);}
//		| 	T_ENTER	{$$ = $1;}
//;		
		
//inicia o documento
document_stmt:	T_DOCUMENT stmt_list T_DOCUMENT_END	{
		printf("encontrei um document_stmt\n");
		//fclose(fp);
	}
;

stmt_list: 	stmt_list stmt
	 |	stmt
;

//aqui eh onde coloca todos os tipos de stmts diferentes
stmt:
		//escrever html de texto em negrito.
			text_bf_stmt		{
				printf("Texto em negrito: %s\n",$1);
				FILE *fp = fopen("projeto1.html","a");
				fprintf(fp,"<b>%s</b>",$1);
				fclose(fp);
			}
		//escrever html de texto em italico.
		|	text_it_stmt 		{
				printf("%s\n",$1);
				FILE *fp = fopen("projeto1.html","a");
				fprintf(fp,"<i>%s</i>",$1);
				fclose(fp);
			}
		|	graphics_stmt		{
				printf("encontrei graphics_stmt\n");
				
			}
		|	make_title_stmt		{
				printf("%s\n",$1);
				FILE *fp = fopen("projeto1.html","a");
				fprintf(fp,"<h1>%s</h1>",$1);
				fclose(fp);
			}
		|	cite_stmt		{
				printf("encontrei cite_stmt\n");
			
			}	
		|	math_mode_stmt	{
				printf("%s\n",$1);
				FILE *fp = fopen("projeto1.html","a");
				fprintf(fp,"%s",$1);
				fclose(fp);
			}
		//escrever html de texto.
		| 	itemize_stmt 	{
				printf("itemize\n");
			
			}
		|	T_STRING		{
			//$$ = concat(2,$$,$1);
				printf("%s ",$1);
				FILE *fp = fopen("projeto1.html","a");
				fprintf(fp,"%s ",$1);
				fclose(fp);
			}
		|	T_BIBLIOGRAPHY T_ENTER bibliography_stmt T_BIBLIOGRAPHY_END	{
				printf("bibliography stmt:\n %s\n", $3);
				FILE *fp = fopen("projeto1.html","a");
				fprintf(fp,"%s",$3);
				fclose(fp);
			}
		|	T_ENTER {
				FILE *fp = fopen("projeto1.html","a");
				fwrite("<br>",4,1,fp);
				fclose(fp);
			}
;

//aqui ja eh um fork do stmt
text_bf_stmt:
		T_TEXTBF '{' expression_stmt '}'{
			$$ = concat(1,$3);
			//printf("encontrei o T_TEXTBF\n");
		}
;

text_it_stmt:
		T_TEXTIT '{' expression_stmt '}'{
			$$ = concat(1,$3);
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
		| '$' T_OMEGA '(' expression_stmt ')' '$'{printf("math mode omega\n");
		}
;

itemize_stmt:
		T_ITEMIZE T_ENTER item_st_list T_ITEMIZE_END T_ENTER{
		printf("itemize_stmt\n");
	}
;

item_st_list: item_st
	| item_st_list item_st 
;

item_st: T_ITEM item_st_mark expression_stmt T_ENTER tst_stmt {printf("Item\n");}
	| T_ITEM item_st_mark expression_stmt T_ENTER
;
		
tst_stmt:
	itemize_stmt
;
		
item_st_mark: 
		T_MARCADOR {
		printf("encontrei marcador\n");
	}
	| /* Vazio */
;
	
expression_stmt : T_STRING		{$$ = $1;}
      | expression_stmt T_STRING	{$$ = concat(3,$1," ",$2);}
	  | expression_stmt T_ENTER	{$$ = concat(2,$1,"<br>");}
;

graphics_stmt:
	T_GRAPHICS '{' expression_stmt '}' {
		printf("Imagem aqui\n");
	}
;

bibliography_stmt: bibitem_stmt
	//| bibliography_stmt bibitem_stmt { 
	//	$$ = concat(2, $1, $2);
	//}
	| bibliography_stmt bibitem_stmt { 
		$$ = concat(2, $1, $2);
	}
	//|	enter_stmt_valid bibliography_stmt enter_stmt_valid bibitem_stmt { 
	//	$$ = concat(4, $1, $2, $3, $4);
	//}
	//|	
;
	
bibitem_stmt:
	T_BIBITEM '{' expression_stmt '}' expression_stmt {
		printf("\nachei um tbibitem:\n %s\n",$5);
		$$ = concat(4,"bibitem: ", $3, " ", $5);
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


