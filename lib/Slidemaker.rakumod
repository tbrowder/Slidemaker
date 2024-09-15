unit module Slidemaker;

use Pod::To::PDF;
use Pod::To::Markdown;
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
      md       - Creates a Markdown version of the input file.
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
        # TODO use ?*RESOURCES
        handle-pdf "resources/example.rakudoc";
    }
}

use Pod::To::PDF:
use Pod::Load;
use Cairo;
sub handle-pdf(
    $podfile,  # file with rakupod contents
    :$save-as, # default: input name with extension replaced with 'pdf'
    :$margins, # pod2pdf default: 0,
    :$media = 'letter', # TODO improve media handling
    :$orientation = 'portrait', # or landscape
    :$debug,
    ) is export {

    my ($width, $height);

    #=== create the PDF file
    # from David's Pod::To::PDF module's routine 'pod2pdf':
    # inputs:
    my $pod = load($file.IO);
    my Cairo::Surface::PDF $pdf = pod2pdf(
        $podfile,
        # options
        :$save-as,
        :$surface, # not sure if I need this for a single doc
        :$width = (8.5 * 72),
        :$height = (11 * 72),
        :$margins = 20, # default
    );
    $pdf.finish;
    #=== finish the PDF file


}

