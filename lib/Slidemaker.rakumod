use Pod::To::Anything;
use Pod::To::Anything::Subsets;

use RakupodObject;

unit class Slidemaker does Pod::To::Anything;

has @!slides;
has $!pod-file;

# methods defined in role pos::To::Anything
=begin comment
#| Retrieve the parsed contents from a Pod object. This is a helper method to
#| traverse Pod6 objects.
method traverse (Any:D $pod --> Str) {
	$pod.contents.map({ self.render($_) }).join.trim
}
#| Unpod a Pod element, turning it into plain ol' text instead.
method unpod (Any:D $pod --> Str) {
	$pod.contents.map(*.contents).join(' ')
}
=end comment

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
