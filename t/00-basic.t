use Test;
use lib 'lib/';
#use Undo::Frontend;
use Undo::Grammar;

plan 1;

#say Undo::Frontend.new.perl;

say Undo::Grammar.parse("foo(1, bar(2));");


is '', '';

#is parse(''), '', 'empty strings give empty parses';
