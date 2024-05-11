use Test;

use RakupodObject;

use Slidemaker;
use Utils;

my $pod-obj;

# exercise loading the file in t/data
# data path
my $ifil = "t/data/docs-eg.pod";
lives-ok {
    $pod-obj = extract-rakupod-object $ifil;
}, "pod obj from a file in t/data";

done-testing;
