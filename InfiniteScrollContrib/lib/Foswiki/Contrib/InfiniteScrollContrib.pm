package Foswiki::Contrib::InfiniteScrollContrib;

use strict;
use warnings;

our $VERSION = '1.13';
our $RELEASE = '1.13';
our $SHORTDESCRIPTION = 'Infinite scrolling layouts';
our $NO_PREFS_IN_TOPIC = 1;

sub init {
  require Foswiki::Plugins::JQueryPlugin;
  Foswiki::Plugins::JQueryPlugin::registerPlugin("InfiniteScroll", "Foswiki::Contrib::InfiniteScrollContrib::Core");
}

1;
