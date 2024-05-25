use Test;
use RakupodObject;

use Slidemaker;
use Slidemaker::ParsePod;

my $p = Slidemaker::ParsePod.new;

isa-ok $p, Slidemaker::ParsePod;

#my $code = "t/data/slides.pod";
my $code = "t/data/slides-noconfig.pod";
my $pod = extract-rakupod-object $code;
say $pod.gist;
#exit;


$p.traverse: $pod;
#$p.traverse: $code;

done-testing;
