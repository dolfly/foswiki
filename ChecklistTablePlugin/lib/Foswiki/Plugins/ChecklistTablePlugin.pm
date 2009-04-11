# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2000-2003 Andrea Sterbini, a.sterbini@flashnet.it
# Copyright (C) 2001-2006 Peter Thoeny, peter@thoeny.org
# Copyright (C) 2007-2008 Daniel Rohde
# and TWiki and Foswiki Contributors. All Rights Reserved. TWiki and Foswiki
# Contributors are listed in the AUTHORS file in the root of this distribution.
# NOTE: Please extend that file, not this notice.
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
# For licensing info read LICENSE file in the Foswiki root.

# change the package name and $pluginName!!!
package Foswiki::Plugins::ChecklistTablePlugin;

use strict;

use vars qw( $VERSION $RELEASE $debug $pluginName %FoswikiCompatibility );

$FoswikiCompatibility{endRenderingHandler} = 1.1;


$VERSION = '$Rev$';
$RELEASE = 'v1.005'; # Kenneth Lavrsen changed extension to Foswiki namespace
#$RELEASE = 'v1.004'; # dro - added initsort and initdirection feature; fixed numeric eq error; fixed missing default value rendering of 'date' format type;
#$RELEASE = 'v1.003'; # dro - added quick insert feature; added new attributes (quickadd, quickinsert, buttonpos); fixed typos; fixed whitespaces in format bug; fixed (forced) link in text(area) bug; 
#$RELEASE = 'v1.002'; # dro - fixed major pre/verbatim bug; fixed and added documenation; added sort feature; added changerows attribute; added EDITCELL feature; fixed Opera bug; fixed topic lock bug
#$RELEASE = 'v1.001'; # dro - initial version

$pluginName = 'ChecklistTablePlugin';

require Foswiki::Plugins::ChecklistTablePlugin::Core;

sub initPlugin {
    my( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if( $Foswiki::Plugins::VERSION < 1.021 ) {
        Foswiki::Func::writeWarning( "Version mismatch between $pluginName and Plugins.pm" );
        return 0;
    }
    # Plugin correctly initialized
    return 1;
}

sub beforeCommonTagsHandler {
    # do not uncomment, use $_[0], $_[1]... instead
    ### my ( $text, $topic, $web ) = @_;

    Foswiki::Func::writeDebug( "- ${pluginName}::beforeCommonTagsHandler( $_[2].$_[1] )" ) if $debug;

    Foswiki::Plugins::ChecklistTablePlugin::Core::handle(@_) if $_[0]=~/\%CHECKLISTTABLE({.*?})?%/;

}

sub postRenderingHandler {
    # do not uncomment, use $_[0], $_[1]... instead
    #my $text = shift;
    #
    #
    eval {
        require Foswiki::Contrib::JSCalendarContrib;
        unless( $@ ) {
            Foswiki::Contrib::JSCalendarContrib::addHEAD( 'foswiki' );
        }
    };
    my $jsscripturl = Foswiki::Func::getPubUrlPath() .
                    '/' . $Foswiki::cfg{SystemWebName} . 
                    '/' . $pluginName . '/cltpinsertform.js';

    $_[0]=~s/<\/head>/<script src="$jsscripturl" language="javascript" type="text\/javascript"><\/script><\/head>/is unless ($_[0]=~/cltpinsertform.js/);

    Foswiki::Plugins::ChecklistTablePlugin::Core::handlePost(@_);
}
sub endRenderingHandler {
    # do not uncomment, use $_[0], $_[1]... instead
    #my $text = shift;
    #
    return postRenderingHandler(@_);
}


1;
