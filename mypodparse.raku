#!/usr/bin/env raku

use Pod::Load;

#my $f = "resources/examples.rakudoc";
my $f = "resources/real-pod-example.rakudoc";
my $pod-tree = load-pod $f.IO.slurp;
for $pod-tree -> $pod-item {
    if $pod-item.config {
        my %h = $pod-item.config;
        for %h.kv -> $k, $v {
            say "key: $k => $v";
        }
    }
    for $pod-item.contents -> $pod-block {
    }

}


