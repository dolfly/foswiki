# See bottom of file for default license and copyright information

=begin TML

---+ package Foswiki::Plugins::IpToUserMappingPlugin

=cut

package Foswiki::Plugins::IpToUserMappingPlugin;
use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

# $VERSION is referred to by Foswiki, and is the only global variable that
# *must* exist in this package.  Use "v1.2.3" format for releases,  and
# "v1.2.3_001" for "alpha" versions. The v prefix is required.
# These statements MUST be on the same line.
# See "perldoc version" for more information on version strings.
#
# Note:  Alpha versions compare as numerically lower than the non-alpha version
# so the versions in ascending order are:
#   v1.2.1_001 -> v1.2.1 -> v1.2.2_001 -> v1.2.2
#
use version; our $VERSION = version->declare("v1.0.0_001");
our $RELEASE           = '30 May 2013';
our $SHORTDESCRIPTION  = 'authenticate users by IP address';
our $NO_PREFS_IN_TOPIC = 1;

=begin TML

---++ initPlugin($topic, $web, $user) -> $boolean
   * =$topic= - the name of the topic in the current CGI query
   * =$web= - the name of the web in the current CGI query
   * =$user= - the login name of the user
   * =$installWeb= - the name of the web the plugin topic is in
     (usually the same as =$Foswiki::cfg{SystemWebName}=)

=cut

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    return 1;
}

sub initializeUserHandler {
    my ( $loginName, $url, $pathInfo ) = @_;

    if (
        exists $Foswiki::cfg{IpToUserMappingPlugin}{Mapping}
        { $ENV{REMOTE_ADDR} } )
    {
        $Foswiki::Plugins::SESSION->enterContext('authenticated');

        #my @keys = keys( $Foswiki::cfg{IpToUserMappingPlugin}{Mapping} );
        #my $IP   = $keys[0];
        my $user =
          $Foswiki::cfg{IpToUserMappingPlugin}{Mapping}{ $ENV{REMOTE_ADDR} };
        my $login = $user->{login};

        #don't add the user to the basemapping if its already existing.
        if ( !defined $Foswiki::Plugins::SESSION->{users}
            ->getCanonicalUserID($login) )
        {
            my $cuid = $user->{cuid} || $login;

            $Foswiki::Users::BaseUserMapping::BASE_USERS{$cuid} = $user;
            my $k = $cuid;
            my $v = $Foswiki::Users::BaseUserMapping::BASE_USERS{$k};

            $Foswiki::Plugins::SESSION->{users}->{basemapping}->{U2L}->{$k} =
              $v->{login};
            $Foswiki::Plugins::SESSION->{users}->{basemapping}->{U2W}->{$k} =
              $v->{wikiname};
            $Foswiki::Plugins::SESSION->{users}->{basemapping}->{U2E}->{$k} =
              $v->{email}
              if defined $v->{email};

            $Foswiki::Plugins::SESSION->{users}->{basemapping}->{L2U}
              ->{ $v->{login} } = $k;
            $Foswiki::Plugins::SESSION->{users}->{basemapping}->{L2P}
              ->{ $v->{login} } = $v->{password}
              if defined $v->{password};

            $Foswiki::Plugins::SESSION->{users}->{basemapping}->{W2U}
              ->{ $v->{wikiname} } = $k;
        }

        return $login;
    }
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) SvenDowideit@fosiki.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 3
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
