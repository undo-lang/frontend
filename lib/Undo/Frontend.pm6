unit class Undo::Frontend;
use Undo::Frontend::Grammar;
use Undo::Frontend::Actions;

sub parse(Str $code) is export {
  Undo::Frontend::Grammar.parse($code,
    :actions(Undo::Frontend::Actions.new)).made;
}
