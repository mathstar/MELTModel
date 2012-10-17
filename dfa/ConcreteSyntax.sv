grammar dfa ;

synthesized attribute ast_Root :: Root ;
synthesized attribute ast_States :: States ;
synthesized attribute ast_State :: State ;
synthesized attribute ast_Alphabet :: Alphabet ;
synthesized attribute ast_Symbol :: Symbol ;
synthesized attribute ast_Initial :: Initial ;
synthesized attribute ast_Accepting :: Accepting ;

nonterminal Root_c with pp, ast_Root ;
concrete production root_c
r::Root_c ::= 'states' '{' s::States_c '}' ';' 'alphabet' '{' a::Alphabet_c '}' ';'
              'initial' '{' st::Initial_c '}' ';' 'accepting' '{' ac::Accepting_c '}' ';'
{
  r.pp = "states {" ++ s.pp ++ "};\nalphabet {" ++ a.pp ++ "};\ninitial {" ++ st.pp ++
         "};\naccepting {" ++ ac.pp ++ "};" ;
  r.ast_Root = root(s.ast_States, a.ast_Alphabet, st.ast_Initial, ac.ast_Accepting);
}

nonterminal States_c with pp, ast_States ;
concrete production consStates_c
ss::States_c ::= rest::States_c ',' s::State_c
{
  ss.pp = rest.pp ++ ", " ++ s.pp ;
  ss.ast_States = consStates(rest.ast_States, s.ast_State) ;
}

concrete production singleStates_c
ss::States_c ::= s::State_c
{
  ss.pp = s.pp ;
  ss.ast_States = singleStates(s.ast_State) ;
}

nonterminal State_c with pp, ast_State ;
concrete production state_c
s::State_c ::= n::Name
{
  s.pp = n.lexeme ;
  s.ast_State = state(n);
}

nonterminal Alphabet_c with pp, ast_Alphabet ;
concrete production consAlphabet_c
al::Alphabet_c ::= rest::Alphabet_c ',' s::Symbol_c
{
  al.pp = rest.pp ++ ", " ++ s.pp ;
  al.ast_Alphabet = consAlphabet(rest.ast_Alphabet, s.ast_Symbol) ;
}

concrete production singleAlphabet_c
al::Alphabet_c ::= s::Symbol_c
{
  al.pp = s.pp ;
  al.ast_Alphabet = singleAlphabet(s.ast_Symbol) ;
}

nonterminal Symbol_c with pp, ast_Symbol ;
concrete production symbol_c
s::Symbol_c ::= n::Name
{
  s.pp = n.lexeme ;
  s.ast_Symbol = symbol(n) ;
}

nonterminal Initial_c with pp, ast_Initial ;
concrete production initial_c
i::Initial_c ::= s::State_c
{
  i.pp = s.pp ;
  i.ast_Initial = initial(s.ast_State) ;
}

nonterminal Accepting_c with pp, ast_Accepting ;
concrete production accepting_c
a::Accepting_c ::= ss::States_c
{
  a.pp = ss.pp ;
  a.ast_Accepting = accepting(ss.ast_States) ;
}




