%{
    #include <stdio.h>

    #define belongs(t) fprintf(yyout, "\"%s\" - belongs",t)
    #define other(t) fprintf(yyout, "\"%s\" - does not belong",t)
    #define invalid(t) fprintf(yyout, "\"%s\" - contains invalid characters",t)
%}

%option noyywrap
%option reentrant
%option noinput nounput

er1     (ab)
any     [abc]*
other   [abc]+

%%

^{any}{er1}{any}{er1}{any}$   { belongs(yytext); }
^{other}$           { other(yytext); }
\n                  { ECHO; }
.+                  { invalid(yytext); }

%%

int main(int argc, char *argv[])
{
    /* init the scanner */
    yyscan_t scanner;
    if (yylex_init(&scanner))
    {
        fprintf(stderr, "Fail initing scanner\n");
        return(EXIT_FAILURE);
    }

    /* prepare input stream */
    switch (argc)
    {
        case 1: // read from stdin, the default
        {
            yyset_in(stdin, scanner);
            break;
        }
        case 2: // read from given file
        {
            FILE* fin;
            if ((fin = fopen(argv[1], "r")) == NULL)
            {
                fprintf(stderr, "Fail openning input file \"%s\"\n", argv[1]);
                exit(EXIT_FAILURE);
            }
            yyset_in(fin, scanner);
            break;
        }
        default:
        {
            fprintf(stderr, "Wrong number of arguments\n");
            exit(EXIT_FAILURE);
        }
    }

    /* do scanning */
    while (yylex(scanner) != 0)
    {
    }

    /* clean up and quit */
    yylex_destroy(scanner);
    return 0;
}

