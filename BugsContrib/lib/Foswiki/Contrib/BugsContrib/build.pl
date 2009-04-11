#!/usr/bin/perl -w
#
# Build file
#
package BugsContribBuild;

BEGIN {
    foreach my $pc (split(/:/, $ENV{FOSWIKI_LIBS})) {
        unshift @INC, $pc;
    }
}

use System::Contrib::Build;

@BugsContribBuild::ISA = ( "System::Contrib::Build" );

sub new {
    my $class = shift;
    return bless( $class->SUPER::new( "BugsContrib" ), $class );
}

$build = new BugsContribBuild();
$build->build($build->{target});
