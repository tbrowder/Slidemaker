#!/usr/bin/env raku

use Pod::Load;

my $ifil = "./t/data/slides.pod";

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <mode>

    Modes:
      go     - Converts file '$ifil' to a pod tree
      <file> - Converts file '<file>' to a pod tree

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
