package Foswiki::Contrib::JQGanttContrib;

use strict;
use warnings;

our $VERSION = '$Rev$';
our $RELEASE = '52f46db';
our $SHORTDESCRIPTION = 'A simple gantt chart widget';
our $NO_PREFS_IN_TOPIC = 1;

sub init {
  require Foswiki::Plugins::JQueryPlugin ();
  Foswiki::Plugins::JQueryPlugin::registerPlugin("gantt", "Foswiki::Contrib::JQGanttContrib::Core");
}

1;
