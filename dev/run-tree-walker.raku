#!/usr/bin/env raku

use Pod::TreeWalker;

use RakupodObject;

my $pod-file = "./orig/why-linux.pod6".IO;
my $pod-obj  = extract-rakupod-object($pod-file);

my $l = Pod::TreeWalker::Listener.new; 

my $walker = Pod::TreeWalker.new(:listener($l));

#say $walker.text-contents-of($pod-obj);
$walker.walk-pod($pod-obj);
for $pod-obj.contents {
    	
}

for $pod-obj.config.kv -> $k, $v {
}





