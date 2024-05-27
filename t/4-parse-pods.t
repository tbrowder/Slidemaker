use Test;

use Pod::Load;

my $f2 = "t/data/two-pods.raku";
my @pod = load $f2;
is @pod.elems, 2, "2 pod elems";

done-testing;
