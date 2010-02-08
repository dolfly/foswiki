#!perl -T

use Test::More tests => 3;
use Digest::MD5;

unless ( $ENV{RELEASE_TESTING} ) {
    #TODO: provide a foswiki that these tests can be run against - or write it to be 'ok' with it going away.
    plan( skip_all => "Author tests not required for installation" );
}

use WWW::Mechanize::Foswiki;


my $mech = WWW::Mechanize::Foswiki->new( agent => 'WWW::Mechanize::Foswiki', autocheck => 1 );
isa_ok($mech, 'WWW::Mechanize::Foswiki');

my $host = 'http://trunk.foswiki.org/bin';
is($mech->cgibin($host , { scriptSuffix => '' } ), $host);

# (optional) establish credentials --- do this *after* setting cgibin
# $mech->credentials( undef, undef, USERNAME => PASSWORD );

#template auth - build into credentials() - so it detects apache&template(and don't forget the 

#TODO: get server and credentials from the BuildContrib user cache file in the user's HOMEDIR..
my $username = $ENV{FOSWIKI_USER};
my $password = $ENV{FOSWIKI_PASSWORD};

$mech->login( 'System.WebHome' );
$mech->form_name('loginform');
$mech->set_fields(  username => $username, 
                    password => $password, 
                    validation_key => _strikeone(undef, $mech)
                 );
$mech->click_button(value => 'Logon');

# get a list of topics in the _default web (typically somewhere around 11 topics)
my @topics = $mech->getPageList( '_default' );
print STDERR "-- ".join(',',@topics)."\n";
ok($#topics>0,  'got some topics');

###### from BuildContrib
sub _strikeone {
    my ( $this, $mech ) = @_;
    
    my $validationKey = $mech->value('validation_key');
    if (not defined $validationKey) {
        warn "WARNING: The form does not have a validation_key field\n";
        return '';
    }

    my $cookie;
    $mech->cookie_jar()->scan(sub {
        my ($version, $key, $value) = @_;
        $cookie = $value if $key eq 'FOSWIKISTRIKEONE';
    });
    if (not defined $cookie) {
        warn "WARNING: Could not find strikeone cookie in cookiejar - disabling strikeone\n";
        return $validationKey;
    }
    $validationKey =~ s/^\?//;

    return Digest::MD5::md5_hex( $validationKey.$cookie );
}
