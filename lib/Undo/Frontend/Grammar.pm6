unit grammar Undo::Frontend::Grammar;

# note: empty quotes ('') are used to apply the <.ws> token
#       inside of `rule`s

my @infix-operators = <++ + - *>;

token TOP { <lines> }

#proto token decl { * }
#token decl:sym<import> { <import> }
#token decl:sym<fn> { <fn-decl> }
#token decl:sym<var> { <var-decl> }

rule var-decl {
  <id> + %% ','
}

rule fn-decl {
  <id>
  [ '(' ~ ')' <parameters> ]?
  <block>
}

token parameters {
  # TODO default values
  <id>* %% [<.ws> ',' <.ws>]
}

token block {
  <.ws> '{' <lines> '}' <.ws>
}

token lines {
  <line> * %% ";"
}
rule line {
  :ratchet
  '' [
  | 'fn': <fn-decl>
  | 'var': <var-decl>
  | <outer-expr>
  ]? ''
}

token id {
  <[a..z A..Z]>
  <[a..z A..Z 0..9 -]>*
}

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
token literal:sym<str> { <string> }
# -- Section from JSON::Tiny
token string {
    (:ignoremark '"') ~ \" [ <str> | \\ <str=.str_escape> ]*
}

token str {
    <-["\\\t\x[0A]]>+
}

token str_escape {
    <["\\/bfnrt]> | 'u' <utf16_codepoint>+ % '\u'
}

token utf16_codepoint {
    <.xdigit>**4
}
# -- END Section from JSON::Tiny
#token literal:sym<seq> { '[' <exprlist> ']' }
