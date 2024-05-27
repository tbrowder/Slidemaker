use Test;

use Pod::Load;

use Slidemaker;
use Slidemaker::ParsePod;

my $p = Slidemaker::ParsePod.new;
isa-ok $p, Slidemaker::ParsePod;

my $f1 = "t/data/slides.pod";
my $pod = (load $f1).head;
isa-ok $pod, Pod::Block, "isa Pod::Block";
is $pod.elems, 1, "1 pod elem";

done-testing;
