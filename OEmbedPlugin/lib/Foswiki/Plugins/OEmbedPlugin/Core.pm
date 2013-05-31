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

package Foswiki::Plugins::OEmbedPlugin::Core;

use strict;
use warnings;

use Web::oEmbed ();
use Foswiki::Func ();

use constant DEBUG => 0; # toggle me

sub writeDebug {
  print STDERR "OEmbedPlugin::Core - $_[0]\n" if DEBUG;
}

sub new {
  my $class = shift;

  my $this = bless({
    @_
  }, $class);

  $this->{consumer} = Web::oEmbed->new({format=>'json'});

  if (defined $Foswiki::cfg{OEmbedPlugin}{Providers}) {

    foreach my $provider (keys %{$Foswiki::cfg{OEmbedPlugin}{Providers}}) {
      #print STDERR "registering provider $provider\n";

      my $url = $Foswiki::cfg{OEmbedPlugin}{Providers}{$provider}{url};
      my $api = $Foswiki::cfg{OEmbedPlugin}{Providers}{$provider}{api};
      my $regexp = $Foswiki::cfg{OEmbedPlugin}{Providers}{$provider}{regexp};
      my $params = $Foswiki::cfg{OEmbedPlugin}{Providers}{$provider}{params} || {};

      my @urls;
      if (ref($url) eq 'ARRAY') {
        @urls = @$url;
      } else {
        push @urls, $url;
      }

      if ($provider eq 'Embedly') {
        if ($Foswiki::cfg{OEmbedPlugin}{EmbedlyKey}) {
          $params->{key} = $Foswiki::cfg{OEmbedPlugin}{EmbedlyKey};
        } else {
          print STDERR "WARNING: no api key for embed.ly ... skipping\n";
          next;
        }
      }

      foreach $url (@urls) {
        $this->{consumer}->register_provider({
          name => $provider,
          url  => $url,
          regexp  => $regexp,
          api  => $api,
          params => $params,
        });
      }
    }
  }

  return $this;
}

sub EMBED {
  my ($this, $session, $params, $theTopic, $theWeb) = @_;

  writeDebug("called EMBED()");

  my $url = $params->{_DEFAULT} || $params->{url};
  return "<span class='foswikiAlert'>ERROR: no url param</span>" unless $url;

  my $width = $params->{width} || Foswiki::Func::getPreferencesValue("OEMBED_MAXWIDTH") || '';
  my $height = $params->{height} || Foswiki::Func::getPreferencesValue("OEMBED_MAXHEIGHT") || '';

  my $opts;
  $opts->{maxwidth} = $width if $width;
  $opts->{maxheight} = $height if $height;

  my $response = eval {$this->{consumer}->embed($url, $opts)};
  if ($@) {
    print STDERR "ERROR: $@\n";
  }

  unless (defined $response) {
    #print STDERR "no response for $url\n";
    return $url;
  }

  $response->web_page($url); # SMELL: hook in the orig url

  my $result = $response->render($opts);
  return '<literal>'.$result.'</literal>' if defined $result;

  #print STDERR "WARNING: Hm, can't render response from $url\n";
  return $url;
}

1;
