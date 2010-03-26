#! /usr/bin/perl -w
use strict;
use Data::Dumper qw( Dumper );
$|++;

use Storable;

my %extensions = %{ retrieve( '2009-01' ) };
#print Dumper( \%extensions );
foreach my $ext_key ( sort { lc $a cmp lc $b } keys %extensions ) {
    my $ext = $extensions{ $ext_key };
#    print Dumper( $ext );
    $ext->{zip} ||= '';
    $ext->{tgz} ||= '';
    my $total = ( $ext->{zip} || 0 ) + ( $ext->{tgz} || 0 );
    print join( ',', $ext_key, $total, $ext->{tgz}, $ext->{zip} ) . "\n";
}
