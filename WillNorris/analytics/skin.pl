#! /usr/bin/perl -w
use strict;
use Data::Dumper qw( Dumper );

my @skins = qw( Skin PatternSkin FoswikiSiteSkin NatSkin NatSkinPlugin WidgetsSkin MoveableTypeSkin NuSkin SoftSkin QuickMenuSkin );

my @m = ();

@m = ( @m, map { "2009-$_" } qw( 01 02 03 04 05 06 07 08 09 10 11 12 ) );
@m = ( @m, map { "2010-$_" } qw( 01 02 ) );
@m = reverse @m;

#warn Dumper( \@m );

foreach my $m ( @m ) {
    foreach my $skin ( @skins ) {

	chomp( my $wc = `grep -E '$skin.(tgz|zip)' access_log.$m-* | grep 'GET ' | wc -l` );
	warn "m=[$m] skin=[$skin] = wc=[$wc]\n";

#    last;
    }
    print "\n";
#    last;
}


