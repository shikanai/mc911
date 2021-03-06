
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     T_STRING = 258,
     T_TEXTBF = 259,
     T_TEXTIT = 260,
     WHITESPACE = 261,
     T_ITEMIZE = 262,
     T_ITEMIZE_END = 263,
     T_GRAPHICS = 264,
     T_ITEM = 265,
     T_MARCADOR = 266,
     T_BIBLIOGRAPHY = 267,
     T_BIBLIOGRAPHY_END = 268,
     T_MAKETITLE = 269,
     T_TITLE = 270,
     T_CITE = 271,
     T_DOCUMENT_END = 272,
     T_DOCUMENT = 273,
     T_OMEGA = 274,
     T_BIBITEM = 275,
     T_ENTER = 276
   };
#endif
/* Tokens.  */
#define T_STRING 258
#define T_TEXTBF 259
#define T_TEXTIT 260
#define WHITESPACE 261
#define T_ITEMIZE 262
#define T_ITEMIZE_END 263
#define T_GRAPHICS 264
#define T_ITEM 265
#define T_MARCADOR 266
#define T_BIBLIOGRAPHY 267
#define T_BIBLIOGRAPHY_END 268
#define T_MAKETITLE 269
#define T_TITLE 270
#define T_CITE 271
#define T_DOCUMENT_END 272
#define T_DOCUMENT 273
#define T_OMEGA 274
#define T_BIBITEM 275
#define T_ENTER 276




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 14 "parser.y"

	char *str;
	int  *intval;



/* Line 1676 of yacc.c  */
#line 101 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


