unit grammar Undo::Grammar;

my @infix-operators = <+ - *>;

token sp { ' '* }

token id { <[a..z A..Z -]> + }

token TOP { <lines> }
rule block {
  <.ws> '{' ~ '}'
  <lines> <.ws>
}

token lines {
  "\n"* <line> * %% "\n"+
}
token line {
  <.sp>
  [ <outer-expr> || <stmt> ] <.sp>
}

proto token stmt { * }
rule stmt:var-decl {
  'var' <id> + %% ','
}

token infix {
  || @infix-operators
}

proto token outer-expr { * } 
token outer-expr:expr { [<.sp> <inner-expr> <.sp>] + % <infix> }


proto regex inner-expr { * }
token inner-expr:call { <call> }
token inner-expr:var { <id> }
token inner-expr:literal { <literal> }
token inner-expr:parens {
  '(' ~ ')' <outer-expr>
}
rule  inner-expr:if {
  'if' <cond=.outer-expr> <then=.block>
  [ 'else' <else=.block> ]?
}
# TODO have "loop" do what "for" *and* "while"
#      do in other languages
rule  inner-expr:loop {
  'loop' <cond=.expr> <body=.block>
}

token call {
  <id>
  '(' <exprlist> ')'
}

token exprlist {
  <outer-expr>* %% ','
}

# literal stuff
proto token literal { * }
token literal:sym<num> {
  '-'? <[0..9]> +
}
token literal:sym<str> {
  '"' ~ '"' <[a..z A..Z -]> +
}
#token literal:sym<seq> { '[' <exprlist> ']' }
