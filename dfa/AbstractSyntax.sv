grammar dfa ;


synthesized attribute pp :: String ;

synthesized attribute initial :: Maybe<Decorated State> ;
synthesized attribute accepting :: Boolean ;
synthesized attribute stateName :: String ;
synthesized attribute stateTransitions :: [ Pair<String  Decorated State> ] ;

synthesized attribute sStateList :: [ Decorated State ] ;
inherited attribute iStateList :: [ Decorated State ] ;
synthesized attribute sTransitions :: [ Pair<String  Pair<Decorated State  Decorated State> > ] ;
inherited attribute iTransitions :: [ Pair<String  Pair<Decorated State Decorated State> > ] ;

function lookup
Maybe<Decorated State> ::= name::String list::[ Decorated State ]
{
  return if null(list)
          then nothing()
          else if name == (head(list)).stateName
                then just(head(list))
                else lookup (name, tail(list));
}

function myTransitions
[ Pair<String  Decorated State> ] ::= name::String list::[ Pair<String  Pair<Decorated State  Decorated State> > ]
{
  return if null(list)
          then []
          else if head(list).snd.fst.stateName == name
                then [ pair( head(list).fst, head(list).snd.snd ) ]
                      ++ myTransitions( name, tail(list) )
                else myTransitions( name, tail(list) ) ;
}

nonterminal Root with pp, initial, sStateList, sTransitions ;

abstract production root
r::Root ::= s::States t::Transitions
{
  r.pp = s.pp ++ t.pp ;
  r.initial = s.initial ;
  r.sStateList = s.sStateList ;
  r.sTransitions = t.sTransitions ;
  s.iTransitions = r.sTransitions ;
  t.iStateList = r.sStateList ;
}

nonterminal States with pp, initial, sStateList, iTransitions ;

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
  ss.sStateList = s.sStateList ++ rest.sStateList ;
  s.iTransitions = ss.iTransitions ;
  rest.iTransitions = ss.iTransitions ;
}

abstract production nilStates
ss::States ::=
{
  ss.pp = "" ;
  ss.initial = nothing() ;
  ss.sStateList = [] ;
}

nonterminal State with pp, initial, accepting, stateName, sStateList, iTransitions, stateTransitions ;

abstract production regularState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ";" ;
  s.initial = nothing() ;
  s.accepting = false ;
  s.stateName = n.lexeme ;
  s.sStateList = [ s ] ;
  s.stateTransitions = myTransitions( n.lexeme, s.iTransitions ) ;
}

abstract production initState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", initial;" ;
  s.initial = just(s) ;
  s.accepting = false ;
  s.stateName = n.lexeme ;
  s.sStateList = [ s ] ;
  s.stateTransitions = myTransitions( n.lexeme, s.iTransitions ) ;
}

abstract production acceptingState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", accepting;" ;
  s.initial = nothing() ;
  s.accepting = true ;
  s.stateName = n.lexeme ;
  s.sStateList = [ s ] ;
  s.stateTransitions = myTransitions( n.lexeme, s.iTransitions ) ;
}

abstract production initAcceptingState
s::State ::= n::Name
{
  s.pp = "state " ++ n.lexeme ++ ", initial, accepting;" ;
  s.initial = just(s) ;
  s.accepting = true ;
  s.stateName = n.lexeme ;
  s.sStateList = [ s ] ;
  s.stateTransitions = myTransitions( n.lexeme, s.iTransitions ) ;
}

nonterminal Transitions with pp, iStateList, sTransitions ;

abstract production consTransitions
tt::Transitions ::= t::Transition rest::Transitions
{
  tt.pp = t.pp ++ "\n" ++  rest.pp ;
  tt.sTransitions = t.sTransitions ++ rest.sTransitions ;
  t.iStateList = tt.iStateList ;
  rest.iStateList = tt.iStateList ;
}

abstract production nilTransitions
tt::Transitions ::=
{
  tt.pp = "" ;
  tt.sTransitions = [] ;
}

nonterminal Transition with pp, iStateList, sTransitions ;

abstract production transition
t::Transition ::= src::Name dest::Name symbol::Name
{
  t.pp = "transition " ++ src.lexeme ++ " -> " ++ dest.lexeme ++ " with " ++ symbol.lexeme ++ " ;";
  t.sTransitions = case lookup(src.lexeme, t.iStateList) of
                     nothing() -> [] --TODO: invalid state name error
                   | just(s) -> case lookup(dest.lexeme, t.iStateList) of
                                  nothing() -> [] --TODO: invalid state name error
                                | just(d) -> [ pair(symbol.lexeme, pair(s,d)) ]
                                end
                   end ;
}

