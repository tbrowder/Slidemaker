use Test;

use Pod::Load;

use Slidemaker;
use Utils;

my $pod-obj;

# exercise loading the file in t/data
# data path
my $ifil = "t/data/docs-eg.pod";
lives-ok {
    $pod-obj = (load $ifil).head;
}, "pod obj from a file in t/data";

done-testing;
