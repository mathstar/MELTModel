grammar dfa ; 

parser parse :: Root_c
{
  dfa; 
}

function main 
IOVal<Integer> ::= largs::[String] ioin::IO
{
  local attribute args :: String;
  args = head( largs ) ;
  --args = implode(" ", largs);

  local attribute inString :: String ;
  inString = implode( " ", tail(largs) );

  production attribute text :: IOVal<String>;
  text = readFile(args, ioin);

  local attribute result :: ParseResult<Root_c>;
  result = parse(text.iovalue, args);

  local attribute r_cst :: Root_c ;
  r_cst = result.parseTree ;

  local attribute r_ast :: Root ;
  r_ast = r_cst.ast_Root ;

  local attribute print_success :: IO;
  print_success = 
    print( "CST pretty print: " ++ r_cst.pp ++
           "\n\n" ++ 
           "AST pretty print: " ++ r_ast.pp ++
           "\n\n" ++
           --"Initial state: " ++ case r_ast.initial of
           --                       nothing() -> "none"
           --                     | just(d) -> d.stateName
           --                     end ++ 
           --"\n\n" ++
           --"Transitions: \n" ++ printTransitions(r_ast.sTransitions) ++
           --"\n\n" ++
           --printStates( r_ast.sStateList ) ++
           --"\n\n" ++
           "Acceptance of " ++ inString ++ ": " ++ case r_ast.initial of
                                                     nothing() -> "ERROR: no (or too many) initial state"
                                                    | just(d) -> if testString(inString, d) then "true" else "false"
                                                   end ++
           "\n\n"
           , ioin );

  local attribute print_failure :: IO;
  print_failure =
    print("Encountered a parse error:\n" ++ result.parseErrors ++ "\n", ioin);

  return ioval(if result.parseSuccess then print_success else print_failure,
               0);
}

function testString
Boolean ::= s::String initial::Decorated State
{
  local attribute sl::[String] ;
  sl = explode("", s) ;
  return testStringHelper(sl, initial) ;
}

function testStringHelper
Boolean ::= sl::[String] state::Decorated State
{
  return if null(sl)
          then state.accepting
          else case transitionLookup( head(sl), state.stateTransitions ) of
                  nothing() -> false -- no transition exists (invalid for DFA)
                | just(t) -> testStringHelper( tail(sl), t )
               end ;
}

function transitionLookup
Maybe<Decorated State> ::= char::String list::[ Pair<String  Decorated State> ]
{
  return if null(list)
          then nothing()
          else if head(list).fst == char
                then just( head(list).snd )
                else transitionLookup( char, tail(list) ) ;
}

-- test function
function printTransitions
String ::= list :: [ Pair<String  Pair<Decorated State  Decorated State> > ]
{
  return if null(list)
          then ""
          else head(list).fst ++ ", " ++ head(list).snd.fst.stateName ++ ", "
                ++ head(list).snd.snd.stateName ++ "\n"
                ++ printTransitions( tail(list) ) ;
}

-- test function
function printStates
String ::= list::[Decorated State]
{
  return if null(list)
          then ""
          else head(list).stateName ++ ": \n  " 
               ++ printStateTransitions( head(list).stateTransitions ) 
               ++ "\n"
               ++ printStates( tail(list) ) ;
}

-- test function
function printStateTransitions
String ::= list::[ Pair<String  Decorated State> ]
{
  return if null(list)
          then ""
          else head(list).fst ++ " -> " ++ head(list).snd.stateName ++ ", "
               ++ printStateTransitions(tail(list)) ;
}



