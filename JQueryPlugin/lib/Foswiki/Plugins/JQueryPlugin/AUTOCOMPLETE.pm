# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
# 
# Copyright (C) 2006-2010 Michael Daum, http://michaeldaumconsulting.com
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

package Foswiki::Plugins::JQueryPlugin::AUTOCOMPLETE;
use strict;
use base 'Foswiki::Plugins::JQueryPlugin::Plugin';

=begin TML

---+ pacakage Foswiki::Plugins::JQueryPlugin::AUTOCOMPLETE

Autocomplete - jQuery plugin 1.1pre

=cut

=begin TML

---++ ClassMethod new( $class, $session, ... )

Constructor

=cut

sub new {
  my $class = shift;
  my $session = shift || $Foswiki::Plugins::SESSION;

  my $this = bless($class->SUPER::new( 
    $session,
    name => 'Autocomplete',
    version => '1.1pre',
    author => 'Dylan Verheul, Dan G. Switzer, Anjesh Tuladhar, Joern Zaefferer',
    homepage => 'http://bassistance.de/jquery-plugins/jquery-plugin-autocomplete/',
    css => ['jquery.autocomplete.css'],
    javascript => ['jquery.autocomplete.js', 'jquery.autocomplete.init.js'],
  ), $class);

  return $this;
}

1;
