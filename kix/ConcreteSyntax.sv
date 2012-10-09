grammar kix ;

{- This file defines the concrete syntax of "kix".  
   The concrete productions are used to define the
   parser.  They also define an attribute, pp, which unparses the tree
   to generate a string, and attributes, ast_Root and ast_Expr, which
   are used to generate the abstract syntax tree.  -}

nonterminal Root_c with pp, ast_Root;

synthesized attribute ast_Root :: Root;
synthesized attribute ast_Stmts :: Stmts ;
synthesized attribute ast_Stmt :: Stmt ;
synthesized attribute ast_Expr :: Expr ;
synthesized attribute ast_Decl :: Decl ;
synthesized attribute ast_TypeExpr :: TypeExpr ;

concrete production root_c
r::Root_c ::= s::Stmts_c
{
  r.pp = s.pp ;
  r.ast_Root = root(s.ast_Stmts);
}

-- Stmts
nonterminal Stmts_c with pp, ast_Stmts ;

concrete production consStmts_c
ss::Stmts_c ::= s::Stmt_c  rest::Stmts_c
{
  ss.pp = s.pp ++ rest.pp ;
  ss.ast_Stmts = consStmts ( s.ast_Stmt, rest.ast_Stmts ) ;
}

concrete production nilStmts_c
ss::Stmts_c ::= 
{
  ss.pp = "" ;
  ss.ast_Stmts = nilStmts ( );
}

-- Stmt
nonterminal Stmt_c with pp, ast_Stmt ;

concrete production declStmt_c
s::Stmt_c ::= d::Decl_c ';'
{
  s.pp = d.pp ++ ";";
  s.ast_Stmt = declStmt(d.ast_Decl) ;
}


concrete production block_c
s::Stmt_c ::= '{' ss::Stmts_c  '}'
{
  s.pp = " { " ++ ss.pp ++ " } ";
  s.ast_Stmt = block(ss.ast_Stmts) ;
}


concrete production assignmentStmt_c
s::Stmt_c ::= l::Expr_c '=' r::Expr_c ';'
{
  s.pp = l.pp ++ " = " ++ r.pp ;
  s.ast_Stmt = assignmentStmt(l.ast_Expr, r.ast_Expr) ;
}

concrete production printStmt_c
ps::Stmt_c ::= 'print' '(' e::Expr_c ')' ';'
{
  ps.pp = "print ( " ++ e.pp ++ " ) ;" ;
  ps.ast_Stmt = printStmt(e.ast_Expr) ;
}

concrete production ifThenElseStmt_c
s::Stmt_c ::= 'if' '(' e::Expr_c ')' th::Stmt_c 'else' el::Stmt_c
{
  s.pp = "if ( " ++ e.pp ++ " ) " ++ th.pp ++ " else " ++ el.pp;
  s.ast_Stmt = ifThenElseStmt(e.ast_Expr, th.ast_Stmt, el.ast_Stmt) ;
}

-- Decl

nonterminal Decl_c with pp, ast_Decl ;

concrete production decl_c
d::Decl_c ::= te::TypeExpr_c n::VariableName
{
  d.pp = te.pp ++ " " ++ n.lexeme ;
  d.ast_Decl = decl(te.ast_TypeExpr, n) ;
}

-- TypeExpr

nonterminal TypeExpr_c with pp, ast_TypeExpr ;

concrete production intTypeExpr_c
te::TypeExpr_c ::= i::Integer_t
{
  te.pp = i.lexeme ;
  te.ast_TypeExpr = intTypeExpr(i);
}

concrete production boolTypeExpr_c
te::TypeExpr_c ::= b::Boolean_t
{
  te.pp = b.lexeme ;
  te.ast_TypeExpr = boolTypeExpr(b);
}

-- Expr

nonterminal Expr_c with pp, ast_Expr ;

concrete production varName_c
e::Expr_c ::= n::VariableName
{
  e.pp = n.lexeme ;
  e.ast_Expr = varName(n);
}

concrete production intLit_c
e::Expr_c ::= i::IntegerLiteral
{
  e.pp = i.lexeme ;
  e.ast_Expr = intLit(i);
}

concrete production boolLit_c
e::Expr_c ::= b::BooleanLiteral
{
  e.pp = b.lexeme ;
  e.ast_Expr = boolLit(b);
}
