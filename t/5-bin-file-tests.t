use Test;
use Pod::Load;
use File::Temp;
use PDF::Lite;
use Pod::To::PDF::Lite;
use PDF::Font::Loader :load-font;

use Slidemaker;
use Slidemaker::Resources;
use Slidemaker::RakudocUtils;
use Slidemaker::PDF;
use Slidemaker::Classes;

lives-ok {
    run "raku", "-I.", "bin/parse-slides2", "go";
} 

done-testing;
