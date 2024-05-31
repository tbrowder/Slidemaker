use Test;
use Pod::Load;

use-ok "Slidemaker";
use-ok "Slidemaker::PDF";
use-ok "Slidemaker::ParsePod";
use-ok "Slidemaker::Slide";
use-ok "Slidemaker::Utils";

lives-ok {
    my @pods = load "docs/README.rakudoc";
}, "checking rakudoc";

done-testing;
