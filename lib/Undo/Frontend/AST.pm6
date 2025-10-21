unit module Undo::Frontend::AST;

role Line {
  #submethod BUILD { ... }
}

# expressions
role Expression does Line {
  #submethod BUILD { ... }
}

role Name does Expression {
  #submethod BUILD { ... }
}

class Name::Qualified does Name {
  has Str @.module;
  has Str $.name;
}

class Name::Unqualified does Name {
  has Str $.name;
}

# the literals!
role Literal does Expression {
  #submethod BUILD { ... }
}

class Literal::Num does Literal {
  has Int $.value;
}

class Literal::String does Literal {
  has Str $.value;
}

#class Literal::Variable {
#  has Name $.name;
#}

# Can't be called "Block"
class Block_ is export {
  has Line @.body;
}

class Expression::Call does Expression {
  has Expression $.fn;
  has Expression @.argument;
}

class Expression::Conditional does Expression {
  has Expression $.condition; # TODO use something else?
  has Block_ $.then;
  has Block_ $.else;
}

class Expression::Loop does Expression {
  has Expression $.condition;
  has Block_ $.block;
}

class Expression::InstantiateField {
  has Str $.field;
  has Expression $.value;
}

class Expression::Instantiate does Expression {
  has Str $.name;
  has Expression::InstantiateField @.field;
}

role Expression::MatchSubject {
}

class Expression::MatchSubject::Variable does Expression::MatchSubject {
  has Str $.variable;
}

class Expression::MatchSubject::Constructor does Expression::MatchSubject {
  has Str $.constructor;
  has Expression::MatchSubject @.sub;
}

class Expression::MatchBranch {
  has Expression::MatchSubject $.subject;
  has Block_ $.block;
}

class Expression::Match does Expression {
  has Expression $.topic;
  has Expression::MatchBranch @.branch;
}

role Decl does Line {
  # submethod BUILD { ... }
}

class Decl::Variable does Decl {
  has Str $.name;
  has Expression $.init;
}

class Decl::ImportElement {
  has Str $.name;
}

class Decl::ImportElement::ADT is Decl::ImportElement {
  has Str @.constructor;
}

class Decl::ImportPath {
  has Str @.path;
  has Decl::ImportElement @.elements;
}

class Decl::ImportList does Decl {
  has Decl::ImportPath @.paths;
}

class Decl::Parameter_ is export {
  has Str $.name;
}

class Decl::Fn does Decl is export {
  has Str $.name;
  has Decl::Parameter_ @.parameter;
  has Block_ $.body;
}

class Decl::Enum { ... }

# TODO split ByPosVariant/StructVariant?
class Decl::Enum::Variant {
  has Str $.name;
  has Str @.parameter;
}

class Decl::Enum does Decl {
  has Str $.name;
  has Decl::Enum::Variant @.variant;
}
