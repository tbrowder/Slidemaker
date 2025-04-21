#!/usr/bin/env raku

die "Install and use RakuAST::RakuDoc9";

use Pod::To::Text;
use Pod::Load;

my $f = "resources/examples.rakudoc";
my $pod = load $f;
my $text = pod2text $pod;
say $text;


