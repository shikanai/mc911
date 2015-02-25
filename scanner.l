%{
#include "parser.h"
%}

USEPACKAGE \\usepackage(\[[a-zA-Z0-9]*\])?(\{[a-zA-Z0-9]*\})
DOCUMENT_CLASS \\documentclass(\[.*\])?(\{.*\})
AUTHOR \\author(\{.*\})

STRING [a-z][a-z0-9_]*
WHITESPACE [ \r\t]+
ANY_CHAR .

%option case-insensitive

%%

{WHITESPACE} /* ignore */ ;
{USEPACKAGE} /* ignore */ ;
{DOCUMENT_CLASS} /* ignore */ ;
{AUTHOR} /* ignore */ ;

"SELECT" 	{return T_SELECT;}
"FROM" 		{return T_FROM; }
"CREATE"	{return T_CREATE;}
"TABLE"		{return T_TABLE;}
"INSERT"	{return T_INSERT;}
"INTO"		{return T_INTO;}
"VALUES"	{return T_VALUES;}
"("		{return '(';}
")"		{return ')';} 
"," 		{return ',';}
";"		{return ';';}


{STRING} {	
	yylval.str = (char *) strdup(yytext);
	return T_STRING;
}

{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}


