grammar Undo::Grammar;

token id { <[a..z A..Z -]> + }

token TOP { <lines> }
token block { '{' ~ '}' <lines> }

token lines { <line> * %% "\n" }
token line { <expr> }

proto token expr { * }
token expr:sym<call> { <call> }
token expr:sym<literal> { <literal> }
token expr:sym<if> { 'if' <expr> <block> }

token call { <id> '(' <exprlist> ')' }

regex exprlist { <expr> + %% ',' }

# literal stuff
proto token literal { * }
token literal:sym<num> { '-' <[0..9]> + }
