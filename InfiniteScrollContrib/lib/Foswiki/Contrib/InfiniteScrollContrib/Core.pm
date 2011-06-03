package Foswiki::Contrib::InfiniteScrollContrib::Core;

use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin::Plugin ();
our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

sub new {
  my $class = shift;
  my $session = shift || $Foswiki::Plugins::SESSION;

  my $this = bless(
    $class->SUPER::new(
      $session,
      name => 'InfiniteScroll',
      version => '2.0b1.110420',
      author => 'Paul Irish',
      homepage => 'http://www.infinite-scroll.com',
      javascript => ['jquery.infinitescroll.js', 'jquery.infinitescroll.init.js'], 
      #css => ['jquery.infinitescroll.css'],
      documentation => 'InfiniteScrollContrib',
      puburl => '%PUBURLPATH%/%SYSTEMWEB%/InfiniteScrollContrib',
    ),
    $class
  );

  return $this;
}

1;
