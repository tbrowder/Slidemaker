unit module Slidemaker;

use Abbreviations;

use Slidemaker::Utils;
use Slidemaker::Slide;

my @slides;
my $pod-file;

multi action() is export {
    # usage
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <rakupod src file> [...options...]

    Uses the input file to create a PDF slide document. The output
    file name is the same as the input file but with a '.pdf'
    extension unless the 'pdf=X' option is used.

    Options (only the first letter of the option name is required):
      pdf=X    - Where X is the name of the output PDF file.
      format=X - Where X is the paper size (Letter or A4; default: Letter)
      orient=X - Where X is the orientation (landscape or portrait;
                   default: landscape
      example  - Creates a slide deck from the 'example.pod' file in
                   './resources'.  The resulting pdf slide deck and
                   the example source file are placed in the current directory.
    HERE
}

multi action(@*ARGS) is export {
    # handle args

    my $ifil;
    my $eg;
    my @args;
    for @*ARGS {
        if $_.IO.r {
            if not $ifil {
                $ifil = $_;
                next;
            }
            print qq:to/HERE/;
            FATAL: Input file '$_' is unexpected, you have already entered
                   an input file: '$ifil'.
            HERE
            exit;
        }
        if $_ ~~ /^ :i e/ {
            ++$eg;
            next;
        }
        @args.push: $_;
    }

    # must have an input file
    if $eg {
        # TODO make this work for an installed module
        # get the example file from '/resources'
        $ifil = "example.pod";
        my $str = get-content "./resources/$ifil";
        spurt "example.pod", $str;
    }

    unless $ifil {
        print qq:to/HERE/;
        FATAL: No input file was entered.
        HERE
        exit;
    }
    say "Using input file '$ifil'...";
    if $eg {
        say "  (in the current directory)";
    }
}
