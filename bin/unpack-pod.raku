#!/usr/bin/env raku

use RakupodObject;

my $ifil = "./t/data/slides.pod";

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Converts file '$ifil' to a pod tree.
    HERE
    exit;
}

my $pod = extract-rakupod-object $ifil;
my ($p, @c, %h);
$p = $pod;

my @pods;
@pods.unshift: $p;
my $idx = 0;
while @pods {
    $p = @pods.pop;
    @c = $p.contents;
    %h = $p.config;
    for %h.kv -> $k, $v {
        say "key: $k";
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
    }
    $res
}
