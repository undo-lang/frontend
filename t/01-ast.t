use lib 'lib/';
use Test;
use JSON::Fast;
use Serialize::Tiny;
use Undo::Frontend;

sub run-code {
  from-json(to-json( # Perl 6 is dumb
    serialize(parse($^content), :class-key<type>)
  ));
}

for dir('t/ast') { # TODO base on current dir
  next unless /'.undo'$/;
  my $expected = $_ ~ '.json';
  
  unless $expected.IO.e {
    skip "No expected AST for $_";
    next;
  }
  pass "$_ => $expected";
  my %expected = from-json(slurp $expected);
  my %serialized = run-code(.slurp);
  is-deeply %expected, %serialized, "Code gave the expected AST";
}

done-testing;
