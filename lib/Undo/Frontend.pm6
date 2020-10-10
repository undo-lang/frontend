use Serialize::Tiny;
unit class Undo::Frontend;
use Undo::Frontend::Grammar;
use Undo::Frontend::Actions;

sub parse(Str $code) is export {
  Undo::Frontend::Grammar.parse($code,
    :actions(Undo::Frontend::Actions.new)).made;
}

sub serialize-ast($parse-tree) is export {
  # this discards Literal:: and Name::
  serialize($parse-tree,
    :class-key{ type => .split('::')[*-1] given S/_//; }
  );
}
