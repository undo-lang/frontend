unit module Undo::AST;

# the literals!
class Literal {
  submethod BUILD { ... }
}

class Literal::Num {
  has Int $.value;
}

class Literal::String {
  has Str $.value;
}

# TODO will have to be looked up in some kind of "Scope"?
# should it really be Str? or is another wrapper needed?
class Literal::Variable {
  has Str $.name;
}

# expressions
class Expression {
  submethod BUILD { ... }
};

# TODO: seems like there's a rakudo bug that prevents me from calling this "Block"... dunno which name I'm gonna use instead
class Block_ {
  has Expression @.line;
}

class Function {
  has Block_ $.block;
}

class Expression::Call {
  has Callable $.fn; # TODO `fn` should have its own type, or should just be an ID?
  has Expression @.arguments;
}

class Expression::Conditional {
  has Expression $.condition; # TODO use something else?
  has Block_ $.block;
}

class Expression::Loop {
  has Expression $.condition;
  has Expression:_ $.termination; # (optional)
  has Block_ $.block;
}
