%{
#include "parser.h"
%}

USEPACKAGE \\usepackage(\[[a-zA-Z0-9]*\])?(\{[a-zA-Z0-9]*\})
DOCUMENT_CLASS \\documentclass(\[.*\])?(\{.*\})
AUTHOR \\author(\{.*\})

STRING ([a-zA-Z0-9]|\.|\-|\,|\\$|\:|\/)+([a-zA-Z0-9]|\.|\-|\,|\\$|\:|\/)*
WHITESPACE [ \r\t]+
MARCADOR (\[([0-9a-zA-Z.()\-]*)\])
ENTER \n
ANY_CHAR .

%option case-insensitive

%%

{WHITESPACE} /* ignore */ ;
{USEPACKAGE} /* ignore */ ;
{DOCUMENT_CLASS} /* ignore */ ;
{AUTHOR} /* ignore */ ;
"\\bibitem"			{return T_BIBITEM;}
"\\Omega"			{return T_OMEGA;}
"\\textbf"			{return T_TEXTBF;}
"\\textit"			{return T_TEXTIT;}
"\\begin{thebibliography}"	{return T_BIBLIOGRAPHY;}
"\\end{thebibliography}"	{return T_BIBLIOGRAPHY_END;}
"\\begin{itemize}"		{return T_ITEMIZE;}
"\\end{itemize}"		{return T_ITEMIZE_END;}
"\\begin{document}"		{return T_DOCUMENT;}
"\\end{document}"		{return T_DOCUMENT_END;}
"\\includegraphics"		{return T_GRAPHICS;}
"\\item"			{return T_ITEM;}
"\\maketitle"			{return T_MAKETITLE;}
"\\title"			{return T_TITLE;}
"\\cite"			{return T_CITE;}
"$"		{return '$';}
"{"		{return '{';}
"}"		{return '}';}
"("		{return '(';}
")"		{return ')';} 
";"		{return ';';}

{STRING} {	
	yylval.str = (char *) strdup(yytext);
	return T_STRING;
}

{ENTER} {
	return T_ENTER;
}

{MARCADOR} {
	return T_MARCADOR;
}

{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}


