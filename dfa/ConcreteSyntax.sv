grammar dfa ;

synthesized attribute ast_Root :: Root ;
synthesized attribute ast_States :: States ;
synthesized attribute ast_State :: State ;

nonterminal Root_c with pp, ast_Root ;
concrete production root_c
r::Root_c ::= 'states' '{' s::States_c '}' ';'
{
  r.pp = "states {" ++ s.pp ++ "};" ;
  r.ast_Root = root(s.ast_States);
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
