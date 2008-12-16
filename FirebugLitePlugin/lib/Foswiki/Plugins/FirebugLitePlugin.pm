# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# (c) 2008 SvenDowideit@fosiki.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::FirebugLitePlugin;

# Always use strict to enforce variable scoping
use strict;

require Foswiki::Func;    # The plugins API
require Foswiki::Plugins; # For the API version

use vars qw( $VERSION $RELEASE $SHORTDESCRIPTION $debug $pluginName $NO_PREFS_IN_TOPIC );
$VERSION = '$Rev$';
$RELEASE = 'Foswiki-1.0';
$SHORTDESCRIPTION = 'FirebugLite javascript based debugger for IE, Opera, Safari and FireFox';
$NO_PREFS_IN_TOPIC = 1;
$pluginName = 'FirebugLitePlugin';


sub initPlugin {
    my( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if( $Foswiki::Plugins::VERSION < 1.026 ) {
        Foswiki::Func::writeWarning( "Version mismatch between $pluginName and Plugins.pm" );
        return 0;
    }

    my $setting = $Foswiki::cfg{Plugins}{FirebugLitePlugin}{ExampleSetting} || 0;
    $debug = $Foswiki::cfg{Plugins}{FirebugLitePlugin}{Debug} || 0;

    Foswiki::Func::loadTemplate(lc($pluginName));
    my $firebugHeader = Foswiki::Func::expandTemplate($debug?'firebug':'firebug-compressed');
    Foswiki::Func::addToHEAD($pluginName, $firebugHeader);

    # Plugin correctly initialized
    return 1;
}



1;
