[![Actions Status](https://github.com/tbrowder/Slidemaker/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Slidemaker/actions) [![Actions Status](https://github.com/tbrowder/Slidemaker/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Slidemaker/actions) [![Actions Status](https://github.com/tbrowder/Slidemaker/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Slidemaker/actions)

NAME
====

**Slidemaker** - Provides classes and routines for generating PDF slides from Rakudoc input.

SYNOPSIS
========

```raku
use Slidemaker;
$ create-slides <rakudoc file>
$ See file 'MyBriefing.pdf'
```

DESCRIPTION
===========

**Slidemaker** provides a system to create a PDF slide deck from a Rakudoc description. Following is a short example of such a description:

    =begin pod
    =comment configuration lasts until next configuration block (if any)
    =comment see details for defaults and recognized key/value pairs
    =for configuration :paper<letter> :title-bar-color<blue> :title-bar-height<1>
    = :dimensions<in>
    = :font<serif> :title-font-size<> :subtitle-font-size<> :font-size<>
    = :margins<1> 
    =comment a '=slide' and its title start a new slide
    =slide Why Linux?
    =subtitle Introduction to the Windows/Mac alternative
    =author Joey Marshal
    =date 2024-05-10
    =item It's good for you.
    =item It's fun, too!
    =slide Why Linux?
    =subtitle That's all folks!
    =comment document definition is complete
    =end pod

Currently, the input document satisfies a basic need for a quick, text-based briefing presentation. It can provide:

  * Letter or A4 paper in landscape orientation

  * text

  * images

  * links

  * colored borders

  * colored text boxes (or frames)

Run `$ create-slides eg` to download the example file from './resources'.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2024 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

