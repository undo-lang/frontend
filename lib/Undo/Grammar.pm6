#use Grammar::Debugger;
unit grammar Undo::Grammar;

# note: empty quotes ('') are used to apply the <.ws> token
#       inside of `rule`s

my @infix-operators = <+ - *>;

token space { \s* }

token ws { [ ' ' | \\t ] * }

token id { <[a..z A..Z -]> + }

token TOP { <lines> }
token block {
  <.space> '{' <lines> '}' <.space>
}

token lines {
  "\n"? <line> * %% "\n"
}
regex line {
  :ratchet
  <.ws> [ <stmt> | <outer-expr> ]? <.ws>
}

proto token stmt { * }
rule stmt:var-decl {
  'var' <id> + %% ','
}

token infix {
  || @infix-operators
}

proto token outer-expr { * } 
rule outer-expr:expr { ['' <inner-expr> ''] + % <infix> }


proto regex inner-expr { * }
rule  inner-expr:if {
  'if' <cond=.outer-expr> <then=.block>
  [ 'else' <else=.block> ]?
}
# TODO have "loop" do what "for" *and* "while"
#      do in other languages
rule  inner-expr:loop {
  'loop' <cond=.outer-expr> <body=.block>
}
token inner-expr:call { <call> }
token inner-expr:var { <id> }
token inner-expr:literal { <literal> }
token inner-expr:parens {
  '(' ~ ')' <outer-expr>
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
