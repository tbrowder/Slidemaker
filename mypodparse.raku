#!/usr/bin/env raku

die "Use RakuAST::RakuDoc9";
use Pod::To::Text;
use Pod::Load;

my $f = "resources/examples.rakudoc";
my $pod = load $f;
my $text = pod2text;
say $text;


