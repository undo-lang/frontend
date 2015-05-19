use lib 'lib/';
use Test;
use Undo::Grammar;

plan 6;


ok Undo::Grammar.parse('', :rule<exprlist>), 'can parse an EMPTY list of exprs';

ok Undo::Grammar.parse('a, b, c', :rule<exprlist>), 'can parse a list of exprs';

ok Undo::Grammar.parse(q:to/code/), 'can parse calls';
  foo()
code

ok Undo::Grammar.parse(q:to/code/), 'can pass arguments to calls';
  foo(1, a, "hey")
code

ok Undo::Grammar.parse(q:to/code/), 'can parse calls + nested calls';
  foo(3, bar(4, 5))
code

ok Undo::Grammar.parse(q:to/code/), 'can parse if';
  if bar(3, b) {
    y()
  }
code

ok Undo::Grammar.parse(q:to/code/, :rule<block>), 'can parse multilines blocks';
  {
    x()
    y()
  }
code

ok Undo::Grammar.parse(q:to/code/), 'can parse var';
  var a, b, c
code

=begin x
ok Undo::Grammar.parse(q:to/code/), 'can parse if with else';
  if bar(3, b) {
    x()
  } else {
    y()
  }
code

ok Undo::Grammar.parse(q:to/code/), 'can parse loop';
  loop foo {
    bar(buz)
  }
code

ok Undo::Grammar.parse(q:to/code/), 'can parse string literals';
  hello(1, "hello")
code

ok Undo::Grammar.parse(q:to/code/), 'can parse infix operators + nested inner exprs';
  print(if a + b { 1 } else { 2 } + 2)
code

=end x

#is parse(''), '', 'empty strings give empty parses';
