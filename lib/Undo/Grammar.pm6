grammar Undo::Grammar;

token id { <[a..z A..Z -]> + }

token TOP { <lines> }
token block { '{' ~ '}' <lines> }

token lines { "\n"* <line> * %% "\n" "\n"* }
token line { <.ws> <expr> }

proto token expr { * }
token expr:sym<var> { <id> }
token expr:sym<call> { <call> }
token expr:sym<literal> { <literal> }
rule expr:sym<if> { 'if' <expr> <block> }
rule expr:sym<loop> { 'loop' <expr> <block> }

token call { <id> '(' <exprlist> ')' }

rule exprlist { <expr> * %% ',' }

# literal stuff
proto token literal { * }
token literal:sym<num> { '-'? <[0..9]> + }
token literal:sym<str> { '"' ~ '"' <[a..z A..Z -]> + }
#token literal:sym<seq> { '[' <exprlist> ']' }
