#! /usr/bin/env false

use v6.d;

use Pod::To::Anything;
use Pod::To::Anything::Subsets;
use HTML::Escape;

unit class Pod::To::HTML::Section does Pod::To::Anything;

my $no-para;
my @authors;
my $title;
my $version;
my @notes;

multi method render (Pod::Block::Code:D $code --> Str) {
	"<pre>{$code.contents.join('').trim.&escape-html}</pre>"
}

multi method render (Pod::Block::Declarator:D $declarator --> Str) {
	self.traverse($declarator)
}

multi method render (Pod::Block::Named::Author:D $author --> Str) {
	ENTER { $no-para++ }
	LEAVE { $no-para-- }

	@authors.append: self.traverse($author);

	''
}

multi method render (Pod::Block::Named::Name:D $t --> Str) {
	ENTER { $no-para++ }
	LEAVE { $no-para-- }

	$title = self.traverse($t);

	''
}

multi method render (Pod::Block::Named::Subtitle:D $subtitle --> Str) {
	self.traverse($subtitle)
}

multi method render (Pod::Block::Named::Title:D $t --> Str) {
	ENTER { $no-para++ }
	LEAVE { $no-para-- }

	$title = self.traverse($t);

	''
}

multi method render (Pod::Block::Named::Version:D $v --> Str) {
	ENTER { $no-para++ }
	LEAVE { $no-para-- }

	$version = self.traverse($v);

	''
}

multi method render (Pod::Block::Named::Pod:D $document --> Str) {
	# Reset all state, or counters will go wrong. It seems pod rendering classes
	# are invoked statically, so I can't use standard object fields.
	$no-para = 0;
	@authors = ();
	$title = 'Unnamed Module';
	$version = '*';
	@notes = ();

	# Traverse the document, which will walk through all the elements.
	my $body = self.traverse($document);

	# Create the HTML section to output
	my $section = '<section id="pod">'
		~ "<h1>$title <small>{$version}</small></h1>"
		~ $body
		~ '<h2>Authors</h2>'
		~ "<ul>{@authors.map({ "<li>{$_}</li>" })}</ul>"
		;

	if (@notes) {
		$section ~= '<hr>';

		for @notes.kv -> $index, $note {
			$section ~= "<p><small>[<a id=\"notes-{$index + 1}\">{$index + 1}</a>]: {$note}</small></p>";
		}
	}

	# And output it.
	$section ~ '</section>'
}

multi method render (Pod::Block::Para:D $paragraph --> Str) {
	return self.traverse($paragraph) if $no-para;

	"<p>{self.traverse($paragraph)}</p>"
}

multi method render (Pod::Block::Table:D $table --> Str) {
	self.traverse($table)
}

multi method render (Pod::FormattingCode::B:D $prose --> Str) {
	"<strong>{self.traverse($prose)}</strong>"
}

multi method render (Pod::FormattingCode::C:D $code --> Str) {
	"<code>{self.traverse($code)}</code>"
}

multi method render (Pod::FormattingCode::E:D $prose --> Str) {
	"&{self.traverse($prose)};"
}

multi method render (Pod::FormattingCode::I:D $prose --> Str) {
	"<em>{self.traverse($prose)}</em>"
}

multi method render (Pod::FormattingCode::K:D $prose --> Str) {
	"<code>{self.traverse($prose)}</code>"
}

multi method render (Pod::FormattingCode::L:D $link --> Str) {
	"<a href=\"{$link.meta.first}\">{self.traverse($link)}</a>"
}

multi method render (Pod::FormattingCode::N:D $prose --> Str) {
	@notes.append: self.traverse($prose);
	my $index = @notes.elems;

	"<sup>[<a href=\"#notes-{$index}\">{$index}</a>]</sup>"
}

multi method render (Pod::FormattingCode::P:D $prose --> Str) {
	self.traverse($prose)
}

multi method render (Pod::FormattingCode::R:D $prose --> Str) {
	"<em>{self.traverse($prose)}</em>"
}

multi method render (Pod::FormattingCode::T:D $prose --> Str) {
	"<code>{self.traverse($prose)}</code>"
}

multi method render (Pod::FormattingCode::U:D $prose --> Str) {
	"<u>{self.traverse($prose)}</u>"
}

multi method render (Pod::FormattingCode::V:D $prose --> Str) {
	self.unpod($prose)
}

multi method render (Pod::FormattingCode::X:D $prose --> Str) {
	self.traverse($prose)
}

multi method render (Pod::Heading:D $heading --> Str) {
	ENTER { $no-para++ }
	LEAVE { $no-para-- }

	"<h{$heading.level + 1}>{self.traverse($heading)}</h{$heading.level + 1}>"
}

multi method render (Pod::Item:D $item --> Str) {
	"<ul><li>{self.traverse($item)}</li></ul>"
}

multi method render (Str:D $prose --> Str) {
	$prose.&escape-html
}

=begin pod

=NAME    Pod::To::HTML
=AUTHOR  Patrick Spek <p.spek@tyil.work>
=VERSION 0.1.0

=head1 Synopsis

=head1 Description

=head1 Examples

=head1 See also

=end pod

# vim: ft=perl6 noet
