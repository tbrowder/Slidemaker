use Test;
use Pod::Load;

my @modules = <
Slidemaker
Slidemaker::Action
Slidemaker::PDF
Slidemaker::RakudocUtils
Slidemaker::Classes
Slidemaker::Resources
>;

subtest {
    for @modules {
        use-ok $_; 
    }
}

lives-ok {
    my @pods = load "docs/README.rakudoc";
}, "checking rakudoc";

done-testing;
