grammar dfa ;

synthesized attribute pp :: String ;

nonterminal Root with pp ;

abstract production root
r::Root ::= s::States --t::Transitions
{
  r.pp = s.pp ;
         -- ++ t.pp ;
}

nonterminal States with pp ;

abstract production consStates
ss::States ::= s::State rest::States
{
  ss.pp = s.pp ++ "\n" ++  rest.pp ;
}

abstract production nilStates
ss::States ::=
{
  ss.pp = "" ;
}

nonterminal State with pp ;

abstract production regularState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ";" ;
}

abstract production initState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", initial;" ;
}

abstract production acceptingState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", accepting;" ;
}

abstract production initAcceptingState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", initial, accepting;" ;
}

nonterminal Transitions with pp ;

abstract production consTransitions
tt::Transitions ::= t::Transition rest::Transitions
{
  tt.pp = t.pp ++ "\n" ++  rest.pp ;
}

abstract production nilTransitions
tt::Transitions ::=
{
  tt.pp = "" ;
}

nonterminal Transition with pp ;

abstract production transition
t::Transition ::= src::Name dest::Name symbol::Name
{
  t.pp = "transition " ++ src.pp ++ " -> " ++ dest.pp ++ " with " ++ symbol.pp ++ " ;\n";
}

