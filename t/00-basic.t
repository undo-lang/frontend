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

# say Undo::Grammar.parse(q:to/code/);
#   if bar(3, b) {
#     x()
#     bat(5)
#   }
# code

# say Undo::Grammar.parse(q:to/code/);
#   for foo {
#     bar(buz)
#   }
# code

# say Undo::Grammar.parse(q:to/code/);
#   hello(1, "hello")
# code

say Undo::Grammar.parse(q:to/code/);
  print([1, 2, 3])
code

is '', '';

#is parse(''), '', 'empty strings give empty parses';
