-- need a way to do the for-each loop
-- need a way to mark nodes

function optimizeAssignemnt
id::Expr node::Decorated Expr ::= Expr
{
  return if(variableUsed(id, node))
          then node
          else skip();
}

function variableUsed
id::Expr node::Decorated Expr ::= Boolean
{
  mark(node);
  local attribute result::Boolean;
  result = false;
  for(Node n : node.succ){
    result = result || if( !marked(n) )
                       then if ( "id is in n.uses" )
                            then true
                            else if( "id is in n.def" )
                                 then false
                                 else variableUsed(n)
                       else false;
  }
  return result;
}
