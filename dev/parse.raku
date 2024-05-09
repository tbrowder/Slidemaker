#!/usr/bin/env raku

use lib "../lib";
use Slidemaker;

my $ifil = "why-linux.pod6";

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Converts file '$ifil' to PDF slides.
    HERE
    exit;
}

