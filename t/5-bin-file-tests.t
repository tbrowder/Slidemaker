use Test;

use Pod::Load;
use File::Temp;
use File::Directory::Tree;
use PDF::Lite;
use Pod::To::PDF::Lite;
use PDF::Font::Loader :load-font;

use Slidemaker;
use Slidemaker::Resources;
use Slidemaker::RakudocUtils;
use Slidemaker::PDF;
use Slidemaker::Classes;

my $debug = 0;

my $tdir;

if $debug {
   $tdir = "/tmp/A";
   rmtree $tdir if $tdir.IO.d;
   mkdir $tdir; 
}
else {
   $tdir = tempdir;
}

lives-ok {
    run "raku", "-I.", "bin/parse-slides2", "go";
}, "see dir '$tdir'";

done-testing;
