#use ADT "Literal = String Str | I", "AST = ";

# the literals!
class Literal {
  submethod BUILD { ... }
};

class Literal::Num {
  has Int $.value;
};

class Literal::String {
  has Str $.value;
};

# TODO will have to be looked up in some kind of "Scope"?
# should it really be Str? or is another wrapper needed?
class Literal::Variable {
  has Str $.name;
}

# expressions
class Expression {
  submethod BUILD { ... }
};

class Expression::Call {
  has Function $.fn;
  has Block $.block;
}

class Expression::Conditional {
  has Expression $.condition; # TODO use something else?
  has Block $.block;
}

class Expression::Loop {
  has Expression $.condition;
  has Expression:_ $.termination;
  has Block $.block;
}

# and now..
class Block {
  class Expression @.line;
}

class Function {
  has Block $.block;
}
