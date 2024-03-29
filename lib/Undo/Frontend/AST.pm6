unit module Undo::Frontend::AST;

class Line {
  #submethod BUILD { ... }
}

# expressions
class Expression is Line {
  #submethod BUILD { ... }
}

class Name is Expression {
  #submethod BUILD { ... }
}

class Name::Qualified is Name {
  has Str @.module;
  has Str $.name;
}

class Name::Unqualified is Name {
  has Str $.name;
}

# the literals!
class Literal is Expression {
  #submethod BUILD { ... }
}

class Literal::Num is Literal {
  has Int $.value;
}

class Literal::String is Literal {
  has Str $.value;
}

#class Literal::Variable {
#  has Name $.name;
#}

# declarations

# TODO: seems like there's a rakudo bug that prevents me from calling this "Block"... dunno which name I'm gonna use instead
class Block_ is export {
  has Line @.body;
}

class Expression::Call is Expression {
  has Expression $.fn;
  has Expression @.argument;
}

class Expression::Conditional is Expression {
  has Expression $.condition; # TODO use something else?
  has Block_ $.then;
  has Block_ $.else;
}

class Expression::Loop is Expression {
  has Expression $.condition;
  has Block_ $.block;
}

class Decl is Line {
  # submethod BUILD { ... }
}

class Decl::Variable is Decl {
  has Name::Unqualified $.name;
}

class Decl::ImportPath {}

class Decl::ImportList is Decl {
  has Decl::ImportPath @.paths;
}

class Decl::ImportPath::Simple is Decl::ImportPath {
  has Str @.path;
}

class Decl::ImportPath::Spread is Decl::ImportPath {
  has Str @.path;
  has Str @.spread;
}

class Parameter_ is export {
  has Str $.name;
}

class Fn is Decl is export {
  has Str $.name;
  has Parameter_ @.parameter;
  has Block_ $.body;
}
