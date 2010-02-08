#!perl -T

use Test::More tests => 2;

unless ( $ENV{RELEASE_TESTING} and $ENV{FOSWIKI_USER} and $ENV{FOSWIKI_PASSWORD}) {
    #TODO: provide a foswiki that these tests can be run against - or write it to be 'ok' with it going away.
    plan( skip_all => "Author tests not required for installation, you also need a foswiki installed at http://localhost/trunk/bin, and $ENV{FOSWIKI_USER} and $ENV{FOSWIKI_PASSWORD} set." );
}

use WWW::Mechanize::Foswiki;

#TODO: get server and credentials from the BuildContrib user cache file in the user's HOMEDIR..
my $host = 'http://localhost/trunk/bin';
my $pub = 'http://localhost/trunk/pub';
my $username = $ENV{FOSWIKI_USER};
my $password = $ENV{FOSWIKI_PASSWORD};

my $mech = new WWW::Mechanize::Foswiki( 
            agent => 'WWW::Mechanize::Foswiki', 
            cgibin => $host,
            scriptSuffix => '',
            pub => $pub,
            username => $username,
            password => $password,
            autocheck => 1
            );
isa_ok($mech, 'WWW::Mechanize::Foswiki');

# get a list of topics in the _default web (typically somewhere around 11 topics)
my @topics = $mech->getPageList( '_default' );
print STDERR "-- ".join(',',@topics)."\n";
ok($#topics>0,  'got some topics');

