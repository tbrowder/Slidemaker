#!/usr/bin/env raku

use RakupodObject;

my $ifil = "../t/data/slides.pod";
my $pod = extract-rakupod-object $ifil;

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Converts file '$ifil' to a pod tree.
    HERE
    exit;
}

for @($pod).kv -> $i, $p {
    say "index $i";
    say $p.contents;
    say $p.config;
}


