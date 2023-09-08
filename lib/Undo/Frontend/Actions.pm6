unit class Undo::Frontend::Actions;
use fatal;
use Undo::Frontend::AST;

method TOP($/) { $.block($/); }

method decl:sym<fn> ($/) { make $<fn-decl>.made; }

method fn-decl($/) {
  make Fn.new(
    name => $<id>.made.name,
    parameter => $<parameters>.made,
    body => $<block>.made,
  );
}

method import-path($/) {
  my $import = do if +$<spread> {
    Decl::ImportPath::Spread.new(
      path => @*IMPORT-PATH,
      spread => $<spread>>>.made>>.name, # ??
    );
  } else {
    Decl::ImportPath::Simple.new(path => @*IMPORT-PATH);
  }
  make ($import, |$<import-path>>>.made);
}

method import-decl($/) {
  my @*IMPORT-PATH;
  my @paths = flat flat $<import-path>>>.made;
  make Decl::ImportList.new(:@paths);
}

method parameters($/) {
  make $<id>.list.map(-> $id { Parameter_.new(name => $id.made.name) });
}

method decl:sym<var> ($/) { make $<var-decl>.made; }

method var-decl($/) {
  make $/<id>>>.map({ Decl::Variable.new(id => $_) });
}

method block($/) {
  make Block_.new(body => $<lines>.made);
}

method lines($/) {
  make $<line>>>.made;
}

method line($/) {
  make ($<fn-decl> // $<var-decl> // $<import-decl> // $<outer-expr>).made // Empty;
}

method id($/) {
  # TODO manage qualified names
  make Name::Unqualified.new(:name($/.Str));
}

method outer-expr($/) {
  # !!!!
  # TODO
  # !!!!
  # manage infixes

# DISCARD THE REST CURRENTLY
  make $<call-expr>[0].made;
}

method inner-expr:if ($/) {
  make Expression::Conditional.new(
    :condition($<cond>.made),
    :then($<then>.made),
    :else($<else>.made),
  );
}

method inner-expr:loop ($/) {
  make Expression::Loop.new(
    :condition($<cond>.made),
    :block($<body>.made),
  );
}

method inner-expr:id ($/) {
  make $<id>.made;
}

method inner-expr:literal ($/) {
  make $<literal>.made;
}

method inner-expr:parens ($/) {
  make $<outer-expr>.made;
}

method call-expr($/) {
  my $start = $<inner-expr>.made;
  my @calls = $<exprlist>».made;
  make ($start, |@calls).reduce(-> $fn, @argument {
    Expression::Call.new(:$fn, :@argument);
  });
}

method exprlist($/) {
  make [$<outer-expr>».made];
}

method literal:sym<num>($/) {
  make Literal::Num.new(value => $/.Int);
}

method literal:sym<str>($/) {
  make Literal::String.new(value => $<string>.made);
}

# -- Section from JSON::Tiny
method string($/) {
    my $str =  +@$<str> == 1
        ?? $<str>[0].made
        !! $<str>>>.made.join;

    # see https://github.com/moritz/json/issues/25
    # when a combining character comes after an opening quote,
    # it doesn't become part of the quoted string, because
    # it's stuffed into the same grapheme as the quote.
    # so we need to extract those combining character(s)
    # from the match of the opening quote, and stuff it into the string.
    if $0.Str ne '"' {
        my @chars := $0.Str.NFC;
        $str = @chars[1..*].chrs ~ $str;
    }
    make $str
}

method str($/)               { make ~$/ }

my %h = '\\' => "\\",
        '/'  => "/",
        'b'  => "\b",
        'n'  => "\n",
        't'  => "\t",
        'f'  => "\f",
        'r'  => "\r",
        '"'  => "\"";
method str_escape($/) {
    if $<utf16_codepoint> {
        make utf16.new( $<utf16_codepoint>.map({:16(~$_)}) ).decode();
    } else {
        make %h{~$/};
    }
}
# -- END Section from JSON::Tiny
