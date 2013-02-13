# See bottom of file for default license and copyright information

=begin TML

---+ package Foswiki::Plugins::HoneyPotPlugin

=cut

package Foswiki::Plugins::HoneyPotPlugin;

# Always use strict to enforce variable scoping
use strict;
use warnings;

use Foswiki::Func         ();
use Foswiki::Plugins      ();
use WWW::Honeypot::httpBL ();

use version; our $VERSION = version->declare("v1.0.0");
use Error ':try';

our $RELEASE = '2013-02-13';
our $SHORTDESCRIPTION =
'Use Project !HoneyPot to detect and filter operations initiated from suspected spammers, search engines etc.';
our $NO_PREFS_IN_TOPIC = 1;
our $honeypotChecked   = 0;

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;
    Foswiki::Func::registerRESTHandler( 'check', \&rest_check );

    # We have called all the handlers that are used in honeypot
    # checking. Reset the globvar for subsequent calls.
    $honeypotChecked = 0;
    return 1;
}

# This preload handler is only called in Foswiki 1.2.0 and later. Prior
# to that, the earlyInitHandler is the earliest we can do the honeypot
# check.
sub earlyInitPlugin {
    unless ($honeypotChecked) {
        preload($Foswiki::Plugins::SESSION);
    }
    return 0;
}

# preload handler, called way before anything exciting happens
sub preload {
    my ($session) = @_;

    # get the request
    my $request = $session->{request};
    if ( $request->can('remote_addr') ) {
        my $ipad   = $request->remote_addr();
        my $action = $request->action();
        my $conditions =
          $Foswiki::cfg{Plugins}{HoneyPotPlugin}{Conditions}{$action};
        if ($conditions) {
            my $status = check( $ipad, $conditions );
            if ($status) {

                # Can't use Foswiki logs because they may not be set up yet
                # So use the web server log instead.
                my $mess =
                  "Foswiki: HoneyPot rejected '$action' from $ipad: $status";
                print STDERR $mess;
                throw Foswiki::EngineException( 403, $mess );
            }
        }
    }
    $honeypotChecked = 1;
}

=begin TML

---++ StaticMethod check($domain, $tests) -> $result

   * =$domain= - domain name or IP address to check
   * =$tests= - either an array of predicate names or a comma-separated
     string list of predicates to perform e.g.
     'is_comment_spammer,is_search_engine'

Check Project Honeypot for the given domain (or IP address string).
If it's OK, return '', otherwise return the name of the check that
failed.

Note that if the domain name can't be resolved to a valid IP address,
then the honeypot will *not* reject it.

=cut

sub check {
    my ( $domain, $hp_rej ) = @_;
    my $hp_key = $Foswiki::cfg{Plugins}{HoneyPotPlugin}{APIKey};
    return '' unless ( $hp_key && $hp_rej );
    unless ( ref($hp_rej) ) {
        $hp_rej = [ split( /[,\s]+/, $hp_rej ) ];
    }
    return '' unless ( $hp_rej && scalar(@$hp_rej) );

    my $ipad;
    if ( $domain =~ /^\d+\.\d+\.\d+\.\d+$/ ) {

        # Already an IP address
        $ipad = $domain;
    }
    else {

        # Get IP address
        my $packed_ip = gethostbyname($domain);
        $ipad = $packed_ip ? Socket::inet_ntoa($packed_ip) : undef;
    }

    # No IP address to check
    return '' unless $ipad;

    return '' if $ipad eq '127.0.0.1';

    my $honeypot = WWW::Honeypot::httpBL->new( { access_key => $hp_key } );
    $honeypot->fetch($ipad);
    foreach my $criterium (@$hp_rej) {

        # is_harvester is_comment_spammer is_search_engine is_suspicious
        if ( $honeypot->can($criterium) && $honeypot->$criterium() ) {
            return $criterium;    # reject!
        }
    }
    return '';
}

sub rest_check {
    my ( $session, $subject, $verb, $response ) = @_;
    my $query = Foswiki::Func::getCgiQuery();
    unless ($query) {
        print CGI::header( -status => 500 );
        return undef;
    }
    my $ip     = $query->param('ip');
    my $tests  = $query->param('tests');
    my $result = '';
    if ( $ip && $tests ) {
        $result = check( $ip, $tests );
    }
    my $status = $result ? 403 : 200;
    $response->header(
        -status  => $status,
        -type    => 'text/plain',
        -charset => 'UTF-8'
    );
    $response->body($result);
    return undef;
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: CrawfordCurrie

Copyright (C) 2013 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
