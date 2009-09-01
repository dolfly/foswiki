# DateTimePlugin.pm
# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# For DateTimePlugin.pm:
# Copyright (C) 2004 AurŽlio A. Heckert, aurelio@im.ufba.br
# Copyright (C) 2008, 2009 Arthur Clemens, arthur@visiblearea.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::DateTimePlugin;

use strict;
use Foswiki::Func;
use Foswiki::Time;

# This should always be $Rev$ so that Foswiki can determine the checked-in
# status of the plugin. It is used by the build automation tools, so
# you should leave it alone.
our $VERSION = '$Rev$';

# This is a free-form string you can use to "name" your own plugin version.
# It is *not* used by the build automation tools, but is reported as part
# of the version number in PLUGINDESCRIPTIONS.
our $RELEASE = '1.2';

# Short description of this plugin
# One line description, is shown in the %SYSTEMWEB%.TextFormattingRules topic:
our $SHORTDESCRIPTION =
'Display date and time with formatting options, relative date parameters and localized dates';
our $NO_PREFS_IN_TOPIC = 1;

# Name of this Plugin, only used in this module
my $pluginName = 'DateTimePlugin';

my $dateStrings = {};

# with each language:
# $dateStrings->{$language}->{months_short} = ();
# $dateStrings->{$language}->{months_long} = ();
# $dateStrings->{$language}->{weekdays_short} = ();
# $dateStrings->{$language}->{weekdays_long} = ();
$dateStrings->{'en'}->{months_short} = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];
$dateStrings->{'en'}->{months_long} = [
    'January', 'February', 'March',     'April',   'May',      'June',
    'July',    'August',   'September', 'October', 'November', 'December'
];
$dateStrings->{'en'}->{weekdays_short} =
  [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ];
$dateStrings->{'en'}->{weekdays_long} = [
    'Sunday',   'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday'
];

my $dateStringsInited = 0;

# TO REMOVE:
my @monthsLong;
my @monthsShort;
my @weekdaysLong;
my @weekdaysShort;
my @i18n_monthsLong;
my @i18n_monthsShort;
my @i18n_weekdaysLong;
my @i18n_weekdaysShort;
my %fullMonth2IsoMonth;
my $monthLongNamesReStr;

=begin TML

=cut

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 1 ) {
        Foswiki::Func::writeWarning(
            "Version mismatch between $pluginName and Plugins.pm");
        return 0;
    }

    Foswiki::Func::registerTagHandler( 'DATETIME', \&_formatDateTime );

    # Plugin correctly initialized
    _debug("sub initPlugin( $web.$topic ) is OK");

    return 1;
}

=begin TML

=cut

sub _initDateStrings {

    return if $dateStringsInited;

    _debug("_initDateStrings");

# BELOW THIS LINE: REMOVE WHEN AN ALTERNATIVE IS THERE FOR monthLongNamesReStr AND fullMonth2IsoMonth

    my $upperCasePluginName = uc($pluginName);

    my $language = Foswiki::Func::getPreferencesValue("LANGUAGE") || 'en';

    my $monthsString =
      $Foswiki::cfg{Plugins}{DateTimePlugin}{Dates}{$language}->{months_long};
    @i18n_monthsLong =
      $monthsString
      ? split( /\s*,\s*/, $monthsString )
      : @{ $dateStrings->{'en'}->{months_long} };

    my $monthsShortString =
      $Foswiki::cfg{Plugins}{DateTimePlugin}{Dates}{$language}->{months_short};
    @i18n_monthsShort =
      $monthsShortString
      ? split( /[[:space:],]+/, $monthsShortString )
      : @{ $dateStrings->{'en'}->{months_short} };

    my $weekdaysString =
      $Foswiki::cfg{Plugins}{DateTimePlugin}{Dates}{$language}->{weekdays_long};
    @i18n_weekdaysLong =
      $weekdaysString
      ? split( /[[:space:],]+/, $weekdaysString )
      : @{ $dateStrings->{'en'}->{weekdays_long} };

    my $weekdaysShortString =
      $Foswiki::cfg{Plugins}{DateTimePlugin}{Dates}{$language}
      ->{weekdays_short};
    @i18n_weekdaysShort =
      $weekdaysShortString
      ? split( /[[:space:],]+/, $weekdaysShortString )
      : @{ $dateStrings->{'en'}->{weekdays_short} };

    # all long month names as one 'or' string to be used in regexes
    $monthLongNamesReStr =
      join( '|', @{ $dateStrings->{'en'}->{months_long} } );

    # create a mapping between long and short month names
    {
        my $count = 0;
        %fullMonth2IsoMonth =
          map { $_ => $monthsShort[ $count++ ] }
          @{ $dateStrings->{'en'}->{months_long} };
    }

    $dateStringsInited = 1;
}

=begin TML

Parses the DATETIME macro.

=cut

sub _formatDateTime {
    my ( $session, $params, $inTopic, $inWeb ) = @_;

    _debug("_formatDateTime");

    _initDateStrings();

    my $format =
         $params->{"format"}
      || $params->{_DEFAULT}
      || $Foswiki::cfg{DefaultDateFormat}
      || '$day $month $year - $hours:$minutes:$seconds';

    my $language =
         $params->{"language"}
      || Foswiki::Func::getPreferencesValue("LANGUAGE")
      || 'en';
    my $incDays  = $params->{"incdays"}    || 0;
    my $incHours = $params->{"inchours"}   || 0;
    my $incMins  = $params->{"incminutes"} || $params->{"incmins"} || 0;
    my $incSecs  = $params->{"incseconds"} || $params->{"incsecs"} || 0;
    my $timezoneOffsetSetting =
      $Foswiki::cfg{Plugins}{DateTimePlugin}{TimezoneOffset} || 0;
    my $timezoneOffsetParam = $params->{"timezoneoffset"} || 0;
    my $dateStr = $params->{"date"};

    _debug("\t format=$format");
    _debug("\t incDays=$incDays");
    _debug("\t incHours=$incHours");
    _debug("\t incMins=$incMins");
    _debug("\t incSecs=$incSecs");
    _debug("\t timezoneOffsetSetting=$timezoneOffsetSetting");
    _debug("\t timezoneOffsetParam=$timezoneOffsetParam");
    _debug("\t format=$format")   if $format;
    _debug("\t dateStr=$dateStr") if $dateStr;

    $incHours += $timezoneOffsetParam;

    my $secondsSince1970 = time();

    if ( defined $dateStr ) {

        if ( _isNumber($dateStr) ) {

            # we assume these are seconds
            $secondsSince1970 = int($dateStr);
        }
        else {

            # try to match long month names
            $dateStr =~ s/($monthLongNamesReStr)/$fullMonth2IsoMonth{$1}/g;
            $secondsSince1970 = Foswiki::Time::parseTime($dateStr);
        }
    }
    else {

 # use international time offset setting only when we are using the current time
        $incHours += $timezoneOffsetSetting;
    }

    my $inc =
      $incSecs +
      ( $incMins * 60 ) +
      ( $incHours * 60 * 60 ) +
      ( $incDays * 60 * 60 * 24 );

    _debug("\t inc=$inc");

    my $tmpTimeFormat =
"\$seconds,\$minutes,\$hours,\$day,\$wday,\$dow,\$week,\$month,\$mo,\$year,\$ye,\$tz";
    my $timeString =
      Foswiki::Time::formatTime( $secondsSince1970 + $inc, $tmpTimeFormat, 1 );
    my @timeValues = split( ",", $timeString );

    _debugData( "timeString=$timeString", \@timeValues );

    my $seconds = $timeValues[0];
    my $minutes = $timeValues[1];
    my $hours   = $timeValues[2];
    my $day     = $timeValues[3];
    my $wday    = $timeValues[4];
    my $dow     = $timeValues[5];
    my $week    = $timeValues[6];
    my $month   = $timeValues[7];
    my $mo      = $timeValues[8];
    my $year    = $timeValues[9];
    my $ye      = $timeValues[10];
    my $tz      = $timeValues[11];

    my $monthIndex = $mo - 1;

    # Predefined formats:
    my $iso  = "$year-$mo-${day}T$hours:${minutes}:${seconds}Z";
    my $rcs  = "$year/$mo/$day $hours:$minutes:$seconds";
    my $http = "$wday, $day $month $year $hours:$minutes:$seconds $tz";

    my $out = $format;

    _debug("\t format=$format; wday=$wday");

    # added formats
    $out =~
s/\$month_long/_getLocalizedDate('months_long', $language, $monthIndex)/ges;
    $out =~
      s/\$wday_long/_getLocalizedDate('weekdays_long', $language, $dow)/ges;

    # GMTIME formats
    $out =~ s/\$seconds/$seconds/gs;
    $out =~ s/\$minutes/$minutes/gs;
    $out =~ s/\$hours/$hours/gs;
    $out =~ s/\$day/$day/gs;
    $out =~ s/\$wday/_getLocalizedDate('weekdays_short', $language, $dow)/ges;
    $out =~ s/\$dow/$dow/gs;
    $out =~ s/\$week/$week/gs;
    $out =~
      s/\$month/_getLocalizedDate('months_short', $language, $monthIndex)/ges;
    $out =~ s/\$mo/$mo/gs;
    $out =~ s/\$year/$year/gs;
    $out =~ s/\$ye/$ye/gs;
    $out =~ s/\$tz/$tz/gs;
    $out =~ s/\$iso/$iso/gs;
    $out =~ s/\$rcs/$rcs/gs;
    $out =~ s/\$http/$http/gs;
    $out =~ s/\$epoch/$secondsSince1970/gs;

    # deprecated since version 1.2

    # months
    $out =~ s/\$lmonth/_getLocalizedDate('months_long', 'en', $monthIndex)/ges;
    $out =~
      s/\$i_month/_getLocalizedDate('months_short', $language, $monthIndex)/ges;
    $out =~
      s/\$i_lmonth/_getLocalizedDate('months_long', $language, $monthIndex)/ges;

    # weekdays
    $out =~ s/\$lwday/_getLocalizedDate('weekdays_long', 'en', $dow)/ges;
    $out =~ s/\$i_wday/_getLocalizedDate('weekdays_short', $language, $dow)/ges;
    $out =~ s/\$i_lwday/_getLocalizedDate('weekdays_long', $language, $dow)/ges;

    # other
    $out =~ s/\$sec/$seconds/gs;
    $out =~ s/\$min/$minutes/gs;
    $out =~ s/\$hour/$hours/gs;
    $out =~
      s/\$day2/$day/gs;    # actually this is identical; kept for compatibility

    return $out;
}

sub _getLocalizedDate {
    my ( $key, $language, $index ) = @_;

    _debug("sub _getLocalizedDate; key=$key; language=$language; index=$index");
    $dateStrings->{$language}->{$key} ||=
      _getLocalizedStringAsArrayRef( $language, $key );
    return $dateStrings->{$language}->{$key}->[$index];
}

=pod

=cut

sub _getLocalizedStringAsArrayRef {
    my ( $language, $type ) = @_;

    my $dateString =
      $Foswiki::cfg{Plugins}{DateTimePlugin}{Dates}{$language}->{$type};
    if ($dateString) {
        my @names = split( /\s*,\s*/, $dateString );
        return \@names;
    }
    else {
        _debugData( "\t returning existing:", $dateStrings->{'en'}->{$type} );
        return $dateStrings->{'en'}->{$type};
    }
}

=pod

=cut

sub _isNumber {
    my ($n) = @_;

    eval {
        local $SIG{__WARN__} = sub { die $_[0] };
        $n += 0;
    };
    if   ($@) { return 0; }
    else      { return 1; }

}

=pod

writes a debug message if the $debug flag is set

=cut

sub _debug {
    my ($text) = @_;

    return if !$text;
    return if !$Foswiki::cfg{Plugins}{DateTimePlugin}{Debug};
    Foswiki::Func::writeDebug("$pluginName; $text");
}

sub _debugData {
    my ( $text, $data ) = @_;

    return if !$Foswiki::cfg{Plugins}{DateTimePlugin}{Debug};
    Foswiki::Func::writeDebug("$pluginName; $text:");
    if ($data) {
        eval 'use Data::Dumper; Foswiki::Func::writeDebug(Dumper($data));';
    }
}

1;
