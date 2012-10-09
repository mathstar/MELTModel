grammar kix ;

{- The abstract syntax is defined here.  Defining abstract syntax is
   not required in Silver since attributes can decorate the concrete
   syntax as well.  But in many cases, especially when the concrete
   syntax is complicated by parsing requirements, it is useful to do
   so.  -}

{- The "pretty print" of a tree. Should parse to the "same" tree. -}
synthesized attribute pp :: String;

synthesized attribute errors :: [ String ] ;

inherited attribute env :: [ Pair<String   Decorated Decl> ] ;
synthesized attribute defs :: [ Pair<String    Decorated Decl> ] ;

nonterminal Root with pp, errors;

abstract production root
r::Root ::= s::Stmts
{
  r.pp = s.pp ;
  r.errors = s.errors ;
  s.env = [ ] ;
}

nonterminal Stmts with pp, errors, env ;
abstract production consStmts
ss::Stmts ::= s::Stmt rest::Stmts
{
  ss.pp = s.pp ++ rest.pp ;
  ss.errors = s.errors ++ rest.errors ;
  s.env = ss.env ;
  rest.env = s.defs ++ ss.env ;
}

abstract production nilStmts
ss::Stmts ::= 
{
  ss.pp = "" ;
  ss.errors = [ ] ;
}

nonterminal Stmt with pp, errors, env, defs;

abstract production declStmt
s::Stmt ::= d::Decl
{
  s.pp = d.pp ++ ";" ;
  s.errors = [ ] ; --TODO fix this later
  s.defs = d.defs ;
}

{-
abstract production block
s::Stmt ::= ss::Stmts 
{
}
-}

abstract production assignmentStmt
s::Stmt ::= l::Expr r::Expr
{
  s.pp = l.pp ++ " = " ++ r.pp ++ ";";
  s.errors = l.errors ++ r.errors ;
  s.defs = [ ] ;
  l.env = s.env ;
  r.env = s.env ;
}

abstract production printStmt
s::Stmt ::= e::Expr
{
  s.pp = "print ( " ++ e.pp ++ " ) ;" ;
  s.errors = e.errors ;
  s.defs = [ ] ;
  e.env = s.env ;
}

abstract production ifThenElseStmt
s::Stmt ::= e::Expr th::Stmt el::Stmt
{
  s.pp = "if ( " ++ e.pp ++ " ) " ++ th.pp ++ " else " ++ el.pp ;
  s.errors = e.errors ++ th.errors ++ el.errors ;
  s.defs = [ ] ;
  e.env = s.env ;
  th.env = s.env ;
  el.env = s.env ;
}

nonterminal Decl with pp, defs ;
abstract production decl
d::Decl ::= te::TypeExpr n::VariableName
{
  d.pp = te.pp ++ " " ++ n.lexeme ;
  d.defs = [ pair(n.lexeme, d) ] ;
}

nonterminal TypeExpr with pp;

abstract production intTypeExpr
te::TypeExpr ::= i::Integer_t
{
  te.pp = i.lexeme ;
}

abstract production boolTypeExpr
te::TypeExpr ::= b::Boolean_t
{
  te.pp = b.lexeme ;
}

nonterminal Expr with pp, errors, env;

abstract production varName
e::Expr ::= n::VariableName
{
  e.pp = n.lexeme ;
  e.errors = case lookup (n.lexeme, e.env) of
               nothing() -> [ n.lexeme ++ " is not defined. \n\n" ] 
             | just(d) -> [ ]
             end ;
}

function lookup
Maybe<Decorated Decl> ::= name::String env::[ Pair<String   Decorated Decl>]
{
  return if null(env)
         then nothing() 
         else if name == (head(env)).fst
              then just((head(env)).snd)
              else lookup (name, tail(env)) ;
}

abstract production intLit
e::Expr ::= i::IntegerLiteral
{
  e.pp = i.lexeme ;
  e.errors = [ ] ;
}

abstract production boolLit
e::Expr ::= b::BooleanLiteral
{
  e.pp = b.lexeme ;
  e.errors = [ ] ;
}
