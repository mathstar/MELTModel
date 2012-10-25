grammar dfa;

ignore terminal WhiteSpace /[\t\n\ ]+/;
ignore terminal LineComment /\/\/.*/;

-- Puncuation
terminal Semicolon ';' ;
terminal Comma ',' ;
terminal Arrow '->' ;

lexer class KEYWORDS ;

-- Keywords
terminal Initial_t 'initial' lexer classes { KEYWORDS } ;
terminal Accepting_t 'accepting' lexer classes { KEYWORDS } ;
terminal State_t 'state' lexer classes { KEYWORDS } ;
terminal Transition_t 'transition' lexer classes { KEYWORDS } ;
terminal With_t 'with' lexer classes { KEYWORDS } ;

-- Name
terminal Name /[a-zA-Z0-9_]*/ submits to { KEYWORDS };
