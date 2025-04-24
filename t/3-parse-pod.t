use Test;

use Pod::Load;

use Slidemaker;

my $f1 = "t/data/slides.rakudoc";
my $pod = (load $f1).head;
isa-ok $pod, Pod::Block, "isa Pod::Block";
is $pod.elems, 1, "1 pod elem";

done-testing;
