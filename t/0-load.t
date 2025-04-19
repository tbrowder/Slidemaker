use Test;
use Pod::Load;

my @modules = <
Slidemaker
Slidemaker::PDF
Slidemaker::ParsePod
Slidemaker::Slide
Slidemaker::Utils
>;

plan @modules.elems + 1;

for @modules {
    use-ok $_; say "Module '$_', use-ok";
}

lives-ok {
    my @pods = load "docs/README.rakudoc";
}, "checking rakudoc";

