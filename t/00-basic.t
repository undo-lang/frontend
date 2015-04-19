use Test;
use lib 'lib/';
#use Undo::Frontend;
use Undo::Grammar;

plan 1;

#say Undo::Frontend.new.perl;

say Undo::Grammar.parse("foo(3, bar(4, 5))");

say Undo::Grammar.parse("3", :rule<literal>);


is '', '';

#is parse(''), '', 'empty strings give empty parses';
