unit class Undo::Frontend::Actions;
use fatal;
use Undo::Frontend::AST;

method TOP($/) { $.block($/); }

method decl:sym<fn> ($/) { make $<fn-decl>.made; }

method fn-decl($/) {
  make Fn.new(
    :name($<id>.made.name),
    :parameter($<parameters>.made),
    :body($<block>.made),
  );
}

method import-element($/) {
  if $<constructors> {
    make Decl::ImportElement::ADT.new(
      :name($<id>.made.name),
      :constructor($<constructors>.map(*.made.name))
    );
  } else {
    make Decl::ImportElement.new(
      :name($<id>.made.name)
    );
  }
}

method import-path($/) {
  # XXX Error on `A ()`
  my $import = Decl::ImportPath.new(
    :path(@*IMPORT-PATH),
    :elements($<elements>».made)
  );
  # XXX could probably remove the dynamic variable in the grammar, and add a prefix
  #     to all $<import-path> here
  make ($import, |$<import-path>».made);
}

method import-decl($/) {
  my @*IMPORT-PATH;
  my @paths = flat flat $<import-path>».made;
  make Decl::ImportList.new(:@paths);
}

method parameters($/) {
  make $<id>.list.map(-> $id { Parameter_.new(:name($id.made.name)) });
}

method var-decl($/) {
  make $<var>.map({ Decl::Variable.new(:name(~.<id>), :init(.<outer-expr>.made)) });
}

method enum-variant($/) {
  my @param = $<param> ?? $<param>».Str !! ();
  make Decl::Enum::Variant.new(
    :name(~$<id>),
    :parameter(@param)
  );
}

method enum-decl($/) {
  make Decl::Enum.new(
    :name(~$<id>),
    :variant($<enum-variant>».made)
  );
}

method block($/) {
  make Block_.new(body => $<lines>.made);
}

method lines($/) {
  make $<line>».made;
}

method line($/) {
  with $<fn-decl> {
    make .made;
  } orwith $<var-decl> {
    make (|.made);
  } orwith $<import-decl> {
    make .made;
  } orwith $<enum-decl> {
    make .made;
  } orwith $<outer-expr> {
    make .made;
  } else {
    make Empty
  }
}

method id($/) {
  # TODO manage qualified names
  make Name::Unqualified.new(:name($/.Str));
}

method outer-expr($/) {
  # !!!!
  # TODO precedence
  # !!!!

  my $val = $<call-expr>[0].made;
  for $<call-expr>.skip(1) -> $next {
    my $op = ~$<infix>[$++];
    $val = Expression::Call.new(
      :fn(Name::Qualified.new(:module(("Prelude",)), :name(~$op))),
      :argument(($val, $next.made))
    );
  }
  make $val
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

method match-subject($/) {
  if ~$<field> {
    make Expression::MatchSubject::Constructor.new(
      :constructor($<id>.made.name),
      :sub($<match-subject>».made)
    );
  } else {
    make Expression::MatchSubject::Variable.new(
      :variable($<id>.made.name)
    );
  }
}

method match-branch($/) {
  make Expression::MatchBranch.new(
    :subject($<match-subject>.made),
    :block($<block>.made),
  );
}

method inner-expr:match ($/) {
  make Expression::Match.new(
    :topic($<topic>.made),
    :branch($<match-branch>».made),
  );
}

method field($/) {
  make Expression::InstanteField.new(
    :field(~$<id>),
    :value($<expr>.made),
  )
}

method inner-expr:id-or-instantiate ($/) {
  with $<instantiate> {
    make Expression::Instantiate.new(
      :name($<id>.made),
      :field(.<instantiate-field>».made)
    );
  } else {
    make $<id>.made;
  }
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

method literal:sym<num> ($/) {
  make Literal::Num.new(:value($/.Int));
}

method literal:sym<str> ($/) {
  make Literal::String.new(:value($<string>.made));
}

# -- Section from JSON::Tiny
method string($/) {
    my $str =  +@$<str> == 1
        ?? $<str>[0].made
        !! $<str>».made.join;

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
