# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2006-2008 Michael Daum http://michaeldaumconsulting.com
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

package Foswiki::Plugins::BreadCrumbsPlugin;

use strict;

our $VERSION = '$Rev$';
our $RELEASE = 'v2.42';
our $NO_PREFS_IN_TOPIC = 1;
our $SHORTDESCRIPTION = 'A flexible way to display breadcrumbs navigation';
our $doneInit = 0;

###############################################################################
sub initPlugin {

  Foswiki::Func::registerTagHandler('BREADCRUMBS', \&renderBreadCrumbs);

  my $doRecordTrail = Foswiki::Func::getPreferencesValue('BREADCRUMBSPLUGIN_RECORDTRAIL') || '';
  $doRecordTrail = ($doRecordTrail eq 'on')?1:0;

  if ($doRecordTrail) {
    init();
    Foswiki::Plugins::BreadCrumbsPlugin::Core::recordTrail($_[1], $_[0]);
  } else {
    #print STDERR "not recording the click path trail\n";
  }

  return 1;
}

###############################################################################
sub init {
  return if $doneInit;
  $doneInit = 1;
  require Foswiki::Plugins::BreadCrumbsPlugin::Core;
  Foswiki::Plugins::BreadCrumbsPlugin::Core::init(@_);
}

###############################################################################
sub renderBreadCrumbs {
  init();
  return Foswiki::Plugins::BreadCrumbsPlugin::Core::renderBreadCrumbs(@_);
}

1;
