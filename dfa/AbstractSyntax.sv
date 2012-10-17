grammar dfa ;

synthesized attribute pp :: String ;

nonterminal Root with pp ;

abstract production root
r::Root ::= s::States a::Alphabet st::Initial ac::Accepting --t::Transitions
{
  r.pp = "states {" ++ s.pp ++ "};\n" ++
         "alphabet {" ++ a.pp ++ "};\n" ++ 
         "initial {" ++ st.pp ++ "};\n" ++
         "accepting {" ++ ac.pp ++ "};" ;
         -- ++ t.pp ;
}

nonterminal States with pp ;

abstract production consStates
ss::States ::= rest::States s::State
{
  ss.pp = rest.pp ++ ", " ++ s.pp ;
}

abstract production singleStates
ss::States ::= s::State
{
  ss.pp = s.pp ;
}

nonterminal State with pp ;

abstract production state
s::State ::= n::Name
{
  s.pp = n.lexeme ;
}

nonterminal Alphabet with pp ;

abstract production consAlphabet
al::Alphabet ::= rest::Alphabet s::Symbol
{
  al.pp = rest.pp ++ ", " ++ s.pp ;
}

abstract production singleAlphabet
al::Alphabet ::= s::Symbol
{
  al.pp = s.pp ;
}

nonterminal Symbol with pp ;

abstract production symbol
s::Symbol ::= n::Name
{
  s.pp = n.lexeme ;
}

nonterminal Initial with pp ;

abstract production initial
i::Initial ::= s::State
{
  i.pp = s.pp ;
}

nonterminal Accepting with pp ;

abstract production accepting
a::Accepting ::= ss::States
{
  a.pp = ss.pp ;
}



