#! /usr/bin/perl -w
use strict;
use Data::Dumper qw( Dumper );
use Storable qw( nstore );

my $opts = {
    progress => 1,
};

my @m = ();

@m = ( @m, map { "2009-$_" } qw( 01 02 03 04 05 06 07 08 09 10 11 12 ) );
@m = ( @m, map { "2010-$_" } qw( 01 02 ) );
@m = reverse @m;

#warn Dumper( \@m );

foreach my $m ( @m ) {
    print "$m\n" if $opts->{progress};

    my %extensions;

    chomp( my @matches = `grep -E 'GET .*/Extensions/.*\.(tgz|zip) ' access_log.$m-*` );
#    warn Dumper( \@matches );
    # access_log.2010-02-23:80.153.229.139 - - [23/Feb/2010:15:32:22 +0000] "GET /pub/Extensions/ExplicitNumberingPlugin/ExplicitNumberingPlugin.tgz HTTP/1.1" 200 13906 "-" "Foswiki::Net/6075 libwww-perl/5.805"
    # 200.116.205.238 - - [25/Feb/2010:05:05:32 +0000] "GET /Extensions/TagsPlugin HTTP/1.1" 200 8493 "http://ext.hexasas.com/comunidad/bin/configure.pl?action=FindMoreExtensions" "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100214 Ubuntu/9.10 (karmic) Firefox/3.5.8"
    foreach my $line ( @matches ) {
	$line =~ m{GET .*/Extensions/(.+)/(.+?)\.(zip|tgz)};
	my ( $dir, $name, $ext ) = ( $1, $2, $3 );
#	warn "dir=[$dir] name=[$name]\n" and next unless $dir eq $name;
	next unless $ext;	# and $dir and $name
	++$extensions{ $name }->{ $ext };
#	last;
    }

#    print "\n" if $opts->{progress};
    nstore( \%extensions, "analytics/$m" );

    print Dumper( \%extensions ) if $opts->{debug};
#    last;
}
