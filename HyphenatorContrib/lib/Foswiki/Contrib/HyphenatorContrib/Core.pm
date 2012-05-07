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

package Foswiki::Contrib::HyphenatorContrib::Core;

use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin::Plugin ();
our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

=begin TML

---+ package Foswiki::Contrib::HyphenatorContrib::Core

This is the perl stub for the hyphenator plugin.

=cut

sub new {
  my $class = shift;
  my $session = shift || $Foswiki::Plugins::SESSION;
 
  my $this = bless(
    $class->SUPER::new(
      $session,
      name => 'Hyphenator',
      version => '4.0.0',
      author => 'Mathias Nater',
      homepage => 'http://code.google.com/p/hyphenator/',
      javascript => ['hyphenator.js', 'hyphenator.init.js'],
      puburl => '%PUBURLPATH%/%SYSTEMWEB%/HyphenatorContrib',
    ),
    $class
  );

  return $this;
}

1;
