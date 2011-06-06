# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# HyphenatorContrib is Copyright (C) 2011 Michael Daum http://michaeldaumconsulting.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Contrib::HyphenatorContrib;

use strict;
use warnings;

our $VERSION = '$Rev$';
our $RELEASE = '1.00';
our $SHORTDESCRIPTION = 'Automatically hyphenates text';
our $NO_PREFS_IN_TOPIC = 1;

sub init {
  require Foswiki::Plugins::JQueryPlugin ();
  Foswiki::Plugins::JQueryPlugin::registerPlugin("Hyphenator", "Foswiki::Contrib::HyphenatorContrib::Core");
}

1;
