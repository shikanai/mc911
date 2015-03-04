%{
#include "parser.h"
%}

USEPACKAGE \\usepackage(\[[a-zA-Z0-9]*\])?(\{[a-zA-Z0-9]*\})
DOCUMENT_CLASS \\documentclass(\[.*\])?(\{.*\})
AUTHOR \\author(\{.*\})

STRING ([a-z]|[A-Z])([a-zA-Z0-9])*
WHITESPACE [ \r\t]+
MARCADOR (\[([0-9a-zA-Z.()\-]*)\])
ANY_CHAR .

%option case-insensitive

%%

{WHITESPACE} /* ignore */ ;
{USEPACKAGE} /* ignore */ ;
{DOCUMENT_CLASS} /* ignore */ ;
{AUTHOR} /* ignore */ ;

"\\textbf"	{return T_TEXTBF;}
"\\textit"	{return T_TEXTIT;}
"\\begin{thebibliography}"	{return T_BIBLIOGRAPHY;}
"\\end{thebibliography}"	{return T_BIBLIOGRAPHY_END;}
"\\begin{itemize}"	{return T_ITEMIZE;}
"\\end{itemize}"	{return T_ITEMIZE_END;}
"\\includegraphics"	{return T_GRAPHICS;}
"\\item"			{return T_ITEM;}
"{"		{return '{';}
"}"		{return '}';}
"("		{return '(';}
")"		{return ')';} 
","		{return ',';}
";"		{return ';';}

{MARCADOR} {
	return T_MARCADOR;
}

{STRING} {	
	yylval.str = (char *) strdup(yytext);
	return T_STRING;
}

{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}


