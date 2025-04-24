use Test;
use Pod::Load;

my @modules = <
Slidemaker
Slidemaker::PDF
Slidemaker::RakudocUtils
Slidemaker::Slide
Slidemaker::Resources
>;

for @modules {
    use-ok $_; say "Module '$_', use-ok";
}

lives-ok {
    my @pods = load "docs/README.rakudoc";
}, "checking rakudoc";

done-testing;
