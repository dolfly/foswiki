# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# GoogleMapsPlugin is Copyright (C) 2013 Michael Daum http://michaeldaumconsulting.com
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

package Foswiki::Plugins::GoogleMapsPlugin::Core;

use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin::Plugins ();
use Foswiki::Plugins::JQueryPlugin::Plugin ();
use Foswiki::Plugins ();
use JSON ();

our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

sub new {
  my $class = shift;

  my $this = bless(
    $class->SUPER::new(
      name => 'Tweet',
      version => '5.0b',
      author => 'Jean-Baptiste Demonte',
      homepage => 'http://gmap3.net',
      javascript => ['gmap3.js'],
      documentation => 'GoogleMapsPlugin',
      puburl => '%PUBURLPATH%/%SYSTEMWEB%/GoogleMapsPlugin',
      dependencies => ['GOOGLEMAPSAPI'],
    ),
    $class
  );

  return $this;
}

sub init {
  my $this = shift;

  return unless $this->SUPER::init();

  my $session = $Foswiki::Plugins::SESSION;
  my $language = $session->i18n->language();

  Foswiki::Func::addToZone('script', "GOOGLEMAPSAPI", <<"HERE");
<script src="http://maps.googleapis.com/maps/api/js?sensor=false&language=$language" type="text/javascript"></script>
HERE

}

sub GOOGLEMAPS {
  my ($this, $params, $theTopic, $theWeb) = @_;

  my %opts = ();

  my $address = $params->{address};
  $opts{map}{address} = $address if defined $address;

  my $center = $params->{center};
  $opts{map}{options}{center} = [split(/\s*,\s*/, $center)] if defined $center;

  my $zoom = $params->{zoom};
  $opts{map}{options}{zoom} = int($zoom) if defined $zoom;

  my $markerAddress = $params->{markeraddress};
  $opts{marker}{address} = $markerAddress if defined $markerAddress;

  my $infoWindow = $params->{infowindow};
  $opts{infowindow}{options}{content} = $infoWindow if defined $infoWindow;

  my $infoWindowAddress = $params->{infowindowaddress};
  $opts{infowindow}{address} = $infoWindowAddress if defined $infoWindowAddress;

  my $infoWindowPosition = $params->{infowindowposition};
  $opts{infowindow}{options}{position} = [split(/\s*,\s*/, $infoWindowPosition)] if defined $infoWindowPosition;

  my $mapType = $params->{type};
  $opts{map}{options}{mapTypeId} = $mapType if defined $mapType;

  my $mapTypeControl = Foswiki::Func::isTrue($params->{typecontrol}, 1);
  $opts{map}{options}{mapTypeControl} = $mapTypeControl;

  my $navigationControl = Foswiki::Func::isTrue($params->{navigationcontrol}, 1);
  $opts{map}{options}{navigationControl} = $navigationControl;

  my $streetViewControl = Foswiki::Func::isTrue($params->{streetviewcontrol}, 1);
  $opts{map}{options}{streetViewControl} = $streetViewControl;

  my $scrollWheel = Foswiki::Func::isTrue($params->{scrollwheel}, 1);
  $opts{map}{options}{scrollwheel} = $scrollWheel;

  my $height = $params->{height};
  $height = '350px' unless defined $height;
  my $width = $params->{width};

  my @styles = ();
  push @styles, "height:$height";
  push @styles, "width:$width" if defined $width;

  my $id = $params->{id};
  $id = 'gmap3' . Foswiki::Plugins::JQueryPlugin::Plugins::getRandom() unless defined $id;
 
  my $script = "<script>jQuery(function(\$) {\n";
  $script .= '$("#'.$id.'").gmap3(';
  $script .= JSON::to_json(\%opts, {pretty=>1});
  $script =~ s/\n$//;
  $script .= ");});\n</script>";

  Foswiki::Func::addToZone("script", $id, $script, "JQUERYPLUGIN, GOOGLEMAPSAPI");

  return "<div class='gmap3' id='$id' style='".join(";", @styles)."'></div>";
}

1;
