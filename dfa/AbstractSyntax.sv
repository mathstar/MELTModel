grammar dfa ;

synthesized attribute pp :: String ;

synthesized attribute initial :: Maybe<Decorated State> ;
synthesized attribute accepting :: Boolean ;
synthesized attribute stateName :: String ;

nonterminal Root with pp, initial ;

abstract production root
r::Root ::= s::States t::Transitions
{
  r.pp = s.pp ++ t.pp ;
  r.initial = s.initial ;
}

nonterminal States with pp, initial ;

abstract production consStates
ss::States ::= s::State rest::States
{
  ss.pp = s.pp ++ "\n" ++  rest.pp ;
  ss.initial = case s.initial of
                 nothing() -> case rest.initial of
                                nothing() -> nothing()
                              | just(d) -> just(d)
                              end
               | just(d) -> case rest.initial of
                              nothing() -> just(d)
                            | just(e) -> nothing() --TODO: error goes here
                            end
               end ;
}

abstract production nilStates
ss::States ::=
{
  ss.pp = "" ;
  ss.initial = nothing() ;
}

nonterminal State with pp, initial, accepting, stateName ;

abstract production regularState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ";" ;
  s.initial = nothing() ;
  s.accepting = false ;
  s.stateName = n.lexeme ;
}

abstract production initState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", initial;" ;
  s.initial = just(s) ;
  s.accepting = false ;
  s.stateName = n.lexeme ;
}

abstract production acceptingState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", accepting;" ;
  s.initial = nothing() ;
  s.accepting = true ;
  s.stateName = n.lexeme ;
}

abstract production initAcceptingState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", initial, accepting;" ;
  s.initial = just(s) ;
  s.accepting = true ;
  s.stateName = n.lexeme ;
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
  t.pp = "transition " ++ src.lexeme ++ " -> " ++ dest.lexeme ++ " with " ++ symbol.lexeme ++ " ;";
}

