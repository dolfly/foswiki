# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# ZonePlugin is Copyright (C) 2010 Michael Daum http://michaeldaumconsulting.com
#
# Based on core code of Foswiki-1.0.9
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
package Foswiki::Plugins::ZonePlugin;

use strict;
use Foswiki::Func ();
use Foswiki::Plugins ();

our $VERSION = '$Rev$';
our $RELEASE = '1.0';
our $SHORTDESCRIPTION = 'Gather content of a page in named zones while rendering it';
our $NO_PREFS_IN_TOPIC = 1;
our %ZONES;

use constant DOWARN => 0;

# monkey-patch API ###########################################################
BEGIN {
  no warnings 'redefine';
  *Foswiki::Func::addToZone = \&Foswiki::Plugins::ZonePlugin::addToZone;
  *Foswiki::Func::addToHEAD = \&Foswiki::Plugins::ZonePlugin::addToHead;
}

##############################################################################
sub initPlugin {

  Foswiki::Func::registerTagHandler('ADDTOZONE', \&ADDTOZONE);

  # redefine
  Foswiki::Func::registerTagHandler('ADDTOHEAD', \&ADDTOHEAD);

  # RENDERZONE is handled in completePageHandler

  return 1;
}

##############################################################################
sub completePageHandler {
  # my ($text, $hdr)

  $_[0] =~ s/%RENDERZONE{(.*?)}%/RENDERZONE($1)/ge;

  # get the head zone ones again and insert it at </head>
  my $content = renderZone('head', {chomp=>"on", format=>'$item$n'});
  $_[0] =~ s!(</head>)!$content$1!i if $content;

  # get the body zone ones again and insert it at </body>
  $content = renderZone('body', {chomp=>"on", format=>'$item$n'});
  $_[0] =~ s!(</body>)!$content$1!i if $content;

  # clean up all unknown zones
  $_[0] =~ s/%RENDERZONE{.*?}%//g;

  # finally forget it
  %ZONES = ();
}

##############################################################################
sub ADDTOHEAD {
  my ($sessions, $params, $theTopic, $theWeb) = @_;

  my $tag = $params->{_DEFAULT} || '';
  my $topic = $params->{topic} || '';
  my $text = $params->{text} || '';
  my $requires = $params->{requires} || '';

  # SMELL: strange use case
  $text = $tag unless $text;

  Foswiki::Func::writeWarning("use of deprecated ADDTOHEAD in $theWeb.$theTopic")
    if DOWARN;

  addToHead($tag, $text, $requires, 1);
  return '';
}

##############################################################################
sub ADDTOZONE {
  my ($session, $params, $theTopic, $theWeb) = @_;

  my $zones = $params->{_DEFAULT} || $params->{zone} || 'head';
  my $tag = $params->{tag} || '';
  my $topic = $params->{topic} || '';
  my $section = $params->{section} || '';
  my $requires = $params->{requires} || '';;
  my $text = $params->{text} || '';
  my $web = $theWeb;

  if ($topic) {
    ($web, $topic) = Foswiki::Func::normalizeWebTopicName($web, $topic);
    $text = '%INCLUDE{"' . $web . '.' . $topic . '"';
    $text .= ' section="' . $section . '"' if $section;
    $text .= ' warn="off"}%';
  }

  foreach my $zone (split(/\s*,\s*/, $zones)) {
    addToZone($zone, $tag, $text, $requires);
  }

  return '';
}

##############################################################################
# backwards compatibility 
sub addToHead {
  my ($tag, $text, $requires, $nowarn) = @_;

  if (DOWARN && !$nowarn) {
    my ($package, $filename, $line) = caller;
    Foswiki::Func::writeWarning("use of deprecated API addToHEAD at $package line $line")
  }

  # rough check for javascript
  # if it contains text/javascript then set it to 'body'
  # if it also contains text/css then switch it back to 'head' ... won't be optimized
  my $zone = 'head';
  $zone = 'body' if $text =~ /type=["']text\/javascript["']/;
  $zone = 'head' if $text =~ /type=["']text\/css["']/;

  addToZone($zone, $tag, $text, $requires);

  return '';
}

##############################################################################
sub addToZone {
  my ($zone, $tag, $text, $requires) = @_;

  return unless $text;
  $requires ||= '';

  unless ($tag)  {
    # get a random one
    $tag = int(rand(10000)) +1;
  }

  # get zone, or create record
  my $thisZone = $ZONES{$zone};
  unless (defined $thisZone) {
    $ZONES{$zone} = $thisZone = {};
  }

  my @requires;
  foreach my $req (split(/\s*,\s*/, $requires)) {
    unless ($thisZone->{$req}) {
      $thisZone->{$req} = {
        tag => $req,
        requires => [],
        text => '',
      };
    }
    push(@requires, $thisZone->{$req});
  }

  # store records
  my $record = $thisZone->{$tag};
  unless ($record) {
    $record = { tag=>$tag };
    $thisZone->{$tag} = $record;
  }

  # override previous properties
  $record->{requires} = \@requires;
  $record->{text} = $text;
}

##############################################################################
sub RENDERZONE {
  my $attrs = shift;

  my $params = Foswiki::Attrs->new($attrs);
  my $zone = $params->{_DEFAULT} || $params->{zone};

  return renderZone($zone, $params);
}

##############################################################################
sub renderZone {
  my ($zone, $params) = @_;

  return '' unless $zone && $ZONES{$zone};

  $params->{header} ||= '';
  $params->{format} ||= '$item';
  $params->{separator} ||= '';
  $params->{footer} ||= '';
  $params->{chomp} ||= 'off';

  # Loop through the vertices of the graph, in any order, initiating
  # a depth-first search for any vertex that has not already been
  # visited by a previous search. The desired topological sorting is
  # the reverse postorder of these searches. That is, we can construct
  # the ordering as a list of vertices, by adding each vertex to the
  # start of the list at the time when the depth-first search is
  # processing that vertex and has returned from processing all children
  # of that vertex. Since each edge and vertex is visited once, the
  # algorithm runs in linear time.
  my %visited;
  my @total;
  foreach my $v (values %{ $ZONES{$zone} }) {
    visit($v, \%visited, \@total);
  }

  # kill a zone ones it has been rendered
  undef $ZONES{$zone};

  my @result = ();
  foreach my $item (@total) {
    my $text = $item->{text};
    if ($params->{'chomp'}) {
      $text =~ s/^\s+//g;
      $text =~ s/\s+$//g;
    }
    next unless $text;
    my $line = $params->{format};
    $line =~ s/\$item\b/$text/g;
    $line = Foswiki::Func::decodeFormatTokens($line);
    next unless $line;
    push @result, $line if $line;
  }

  $params->{separator} = Foswiki::Func::decodeFormatTokens($params->{separator});

  my $result = $params->{header} . join($params->{separator}, @result) . $params->{footer};
  $result = Foswiki::Func::expandCommonVariables($result);
  $result = Foswiki::Func::renderText($result);

  return $result;
}

##############################################################################
sub visit {
  my ($v, $visited, $list) = @_;

  return if $visited->{$v};
  $visited->{$v} = 1;

  foreach my $r (@{ $v->{requires} }) {
    visit($r, $visited, $list);
  }

  push(@$list, $v);
}

1;
