package Foswiki::Contrib::JQGanttContrib::Core;

use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin::Plugin ();
our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

sub new {
  my $class = shift;

  my $this = bless(
    $class->SUPER::new(
      name => 'Gantt',
      version => '363ae4dcc7efb409fed2ffb448c0538e9bcc7618',
      author => 'Marek Bielańczuk, Tait Brown, Leo Pfeifenberger',
      homepage => 'https://github.com/taitems/jQuery.Gantt',
      css => ['jquery.gantt.css'],
      javascript => ['jquery.gantt.js', 'jquery.gantt.init.js'],
      documentation => 'JQGanttContrib',
      puburl => '%PUBURLPATH%/%SYSTEMWEB%/JQGanttContrib',
      dependencies => ['metadata'],
    ),
    $class
  );

  return $this;
}

1;
