

unless ( $ENV{RELEASE_TESTING} ) {
    #TODO: provide a foswiki that these tests can be run against - or write it to be 'ok' with it going away.
    plan( skip_all => "Author tests not required for installation" );
}

use WWW::Mechanize::Foswiki;

#TODO: get server and credentials from the BuildContrib user cache file in the user's HOMEDIR..

my $mech = WWW::Mechanize::Foswiki->new( agent => 'WWW::Mechanize::Foswiki', autocheck => 1 );
$mech->cgibin( 'http://foswiki.org/bin', { scriptSuffix => '' } );

# (optional) establish credentials --- do this *after* setting cgibin
# $mech->credentials( undef, undef, USERNAME => PASSWORD );

# get a list of topics in the _default web (typically somewhere around 11 topics)
my @topics = $mech->getPageList( '_default' );
print STDERR "---\n".join(',', @topics);