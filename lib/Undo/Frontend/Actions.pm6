use Undo::Frontend::AST;
unit class Undo::Frontend::Actions;

method TOP($/) {
  make $<lines>>>.made;
}

method lines($/) {
  make $<line>>>.made;
}

method line($/) {
  make ($<stmt> // $<outer-expr>).made;
}

method id($/) {
  # TODO manage qualified names
  make Name::Unqualified.new(:name($/.Str));
}

method stmt:var-decl ($/) {
  make $/<id>>>.map: { Decl::Variable.new(:id($_)) };
}

method outer-expr:expr ($/) {
  # !!!!
  # TODO
  # !!!!
  # manage infixes
  # this will be a rather complex piece of code, with operator precedence and all
  # maybe it'll be moved to an external module...
  make $<inner-expr>>>.made;
}

method inner-expr:if ($/) {
  make Expression::Conditional.new(
    :condition($<cond>.made),
    :then($<then>.made),
    :else($<else>.made),
  );
}

method inner-expr:loop ($/) {
  make Expression::Loop.new(
    :condition($<cond>.made),
    :block($<body>.made),
  );
}

# just defer those to their own action methods
method inner-expr:call ($/) {
  make $<call>.made;
}

method inner-expr:id ($/) {
  make $<id>.made;
}

method inner-expr:literal ($/) {
  make $<literal>.made;
}

method inner-expr:parens ($/) {
  make $<outer-expr>.made;
}

# and now, the real implementation

method call($/) {
  make Expression::Call.new()
}

method exprlist($/) {
  make $<outer-expr>>>.made;
}

method literal:sym<num>($/) {
  make $/.Int;
}

method literal:sym<str>($/) {
  make $/.Str;
}
