use Test;

use Pod::Load;
use Slidemaker;
use Slidemaker::Resources;
use Slidemaker::RakudocUtils;
use Slidemaker::PDF;
use Slidemaker::Classes;

lives-ok {
    run "raku", "-I.", "bin/parse-slides2", "go";
}

