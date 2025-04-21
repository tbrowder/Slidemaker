#!/usr/bin/env raku

use Pod::Load;

my $ifil = "./t/data/slides.pod";

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <mode>

    Modes:
      go     - Converts file '$ifil' to a PDF slide deck
      <file> - Converts file '<file>' to a PDF slide deck

    HERE
    exit;
}

my $pod-fil;

my $arg = @*ARGS.head;
if $arg.IO.r {
    $pod-fil = $arg;
}
else {
    $pod-fil = $ifil;
}

# read the input file and split into slide chunks
# each chunk consists of the text starting at
# each =slide until the EOF or the next =slide

class Config {
}

class Slide {
    has $.title;
    has @.lines;
    has %.config;
}

my @slides;

# recognized chunks
my $curr-slide   = 0;
my $curr-comment = 0;
my $curr-config  = 0;

my %config = %();

my @lines = $pod-fil.IO.lines;
for @lines.kv -> $i, $v {
    my $line-num = $i+1;

    when $v ~~ /^ \h* '=begin' \h+ (\N+) / {
        my $txt = ~$0;
        if $txt ~~ /:i comment / {
            if $curr-comment {
                die "FATAL: Nested comments not allowed":
            }
            $curr-comment = 1;
        }
        elsif $txt ~~ /:i raku? pod / {
            next; # ignore
        }
    }
    when $v ~~ /^ \h* '=end' \h+ (\N+) / {
        my $txt = ~$0;
        if $txt ~~ /:i comment / {
            if $curr-comment {
                $curr-comment = 0;
            }
            else {
                die "FATAL: End comment with no matching begin";
            }
        }
        elsif $txt ~~ /:i raku? pod / {
            next; # ignore
        }
    }
    when $v ~~ /^ \h* '=comment' \h+ (\N+) / {
        my $txt = ~$0;
        # ignore inline comment
        next;
    }
    when $v ~~ /^ \h* '=' [s|S]lide \h+ (\S+) / {
        my $title = ~$0;
        unless $title.defined {
            die "FATAL: No slide title defined at line $line-num";
        }

        # ends any existing Slide
        if $curr-slide {
            @slides.push: $curr-slide;
            $curr-slide = 0;
        }
        # begins a new Slide
        $curr-slide = Slide.new: :$title; # ok
    }
    when $v ~~ /^ \h* '=for' (\N+) / {
        my $txt = ~$0;
        if $txt ~~ /:i configuration / {
            $curr-config = 1;
        }
    }
    when $v ~~ /^ \h* '=' (\N+) / {
        my $txt = ~$0;
        if $curr-config {
            # config line is space separated tokens
            my @tokens = $txt.words;
        }
        else {
            die "FATAL: Unexpected line: '$txt'";
        }
    }
    default {
        next if $curr-comment;
        if $curr-slide {
            $curr-slide.lines.push: $v;
        }
        else {
            say "Unexpected line number {$i+1}: '$v'";
            say " curr-slide:   ", $curr-slide;
            say " curr-comment: ", $curr-comment;
            say " curr-config:  ", $curr-config;
        }
    }
}

if $curr-slide {
    @slides.push: $curr-slide;
    $curr-slide = 0;
}

=finish


my @roots = load $pod-fil;
my $nr = @roots.elems;
if $nr > 1 {
    print qq:to/HERE/;
    WARNING: This input pod file has $nr roots. This program
    is not meant to handle a pod file with more than one pod
    root. 

    Exiting.
    HERE
    exit;
}


my ($p, @c, %h);
$p = @roots.head;

my @pods;
@pods.unshift: $p;
my $idx = 0;
while @pods {
    $p = @pods.pop;
    %h = $p.config if $p.config;
    @c = $p.contents if $p.contents;
    for %h.kv -> $k, $v {
        say "config key: $k";
        say "  value: $v";
    }
    for @c -> $c {
        my $typ = is-pod($c);
        unless $typ {
            say "Found content $idx: $c";
            next;
        }
        ++$idx;
        say "Found a Pod object $idx: $typ";
        with $typ {
            when /:i named / {
                my $nam = $c.name.lc;
                say "  Its name is '$nam'";
                if $nam eq 'slide' {
                    say "Starting a new slide...";
                }
            }
            when /:i fc / {
                my $fc = $c.type;
                say "  Its type is '$fc'";
                my @arr = $c.meta;
                say "  Its meta is '{@arr.gist}'";
            }
            when /:i item / {
                my $lvl = $c.level;
                say "  Its level is '$lvl'";
            }
        }
        @pods.unshift: $c;
    }
}

sub is-pod($o) {
    my $res = 0;
    with $o {
        when Pod::Block::Para       { $res = <Para>       }
        when Pod::Block::Named      { $res = <Named>      }
        when Pod::Block::Declarator { $res = <Declarator> }
        when Pod::Block::Code       { $res = <Code>       }
        when Pod::Block::Comment    { $res = <Comment>    }
        when Pod::Block::Table      { $res = <Table>      }
        when Pod::Heading           { $res = <Hdg>        }
        when Pod::Item              { $res = <Item>       }
        when Pod::Defn              { $res = <Defn>       }
        when Pod::FormattingCode    { $res = <FC>         }
        default                     { $res = <Unknown>    }
    }
    $res
}
