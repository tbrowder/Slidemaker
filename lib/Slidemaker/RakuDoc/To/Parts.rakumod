use experimental :rakuast;

unit class Slidemaker::RakuDoc::To::Parts;

# use RakuDoc::To::Parts;
# say RakuDoc::To::Parts.render($ast)
#
# or using the exported "rakudoc2parts" subroutine:
#
# use RakuDoc::To::Parts;
# say rakudoc2parts($ast);
#
# Note that a RakuAST of a source / documentation file can easily be
# obtained as follows:
#
# my $ast = $filename.IO.slurp.AST;

# In addition to the Str that is part of each pod part, we
# return a class object that identifies the part.

class Part is export {
    has $.part is required; # the type of the part
    has $.text is required; # the string part
    has $.ast;              # the ast part
}


method render($ast) { $ast.map(&rakudoc2parts).join }

# colorless ANSI constants
my constant RESET            = "\e[0m";
my constant BOLD-ON          = "\e[1m";
my constant ITALIC-ON        = "\e[3m";
my constant UNDERLINE-ON     = "\e[4m";
my constant INVERSE-ON       = "\e[7m";
my constant STRIKETHROUGH-ON = "\e[9m";
my constant OVERLINE-ON      = "\e[9m"; # TODO: use correct code, if any

my constant BOLD-OFF          = "\e[22m";
my constant ITALIC-OFF        = "\e[23m";
my constant UNDERLINE-OFF     = "\e[24m";
my constant INVERSE-OFF       = "\e[27m";
my constant STRIKETHROUGH-OFF = "\e[29m";
my constant OVERLINE-OFF      = "\e[29m"; # TODO: use correct code, if any

my sub bold(str $text)          { BOLD-ON          ~ $text ~ BOLD-OFF          }
my sub italic(str $text)        { ITALIC-ON        ~ $text ~ ITALIC-OFF        }
my sub underline(str $text)     { UNDERLINE-ON     ~ $text ~ UNDERLINE-OFF     }
my sub inverse(str $text)       { INVERSE-ON       ~ $text ~ INVERSE-OFF       }
my sub strikethrough(str $text) { STRIKETHROUGH-ON ~ $text ~ STRIKETHROUGH-OFF }
my sub overline(str $text)      { OVERLINE-ON      ~ $text ~ OVERLINE-OFF      }

# ANSI formatting allowed
my constant %formats =
  B => &bold,
  C => &bold,
  L => &underline,
  D => &underline,
  #O => &overline,
  R => &inverse,
  S => &strikethrough,
;

#-- primary dispatchers --------------------------------------------------------
my proto sub rakudoc2parts(| --> Part:D) is export {

    my $text;

    # not the first time we call
    if @*NOTES.defined {
        if @*NOTES -> @notes {
            my $index = @notes.elems - 1;
            my str @parts = [];
            @parts.push: (++$index).Str(:superscript) ~ " $_\n" for @notes;
            $text = @parts.join;
        }
    }

    # the first time we call
    else {
        my @*NOTES;
        my @*XREFS;
        my str @parts = {*}

        if @*NOTES -> @notes {
            my $index = 0;

            @parts.push: "\nNOTES\n-----\n";
            @parts.push: (++$index).Str(:superscript) ~ " $_\n" for @notes;
        }

        if @*XREFS -> @xrefs {
            my $index = 0;

            @parts.push: "\nREFERENCES\n----------\n";
            @parts.push: (++$index).Str(:superscript) ~ " $_\n" for @xrefs;
        }
        $text = @parts.join
    }
    Part.new: :$text, :part("unk");
}

# basically make sure Cool stuff that crept in doesn't bomb
my multi sub rakudoc2parts(Str:D $string --> Str:D) { $string   }
my multi sub rakudoc2parts(Cool:D $cool  --> Str:D) { $cool.Str }

# make sure we only look at interesting ::Doc objects
my multi sub rakudoc2parts(RakuAST::Node:D $ast --> Part:D) { # Str:D) {
    my $text = $ast.rakudoc.map(&rakudoc2parts).join;
    Part.new: :$text, :part("unk");
}

# the general handler, with specific sub-actions
my multi sub rakudoc2parts(RakuAST::Doc::Block:D $ast --> Part:D) { # Str:D) {

    # Set up dynamic lookup for allowable markup letters
    my %*OK := $ast.allowed-markup;

    my $text;
    given $ast.type {
        when 'alias'         { $text = '';                  }
        when 'code'          { $text = code2parts($ast);    }
        when 'comment'       { $text = '';                  }
        when 'config'        { $text = '';                  }
        when 'head'          { $text = heading2parts($ast); }
        when 'implicit-code' { $text = code2parts($ast);    }
        when 'item'          { $text = item2parts($ast);    }
        when 'pod'           { $text = paragraphify($ast);  }
        when 'rakudoc'       { $text = paragraphify($ast);  }
        when 'table'         { $text = table2parts($ast);   }
        default              { $text = block2parts($ast);   }
    }
    Part.new: :$text, :part($ast.type);
}

# handle any declarator targets
my multi sub rakudoc2parts(RakuAST::Doc::DeclaratorTarget:D $ast --> Part:D) { # Str:D) {
    my str @parts;

    # an empty body so that scopes will be rendered as { ... }
    my constant $empty-body := RakuAST::Blockoid.new(
      RakuAST::StatementList.new(
        RakuAST::Statement::Expression.new(
          expression => RakuAST::Stub::Fail.new
        )
      )
    );

    # get the subject of the documentation
    sub accept($_) {
        .cut-WHY;
        my str $deparsed = .DEPARSE;
        @parts.push(bold($deparsed));
        @parts.push('-' x $deparsed.lines.map(*.chars).max);
    }

    given $ast.clone {
        when RakuAST::Routine | RakuAST::Package {
            .replace-body($empty-body);
            accept($_);
        }
        when RakuAST::VarDeclaration::Simple {
            accept($_);
        }
        default {
            accept($_);
        }
    }

    # normalize text somewhat
    sub normalize($doc) {
        $doc.join("\n").lines.map(*.trim-leading).join("\n")
    }

    @parts.push(normalize($_)) with try $ast.WHY.leading;
    @parts.push(normalize($_)) with try $ast.WHY.trailing;
    @parts.push("");
    @parts.join("\n");
}

# handle any markup such as B<foo>
my multi sub rakudoc2parts(RakuAST::Doc::Markup:D $ast --> Part:D) { # Str:D) {
    my str $letter = $ast.letter;
    my $s;
    if !%*OK{$letter} {
        if $letter ne 'E' && $ast.meta -> @meta {
            $s = $letter
              ~ $ast.opener
              ~ $ast.atoms.map(&rakudoc2parts).join
              ~ "|"
              ~ @meta.map(&rakudoc2parts).join
              ~ $ast.closer;
        }
        else {
            $s = $ast.Str;
        }
    }
    elsif $letter eq 'Z' {
        $s = '';
    }
    elsif $letter eq 'A' {
        $s = rakudoc2parts $ast.meta.head;
    }
    elsif $letter eq 'C' {
        $s = rakudoc2parts bold $ast.atoms.join;
    }
    else {
        my str $text = $ast.atoms.map(&rakudoc2parts).join;

        if $letter eq 'L' {
            $text = underline($text);

            # remember the URL as a note
            if $ast.meta.head -> $url {
                @*NOTES.push: $url;
                $s = $text ~ @*NOTES.elems.Str(:superscript);
            }

            # no URL specified
            else {
                $s = $text;
            }
        }
        elsif $letter eq 'X' {
            $text = bold($text);

            # remember the xref as a note
            if $ast.meta -> @meta {
                @*XREFS.push: @meta.map(*.join(', ')).join('; ');
                $s = $text ~ @*XREFS.elems.Str(:subscript);
            }

            # no URL specified
            else {
                $s = $text;
            }
        }
        elsif %formats{$letter} -> &hilight {
            $s = hilight($text);
        }
        else {
             $s = $text;
        }
    }
    Part.new: :text($s), :part("markup");
}

# handle simple paragraphs (that will be word-wrapped)
my multi sub rakudoc2parts(RakuAST::Doc::Paragraph:D $ast --> Part:D) { # Str:D) {
    # $ast.atoms.map(&rakudoc2parts).join.naive-word-wrapper ~ "\n\n"
    my $text = $ast.atoms.map(&rakudoc2parts).join.naive-word-wrapper ~ "\n\n";

    Part.new: :$text, :part("paragraph");
}

# handle a row in a table
my multi sub rakudoc2parts(RakuAST::Doc::LegacyRow:D $ast --> Part:D) { # Str:D) {
    # $ast.DEPARSE
    my $text = $ast.DEPARSE;
    Part.new: :$text, :part($ast.type);
}

#-- textification helpers ------------------------------------------------------

# produce a flattened text version of the given ast where each string
# is being considered a paragraph that needs to be word-wrapped
my sub paragraphify($ast) {
    $ast.paragraphs.map({
        when Str { .naive-word-wrapper ~ "\n\n" }
        default  { rakudoc2parts($_) }
    }).join
}

# produce a flattened text version of the given ast without furter modifications
my sub textify(RakuAST::Doc::Block:D $ast --> Part:D) { # Str:D) {
    # $ast.paragraphs.map(&rakudoc2parts).join
    my $text = $ast.paragraphs.map(&rakudoc2parts).join;
    Part.new: :$text, :part($ast.type);
}

# handle (implicit) code blocks
my sub code2parts(RakuAST::Doc::Block:D $ast --> Part:D) { # Str:D) {
    # textify($ast).indent(4)
    my $text = textify($ast).indent(4);
    Part.new: :$text, :part($ast.type);
}

# handle =head
my sub heading2parts(RakuAST::Doc::Block:D $ast --> Part:D) { # Str:D) {
    my str $text = textify($ast).trim-trailing;
    $text = $text ~ "\n" ~ ('-' x $text.chars) ~ "\n";

    my int $level = $ast.level.Int;
    $text.indent($level > 2 ?? 4 !! ($level - 1) * 2);
    
    Part.new: :$text, :part($ast.type);
}

# handle =item
my sub item2parts(RakuAST::Doc::Block:D $ast --> Part:D) { # Str:D)  {
    # ('* ' ~ textify($ast)).indent(2 * $ast.level)
    my $text = ('* ' ~ textify($ast)).indent(2 * $ast.level);
    Part.new: :part($ast.type), :$text;
}

# handle =table
my sub table2parts(RakuAST::Doc::Block:D $ast) {
    my $config := $ast.resolved-config;

    my str @parts;
    my int $header-row = $config<header-row> // -1;
    my int $header-width;
    my int $row        = -1;
    @parts.push("  $_") for $ast.paragraphs.map({
        # a divider row
        when Str {
            $_;
        }
        # an actual row
        default {
            my str $text = rakudoc2parts($_);
            if ++$row == $header-row {
                $header-width = $text.chars;
                bold($text)
            }
            else {
                $text
            }
        }
    });

    # center and underline any caption on top
    if $config<caption> -> $caption {
        my str $text = $caption.Str;  # also handle :caption<foo bar>
        my int $caption-width = $text.chars;
        $text = underline($text);
        @parts.unshift: '  ' ~ ($caption-width >= $header-width
          ?? $text
          !! (' ' x ($header-width - $caption-width) / 2) ~ $text
        );
    }

    @parts.join("\n") ~ "\n\n"
}

# all other =foo
my sub block2parts(RakuAST::Doc::Block:D $ast --> Part:D) { # Str:D) {
    my str $type = $ast.type;

    #bold($type)
    my $text = bold($type)
      ~ "\n" ~ ('-' x $type.chars)
      ~ "\n" ~ paragraphify($ast);
    Part.new: :part($type), :$text;
}

# vim: expandtab shiftwidth=4
