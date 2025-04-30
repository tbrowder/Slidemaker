#!/usr/bin/env raku

use experimental :rakuast;

use Slidemaker::RakuDoc::To::Parts;

my $ifil = "resources/real-pod-example.rakudoc";

my $ast = $ifil.IO.slurp.AST;

say rakudoc2text($ast);

