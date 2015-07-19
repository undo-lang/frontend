unit module Undo::AST;

class Name {
  submethod BUILD { ... }
};

class Name::Qualified is Name {
  has Str @.module-part;
  has Str $.name;
}

class Name::Unqualified is Name {
  has Str $.name;
}

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

class Literal::Variable {
  has Name $.name;
}

# declarations
module Decl { };

class Decl::Variable {
  has Name $.id;
}

# expressions
class Expression {
  submethod BUILD { ... }
};

# TODO: seems like there's a rakudo bug that prevents me from calling this "Block"... dunno which name I'm gonna use instead
class Block_ {
  has Expression @.line;
}

class Expression::Call {
  has Name $.fn; # TODO use some other type here. Where should identifiers be resolved???
  has Expression @.arguments;
}

class Expression::Conditional {
  has Expression $.condition; # TODO use something else?
  has Block_ $.then;
  has Block_ $.else;
}

class Expression::Loop {
  has Expression $.condition;
  has Block_ $.block;
}
