#!/usr/bin/env raku
use lib 'lib/';
use Test;
use JSON::Fast;
use Serialize::Tiny;
use Undo::Frontend;

sub run-code {
  from-json(to-json( # Raku is dumb
    serialize-ast(parse($^content))
  ));
}

for dir('t/ast') { # TODO base on current dir
  next unless /'.undo'$/;
  my $expected = $_ ~ '.json';
  my %serialized = run-code(.slurp);
  
  unless $expected.IO.e {
    skip "No expected AST for $_ (missing $expected), here's the expected json:\n{to-json %serialized}";
    next;
  }
  my %expected = from-json(slurp $expected);
  is-deeply %serialized, %expected, "$_ => $expected";
}

done-testing;
