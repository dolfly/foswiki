# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# OEmbedPlugin is Copyright (C) 2013 Michael Daum http://michaeldaumconsulting.com
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

package Foswiki::Plugins::OEmbedPlugin;

use strict;
use warnings;

use Foswiki::Func ();

our $VERSION = '2.20';
our $RELEASE = '2.20';
our $SHORTDESCRIPTION = 'Easy embedding of third party content';
our $NO_PREFS_IN_TOPIC = 1;
our $core;

sub core {

  unless (defined $core) {
    require Foswiki::Plugins::OEmbedPlugin::Core;
    $core = new Foswiki::Plugins::OEmbedPlugin::Core();
  }

  return $core;
}


sub initPlugin {

  core->init;

  Foswiki::Func::registerTagHandler('EMBED', sub { return core->EMBED(@_); });

  return 1;
}


1;
