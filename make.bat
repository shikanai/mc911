flex scanner.l
bison -dy parser.y
gcc lex.yy.c y.tab.c -o program.exe