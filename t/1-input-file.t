use Test;
use RakupodObject;

use Slidemaker;
use Utils;

my $pod-obj;

# exercise loading either the example in resources or one in t/data
my $eg-path = "./resources/example.pod"; # (extract the pod as a string
my $istr = get-content $eg-path;
lives-ok {
    $pod-obj = extract-rakupod-object $istr;
}

# data path
my $ifil = "t/data/docs-eg.pod".IO; # the '.IO' is required by RakupodObject
lives-ok {
    $pod-obj = extract-rakupod-object $ifil;
}

done-testing;
