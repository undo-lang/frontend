unit module Undo::Frontend::AST;

# expressions
class Expression {
  #submethod BUILD { ... }
}

class Name is Expression {
  #submethod BUILD { ... }
}

class Name::Qualified is Name {
  has Str @.module-part;
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
  has Expression @.body;
}

class Expression::Call is Expression {
  has Name $.fn; # TODO use some other type here. Where should identifiers be resolved???
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

class Decl {
	# submethod BUILD { ... }
}

class Decl::Variable is Decl {
  has Name::Unqualified $.name;
}

#class Import is Decl {
#}

class Parameter {
	has Name::Unqualified $.name;
}

class Fn is Decl is export {
	has Name::Unqualified $.name;
	has Parameter @.parameter;
	has Block_ $.body;
}

class Program is export {
	has Decl @.decl;
}
