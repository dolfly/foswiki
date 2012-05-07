# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# (c) 2008 SvenDowideit@fosiki.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
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
$RELEASE = '24 Oct 2009';
$SHORTDESCRIPTION = 'FirebugLite javascript based debugger for IE, Opera, Safari and FireFox';
$NO_PREFS_IN_TOPIC = 1;
$pluginName = 'FirebugLitePlugin';


sub initPlugin {
    # Plugin should really be a Contrib :-)

    return 1;
}



1;
