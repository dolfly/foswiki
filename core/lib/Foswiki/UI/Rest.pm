# See bottom of file for license and copyright information

=begin TML

---+ package Foswiki::UI::Rest

UI delegate for REST interface

=cut

package Foswiki::UI::Rest;

use strict;
use Foswiki ();
use Error qw( :try );

sub rest {
    my ( $session, %initialContext ) = @_;

    my $query = $session->{request};
    my $login = $query->param('username');
    my $pass  = $query->param('password');

    # Must define topic param in the query to avoid plugins being
    # passed the path_info when the are initialised. We can't affect
    # the path_info, but we *can* persuade Foswiki to ignore it.
    my $topic = $query->param('topic');
    if ($topic) {

        # SMELL: excess brackets in RE?
        unless ( $topic =~ /((?:.*[\.\/])+)(.*)/ ) {
            my $res = $session->{response};
            $res->header(
                -type   => 'text/html',
                -status => '400'
            );
            $res->print( "ERROR: (400) Invalid REST invocation"
                  . " - Invalid topic - no web specified\n" );
            throw Foswiki::EngineException( 400,
                'ERROR: (400) Invalid REST invocation', $res );
        }
    }
    else {

        # Point it somewhere innocent
        $session->{webName}   = $Foswiki::cfg{UsersWebName};
        $session->{topicName} = $Foswiki::cfg{HomeTopicName};
    }

    if ($login) {
        my $validation = $session->{users}->checkPassword( $login, $pass );
        unless ($validation) {
            my $res = $session->{response};
            $res->header(
                -type   => 'text/html',
                -status => '401'
            );
            $res->print("ERROR: (401) Can't login as $login");
            throw Foswiki::EngineException( 401,
                "ERROR: (401) Can't login as $login", $res );
        }

        my $cUID     = $session->{users}->getCanonicalUserID($login);
        my $WikiName = $session->{users}->getWikiName($cUID);
        $session->{users}->{loginManager}->userLoggedIn( $login, $WikiName );
    }

    try {
        $session->{users}->{loginManager}->checkAccess();
    }
    catch Error with {
        my $e   = shift;
        my $res = $session->{response};
        $res->header(
            -type   => 'text/html',
            -status => '401'
        );
        $res->print("ERROR: (401) $e");
        throw Foswiki::EngineException( 401, "ERROR: (401) $e", $res );
    };

    my $pathInfo = $query->path_info();

    # Foswiki rest invocations are defined as having a subject (pluginName)
    # and verb (restHandler in that plugin)
    unless ( $pathInfo =~ m#/(.*?)[./]([^/]*)# ) {

        my $res = $session->{response};
        $res->header(
            -type   => 'text/html',
            -status => '400'
        );
        $res->print("ERROR: (400) Invalid REST invocation");
        throw Foswiki::EngineException( 401,
            "ERROR: (400) Invalid REST invocation", $res );
    }

    # implicit untaint OK - validated below
    my ( $subject, $verb ) = ( $1, $2 );

    unless ( Foswiki::isValidWikiWord($subject) ) {
        my $res = $session->{response};
        $res->header(
            -type   => 'text/html',
            -status => '404'
        );
        $res->print("ERROR: (404) Invalid REST invocation ($subject)");
        throw Foswiki::EngineException( 401,
            "ERROR: (400) Invalid REST invocation ($subject)", $res );
    }

    my $function = $Foswiki::restDispatch{$subject}{$verb};
    unless ($function) {
        my $res = $session->{response};
        $res->header(
            -type   => 'text/html',
            -status => '404'
        );
        $res->print("ERROR: (404) Invalid REST invocation ($verb on $subject)");
        throw Foswiki::EngineException( 401,
            "ERROR: (400) Invalid REST invocation ($verb on $subject)", $res );
    }

    no strict 'refs';
    my $result = &$function( $session, $subject, $verb, $session->{response} );
    use strict 'refs';
    my $endPoint = $query->param('endPoint');
    if ( defined($endPoint) ) {
        my $nurl = $session->getScriptUrl( 1, 'view', '', $endPoint );
        $session->redirect($nurl);
    }
    else {
        $session->writeCompletePage($result) if $result;
    }
}

1;
__DATA__
# Module of Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2008-2009 Foswiki Contributors. Foswiki Contributors
# are listed in the AUTHORS file in the root of this distribution.
# NOTE: Please extend that file, not this notice.
#
# Additional copyrights apply to some or all of the code in this
# file as follows:
#
# Copyright (C) 1999-2007 Peter Thoeny, peter@thoeny.org
# and TWiki Contributors. All Rights Reserved. TWiki Contributors
# are listed in the AUTHORS file in the root of this distribution.
# Based on parts of Ward Cunninghams original Wiki and JosWiki.
# Copyright (C) 1998 Markus Peter - SPiN GmbH (warpi@spin.de)
# Some changes by Dave Harris (drh@bhresearch.co.uk) incorporated
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# As per the GPL, removal of this notice is prohibited.
