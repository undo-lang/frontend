use Test;
use lib 'lib/';
#use Undo::Frontend;
use Undo::Grammar;

plan 1;

#say Undo::Frontend.new.perl;

#say Undo::Grammar.parse(q:to/code/);
#  mhh(b)
#  foo(3, bar(4, 5))
#  bat(5)
#code

say Undo::Grammar.parse(q:to/code/);
  if bar(3, b) {
    x()
    bat(5)
  }
code

is '', '';

#is parse(''), '', 'empty strings give empty parses';
