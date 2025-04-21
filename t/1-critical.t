use Test;

use Pod::Load;

use Slidemaker;
use Slidemaker::Utils;

my $pod-obj;

# exercise loading the file in t/data
# data path
my $ifil = "t/data/docs-eg.rakudoc";
lives-ok {
    $pod-obj = (load $ifil).head;
}, "pod obj from a file in t/data";

done-testing;
