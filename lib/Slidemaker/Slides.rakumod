use Pod::To::Anything;
use Pod::To::Anything::Subsets;

unit class Slides does Pod::To::Anything;

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
