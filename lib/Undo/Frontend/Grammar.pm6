unit grammar Undo::Frontend::Grammar;

# note: empty quotes ('') are used to apply the <.ws> token
#       inside of `rule`s

# TODO unicode
my %unicode =
  '×' => '*',
  '≤' => '<=',
  '≥' => '>=',
  '≠' => '!=',
  ;

# This is interpolated using `||`, so longer first.
my @infix-operators = «++ <= >= == != + - * / < >»;

token TOP { <lines> }

rule import-path {
  <id> + %% '.'
  :temp @*IMPORT-PATH;
  { @*IMPORT-PATH.append: $<id>>>.made>>.name; }
  [ '(' ~ ')' ['' $<elements>=<.import-element>] + %% ',' '' ]?
  [ '{' ~ '}' <import-path> + %% ',' '' ]?
}

rule import-element {
  <id> ''
  [ '(' ~ ')' ['' $<constructors>=<.id>] + %% ',' '' ]?
}

rule import-decl {
  [:my @*IMPORT-PATH;
    <import-path>
  ] + %% ','
}

rule var-decl {
  <id> + %% ','
}

rule fn-decl {
  <id>
  [ '(' ~ ')' <parameters> ]?
  <block>
}

# TODO parse structs/struct-likes?
rule enum-variant {
  <id> ''
  [ '(' ~ ')'
    [ '' $<param>=<.id> ] * %% ','
  ]?
}

rule enum-decl {
  <id>
  <.ws>
  '{' ~ '}'
  <enum-variant> + %% ','
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
  | 'import': <import-decl>
  | 'enum': <enum-decl>
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

rule outer-expr { ['' <call-expr> '']+ % <infix> }

regex call-expr {
  <inner-expr>
  [ '(' <exprlist> ')' ]*
}

proto regex inner-expr { * }
rule inner-expr:if {
  'if' <cond=.outer-expr> <then=.block>
  [ 'else' <else=.block> ]?
}
# TODO have "loop" do what "for" *and* "while"
#      do in other languages
rule  inner-expr:loop {
  'loop' <cond=.outer-expr> <body=.block>
}

rule match-subject {
  <id>
  $<fields>=[
    '(' ~ ')'
    ['' <match-subject> ''] * %% ',' ''
  ]?
}

rule match-branch {
  <match-subject>
  '=>'
  <block>
}
rule inner-expr:match {
  'match' <topic=.outer-expr>
  '{' ~ '}' [ ['' <match-branch> ''] + %% ',' '' ]
}

token inner-expr:id { <id> }
token inner-expr:literal { <literal> }
token inner-expr:parens {
  '(' ~ ')' <outer-expr>
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
