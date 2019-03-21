unit class Undo::Frontend::Actions;
use fatal;
use Undo::Frontend::AST;

method TOP($/) {
  make Program.new(decl => $<decl>>>.made); 
}

method decl:sym<fn> ($/) { make $<fn-decl>.made; }

method fn-decl($/) {
  make Fn.new(
    name => $<id>.made,
    parameter => $<parameters>.made,
    body => $<block>.made,
  );
}

method parameters($/) {
  make $<id>.map(-> $id { Parameter.new(name => $id.made) });
}

method decl:sym<var> ($/) { make $<var-decl>.made; }

method var-decl($/) {
  make $/<id>>>.map({ Decl::Variable.new(id => $_) });
}

method block($/) { make $<lines>.made; }

method lines($/) {
  make Block_.new(body => $<line>>>.made);
}

method line($/) {
  make ($<stmt> // $<outer-expr>).made;
}

method id($/) {
  # TODO manage qualified names
  make Name::Unqualified.new(:name($/.Str));
}

method outer-expr ($/) {
  # !!!!
  # TODO
  # !!!!
  # manage infixes

# DISCARD THE REST CURRENTLY
  make $<inner-expr>[0].made;
  #make $<inner-expr>>>.made;
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
  make Expression::Call.new(
    fn => $<id>.made,
    argument => $<exprlist>.made
  )
}

method exprlist($/) {
  make [$<outer-expr>>>.made];
}

method literal:sym<num>($/) {
  make Literal::Num.new(value => $/.Int);
}

method literal:sym<str>($/) {
  make Literal::String(value => $/.Str);
}
