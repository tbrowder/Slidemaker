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
    =slide
    =title Why Linux?
    =subtitle Introduction
    =author Joey Marshal
    =date 2024-05-10
    =item It's good for you.
    =item It's fun, too!
    =slide
    =title2 Why Linux?
    =subtitle
    =subtitle That's all folks!
    =end pod

Currently, the input document satisfies a basic need for a quick, text-based briefing presentation. It can provide:

  * Letter or A4 paper in landscape orientation

  * text

  * images

  * links

  * colored borders

  * colored text boxes (or frames)

  * a default theme

  * a YAML configuration file for a theme

An example theme configuration:

Run `$?` to download the example file from './resources'.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2024 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

Note the code used from module Pod::To:Anything is licensed under the AGP License, version 3.0. See its wording and how it is to be applied at [](https://).

