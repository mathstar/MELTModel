grammar dfa;

ignore terminal WhiteSpace /[\t\n\ ]+/;
ignore terminal LineComment /\/\/.*/;

-- Puncuation
terminal LeftCurly '{' ;
terminal RightCurly '}' ;
terminal Semicolon ';' ;
terminal Comma ',' ;
terminal Arrow '->' ;

lexer class KEYWORDS ;

-- Keywords
terminal States_t 'states' lexer classes { KEYWORDS } ;
terminal Alphabet_t 'alphabet' lexer classes { KEYWORDS } ;
terminal Initial_t 'initial' lexer classes { KEYWORDS } ;
terminal Accepting_t 'accepting' lexer classes { KEYWORDS } ;
terminal Transition_t 'transition' lexer classes { KEYWORDS } ;
terminal With_t 'with' lexer classes { KEYWORDS } ;

-- Name
terminal Name /[a-zA-Z0-9_]*/ submits to { KEYWORDS };
