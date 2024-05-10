use Test;
use RakupodObject;

use Slidemaker;
use Utils;

my $pod-obj;

# exercise loading either the example in resources or one in t/data
my @rpaths = get-resources-paths;
my $eg-path;
for @rpaths {
    if $_.contains("example.pod") {
        $eg-path = $_;
    }
}
my $istr = get-content $eg-path;
lives-ok {
    $pod-obj = extract-rakupod-object $istr;
}, "pod obj from a string in resources file";

# data path
my $ifil = "t/data/docs-eg.pod".IO; # the '.IO' is required by RakupodObject
lives-ok {
    $pod-obj = extract-rakupod-object $ifil;
}, "pod obj from a file in t/data";

done-testing;
