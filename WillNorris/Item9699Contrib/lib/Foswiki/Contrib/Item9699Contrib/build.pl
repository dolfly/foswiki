#!/usr/bin/perl -w
BEGIN { unshift @INC, split( /:/, $ENV{FOSWIKI_LIBS} ); }
use Foswiki::Contrib::Build;

# Create the build object
$build = new Foswiki::Contrib::Build('Item9699Contrib');

# (Optional) Set the details of the repository for uploads.
# This can be any web on any accessible Foswiki installation.
# These defaults will be used when expanding tokens in .txt
# files, but be warned, they can be overridden at upload time!

$build->{UPLOADTARGETWEB} = 'Extensions/Testing';
#$build->{UPLOADTARGETPUB} = 'http://foswiki.org/pub';
#$build->{UPLOADTARGETSCRIPT} = 'http://foswiki.org/bin';
#$build->{UPLOADTARGETSUFFIX} = '';

# Build the target on the command line, or the default target
$build->build($build->{target});

