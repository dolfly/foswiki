#! /usr/bin/perl -w
use strict;
use Data::Dumper qw( Dumper );
$|++;

use Storable;

my $opts = {
    progress => 1,
};

my @m = glob( '2???-??' );
#warn Dumper( \@m );

foreach my $m ( @m ) {
    warn "m=[$m]\n" if $opts->{progress};

    my %extensions = %{ retrieve( $m ) };

    open( CSV, '>', "$m.csv" ) or die $!;
    #print Dumper( \%extensions );
    foreach my $ext_key ( sort { lc $a cmp lc $b } keys %extensions ) {
	my $ext = $extensions{ $ext_key };
	#print Dumper( $ext );
	$ext->{zip} ||= '';
	$ext->{tgz} ||= '';
	my $total = ( $ext->{zip} || 0 ) + ( $ext->{tgz} || 0 );
	print CSV join( ',', $ext_key, $total, $ext->{tgz}, $ext->{zip} ) . "\n";
    }
    close CSV;

}

