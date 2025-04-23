use Test;

use Pod::Load;
use File::Temp;

use Slidemaker;
use Slidemaker::Utils;

my $pod-obj;

# exercise loading the example in resources
my %rpaths = get-resources-hash;
my $eg = "example.rakudoc";
my $eg-path;
if %rpaths{$eg}:exists {
   $eg-path = %rpaths{$eg}
}
else {
    die "FATAL: \$eg-path is undefined";
}

my $istr = get-content $eg-path;
lives-ok {
    $pod-obj = (load $istr).head;
}, "pod obj from a string in resources file";

# check downloading resource files
my $debug = 0;
my $tdir;
if $debug {
    $tdir = './t';
}
else {
    $tdir = tempdir;
    chdir $tdir;
}

lives-ok {
    show-resources;
}

lives-ok {
    download-resources;
}

done-testing;
