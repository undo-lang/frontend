use lib 'lib/';
use Test;
use Undo::Frontend::AST;

plan 2;

dies-ok { Literal.new }, "can't build a new Literal";

dies-ok { Expression.new  }, "can't build an Expression";

#my $expr-call = Expression::Call.new(:fn({ 1 }));

# lives-ok { Expression::Loop.new(:condition($expr-call), :termination(Any)); }
