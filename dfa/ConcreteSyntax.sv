grammar dfa ;

synthesized attribute ast_Root :: Root ;
synthesized attribute ast_States :: States ;
synthesized attribute ast_State :: State ;

nonterminal Root_c with pp, ast_Root ;
concrete production root_c
r::Root_c ::= s::States_c
{
  r.pp = s.pp ;
  r.ast_Root = root(s.ast_States);
}

nonterminal States_c with pp, ast_States ;
concrete production consStates_c
ss::States_c ::= s::State_c rest::States_c
{
  ss.pp = s.pp ++ "\n" ++ rest.pp ;
  ss.ast_States = consStates(s.ast_State, rest.ast_States ) ;
}

concrete production nilStates_c
ss::States_c ::=
{
  ss.pp = "" ;
  ss.ast_States = nilStates() ;
}

nonterminal State_c with pp, ast_State ;
concrete production regularState_c
s::State_c ::= 'state' n::Name ';'
{
  s.pp = "state " ++ n.lexeme ++";" ;
  s.ast_State = regularState(n);
}

concrete production initState_c
s::State_c ::= 'state' n::Name ',' 'initial' ';'
{
  s.pp = "state " ++ n.lexeme ++ ", initial;" ;
  s.ast_State = initState(n);
}

concrete production acceptingState_c
s::State_c ::= 'state' n::Name ',' 'accepting' ';'
{
  s.pp = "state " ++ n.lexeme ++ ", accepting;" ;
  s.ast_State = acceptingState(n);
}

concrete production initAcceptingState_c
s::State_c ::= 'state' n::Name ',' 'initial' ',' 'accepting' ';'
{
  s.pp = "state " ++ n.lexeme ++ ", initial, accepting;" ;
  s.ast_State = initAcceptingState(n);
}

concrete production acceptingInitState_c
s::State_c ::= 'state' n::Name ',' 'accepting' ',' 'initial' ';'
{
  s.pp = "state " ++ n.lexeme ++ ", initial, accepting;" ;
  s.ast_State = initAcceptingState(n);
}
