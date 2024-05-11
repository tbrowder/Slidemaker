#! /usr/bin/env false

use v6.c;

use Pod::To::Anything::Subsets;

#| A base role for writing a Perl 6 Pod formatters with. It contains render
#| methods to take care of some plumbing efforts, so all you need to do is
#| define some render methods for the Pod blocks you want to give special
#| attention.
unit role Pod::To::Anything;

#| A catch method for lists of Pod objects, as you generally find them in
#| C<$=pod>. It will loop through all these documents and join them
#| together as a single document.
multi method render (@pod --> Str) { @pod.map({ self.render($_) }).join.trim }

#| Return nothing, as comments are not ment to be processed.
multi method render (Pod::Block::Comment $ --> Str) { '' }
multi method render (Pod::FormattingCode::Z:D $ --> Str) { '' }

#| If the object given is just a plain Str, return it unmodified. If you
#| need to escape certain characters in all text, this is the place to do
#| it.
multi method render (Str:D $pod --> Str) { $pod }

# These render methods cover all available Pod constructs. These should
# all be implemented to ensure your Pod formatter will work as intended.
multi method render (Pod::Block::Code:D $ --> Str) { … }
multi method render (Pod::Block::Declarator:D $ --> Str) { … }
multi method render (Pod::Block::Named::Author:D $ --> Str) { … }
multi method render (Pod::Block::Named::Name:D $ --> Str) { … }
multi method render (Pod::Block::Named::Subtitle:D $ --> Str) { … }
multi method render (Pod::Block::Named::Title:D $ --> Str) { … }
multi method render (Pod::Block::Named::Version:D $ --> Str) { … }
multi method render (Pod::Block::Named::Pod:D $ --> Str) { … }
multi method render (Pod::Block::Para:D $ --> Str) { … }
multi method render (Pod::Block::Table:D $ --> Str) { … }
multi method render (Pod::FormattingCode::B:D $ --> Str) { … }
multi method render (Pod::FormattingCode::C:D $ --> Str) { … }
multi method render (Pod::FormattingCode::E:D $ --> Str) { … }
multi method render (Pod::FormattingCode::I:D $ --> Str) { … }
multi method render (Pod::FormattingCode::K:D $ --> Str) { … }
multi method render (Pod::FormattingCode::L:D $ --> Str) { … }
multi method render (Pod::FormattingCode::N:D $ --> Str) { … }
multi method render (Pod::FormattingCode::P:D $ --> Str) { … }
multi method render (Pod::FormattingCode::R:D $ --> Str) { … }
multi method render (Pod::FormattingCode::T:D $ --> Str) { … }
multi method render (Pod::FormattingCode::U:D $ --> Str) { … }
multi method render (Pod::FormattingCode::V:D $ --> Str) { … }
multi method render (Pod::FormattingCode::X:D $ --> Str) { … }
multi method render (Pod::Heading:D $ --> Str) { … }
multi method render (Pod::Item:D $ --> Str) { … }

#| Retrieve the parsed contents from a Pod object. This is a helper method to
#| traverse Pod6 objects.
method traverse (Any:D $pod --> Str) {
	$pod.contents.map({ self.render($_) }).join.trim
}

#| Unpod a Pod element, turning it into plain ol' text instead.
method unpod (Any:D $pod --> Str) {
	$pod.contents.map(*.contents).join(' ')
}

=begin pod

=NAME    Pod::To::Anything::Abstract
=AUTHOR  Patrick Spek <p.spek@tyil.work>
=VERSION 0.1.0

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 EXAMPLES

=head1 SEE ALSO

=end pod

# vim: ft=perl6 noet
