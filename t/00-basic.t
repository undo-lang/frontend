use lib 'lib/';
use Test;
use Undo::Frontend::Grammar;

plan 15;

my &parse = sub (|c) { Undo::Frontend::Grammar.parse(|c) };

ok parse('', :rule<exprlist>), 'can parse an EMPTY list of exprs';

ok parse('a, b, c', :rule<exprlist>), 'can parse a list of exprs';

ok parse(q:to/code/), 'can parse calls';
  foo()
code

ok parse(q:to/code/), 'can parse calls with a trailing semicolon';
  foo();
code

ok parse(q:to/code/), 'can pass arguments to calls';
  foo(1, a, "hey")
code

ok parse(q:to/code/), 'can parse calls + nested calls';
  foo(3, bar(4, 5))
code

ok parse(q:to/code/, :rule<block>), 'can parse multilines blocks';
  {
    x();

    y();
  }
code

ok parse(q:to/code/), 'can parse if';
  if a {
    y();
  }
code

ok parse(q:to/code/.trim), 'can parse var';
  var a, b, c
code

ok parse(q:to/code/), 'can parse if with else';
  if bar(3, b) {
    x()
  } else {
    y()
  }
code

ok parse(q:to/code/), 'can parse loop';
  loop foo {
    bar(buz)
  }
code

ok parse(q:to/code/), 'can parse string literals';
  hello(1, "hello")
code

ok parse(q:to/code/), 'can parse infix operators + nested inner exprs';
  print(if a + b { 1 } else { 2 } + 2)
code

# TODO test inner-expr:parens

ok parse(q:to/code/), 'can parse stupid stuff';
  loop if a { True } else { False } {
    x()
  }
code

ok parse(q:to/code/), 'can nest calls';
  f(1)("deux")(c);
code
