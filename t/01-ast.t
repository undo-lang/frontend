use lib 'lib/';
use Test;
use Undo::AST;

dies_ok { Literal.new }, "can't build a new Literal";

dies_ok { Expression.new  }, "can't build an Expression";

my $expr-call = Expression::Call.new(:fn({ 1 }));

lives_ok {
  #Expression::Loop.new(:condition($expr-call), :termination(Any));
}
