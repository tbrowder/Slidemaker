use Test;

use RakupodObject;

use Slidemaker;
use Slidemaker::Utils;
use File::Temp;

my $pod-obj;

# exercise loading the example in resources
my %rpaths = get-resources-hash;
my $eg = "example.pod";
my $eg-path;
if %rpaths{$eg}:exists {
   $eg-path = %rpaths{$eg}
}
else {
    die "FATAL: \$eg-path is undefined";
}

my $istr = get-content $eg-path;
lives-ok {
    $pod-obj = extract-rakupod-object $istr;
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
