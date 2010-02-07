#!perl -T

use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use Test::CheckManifest 0.9";
plan skip_all => "Test::CheckManifest 0.9 required" if $@;
#TODO: learn why this is not in ignore.txt, and how it should be done.
ok_manifest(
    #{filter => [qr/(\.svn|inc|ignore.txt)/]}
);
