grammar Undo::Grammar;

token id { <[a..z A..Z -]> + }

token TOP { <lines> }
token block { '{' ~ '}' <lines> }

token lines { "\n"* <line> * %% "\n" "\n"* }
token line { <.ws> <expr> }

proto token expr { * }
token expr:sym<id> { <id> }
token expr:sym<call> { <call> }
token expr:sym<literal> { <literal> }
rule expr:sym<if> { 'if' <expr> '{' <lines> '}' }
rule expr:sym<for> { 'for' <expr> '{' <lines> '}' }

token call { <id> '(' <exprlist> ')' }

rule exprlist { <expr> * %% ',' }

# literal stuff
proto token literal { * }
token literal:sym<num> { '-'? <[0..9]> + }
