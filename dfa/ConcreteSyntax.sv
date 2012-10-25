grammar dfa ;

synthesized attribute ast_Root :: Root ;
synthesized attribute ast_States :: States ;
synthesized attribute ast_State :: State ;
synthesized attribute ast_Transitions :: Transitions ;
synthesized attribute ast_Transition :: Transition ;

nonterminal Root_c with pp, ast_Root ;
concrete production root_c
r::Root_c ::= s::States_c t::Transitions_c
{
  r.pp = s.pp ++ t.pp;
  r.ast_Root = root(s.ast_States, t.ast_Transitions);
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

nonterminal Transitions_c with pp, ast_Transitions ;
concrete production consTransitions_c
tt::Transitions_c ::= t::Transition_c rest::Transitions_c
{
  tt.pp = t.pp ++ "\n" ++ rest.pp ;
  tt.ast_Transitions = consTransitions(t.ast_Transition, rest.ast_Transitions ) ;
}

concrete production nilTransitions_c
tt::Transitions_c ::=
{
  tt.pp = "" ;
  tt.ast_Transitions = nilTransitions() ;
}

nonterminal Transition_c with pp, ast_Transition ;
concrete production transition_c
t::Transition_c ::= 'transition' src::Name '->' dest::Name 'with' symbol::Name ';'
{
  t.pp = "transition " ++ src.lexeme ++ " -> " ++ dest.lexeme ++ " with " ++ symbol.lexeme ++ ";" ;
  t.ast_Transition = transition(src,dest,symbol) ;
}
