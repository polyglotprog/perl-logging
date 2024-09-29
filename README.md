# Perl Logging

A simple logging implementation for [Perl].

## Requirements

- [Perl] v5.38[^1]
- [Dist::Zilla]

This project uses [Dist::Zilla] for builds. To install it, run:

```console
$ sudo cpan Dist::Zilla::Plugin::PerlTidy
```

[^1]: This project was developed using Perl v5.38 but may still work with
  earlier versions of Perl &mdash; with some adjustments.

## Building

Clone the project and install required modules:

```console
$ git clone git@github.com:polyglotprog/perl-logging.git
$ cd perl-logging
```

To build:

```console
$ dzil build
```

To test:

```console
$ dzil test
```

To format with [perltidy]:

```console
$ dzil perltidy
```

<!------------------------------------------------------------------------------
  Links
------------------------------------------------------------------------------->
[Dist::Zilla]: https://dzil.org
[Perl]: https://www.perl.org
[perltidy]: http://perltidy.sourceforge.net
