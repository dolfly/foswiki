#!/usr/bin/perl -w
#
use strict;

BEGIN {
    foreach my $pc (split(/:/, $ENV{FOSWIKI_LIBS})) {
        unshift @INC, $pc;
    }
}
use Foswiki::Contrib::Build;

my $build = new Foswiki::Contrib::Build( 'Foswiki_01x00x09_UpgradeContrib' );
$build->{UPLOADTARGETPUB} = 'http://www.biohack.net/wiki/pub';
$build->{UPLOADTARGETSCRIPT} = 'http://www.biohack.net/wiki/bin';
$build->build( $build->{target} );
