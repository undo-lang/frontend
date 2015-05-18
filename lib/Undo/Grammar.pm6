grammar Undo::Grammar;

token id { <[a..z A..Z -]> + }

token TOP { <lines> }
token block { '{' ~ '}' <lines> }

token lines { "\n"* <line> * %% "\n" "\n"* }
token line { <.ws> [ <expr> || <stmt> ] }

proto token stmt { * }
rule expr:var-decl {
  'var' <id> + %% 
}

proto token expr { * }
token expr:var { <id> }
token expr:call { <call> }
token expr:literal { <literal> }
rule expr:if {
  'if' <expr> <block>
  [ 'else' <else=.block> ]?
}
# TODO have "loop" do what "for" *and* "while"
;#      do in other languages
rule expr:loop { 'loop' <expr> <block> }

token call { <id> '(' <exprlist> ')' }

rule exprlist { <expr> * %% ',' }

# literal stuff
proto token literal { * }
token literal:sym<num> { '-'? <[0..9]> + }
token literal:sym<str> { '"' ~ '"' <[a..z A..Z -]> + }
#token literal:sym<seq> { '[' <exprlist> ']' }
