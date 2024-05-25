use Test;
use RakupodObject;

use Slidemaker;
use Slidemaker::ParsePod;

my $p = Slidemaker::ParsePod.new;

isa-ok $p, Slidemaker::ParsePod;

my $code = "t/data/slides.pod";
my $pod = extract-rakupod-object $code;
isa-ok $pod, Pod::Block;

done-testing;
