grammar dfa ;

synthesized attribute pp :: String ;

nonterminal Root with pp ;

abstract production root
r::Root ::= s::States -- a::Alphabet st::Initial ac::Accepting t::Transitions
{
  r.pp = "states {" ++ s.pp ++ "};" ; --++ a.pp ++ st.pp ++ ac.pp ++ t.pp ;
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
