unit grammar Undo::Frontend::Grammar;

# note: empty quotes ('') are used to apply the <.ws> token
#       inside of `rule`s

my @infix-operators = <+ - *>;

token TOP { <decl> }

proto token decl { * }
#token decl:sym<import> { <import> }
token decl:sym<fn> { <fn-decl> }
token decl:sym<var> { <var-decl> }

rule var-decl {
  'var' <id> + %% ','
}

rule fn-decl {
	'' 'fn' <id>
	[ '(' <parameters> ')' ]
	<block>
}

token parameters {
	# TODO default values
	<id>* %% ','
}

token block {
  <.ws> '{' <lines> '}' <.ws>
}

token lines {
  <line> * %% ";"
}
regex line {
  :ratchet
  <.ws> [ <stmt> | <outer-expr> ]? <.ws>
}

token id { <[a..z A..Z -]> + }

token infix {
  || @infix-operators
}

rule outer-expr { ['' <inner-expr> ''] + % <infix> }


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
token inner-expr:id { <id> }
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
