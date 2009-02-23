# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2003 RahulMundke

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
#
# =========================
package Foswiki::Plugins::CounterPlugin;

# =========================
#This is plugin specific variable
use vars qw(
        $web $topic $user $installWeb $VERSION $RELEASE $debug 
    );

# This should always be $Rev$ so that TWiki can determine the checked-in
# status of the plugin. It is used by the build automation tools, so
# you should leave it alone.
our $VERSION = '$Rev$';

# This is a free-form string you can use to "name" your own plugin version.
# It is *not* used by the build automation tools, but is reported as part
# of the version number in PLUGINDESCRIPTIONS.
our $RELEASE = 'Dakar';

our $SHORTDESCRIPTION = 'Vistor counts';

$debug = 1;

# =========================
sub initPlugin
{
    ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if( $Foswiki::Plugins::VERSION < 1 ) {
        &Foswiki::Func::writeWarning( "Version mismatch between CounterPlugin and Plugins.pm" );
        return 0;
    }
   	
    Foswiki::Func::registerTagHandler( COUNTER_PLUGIN => \&_COUNTER );

    return 1;
}

#-------------------------------------------------------------------------------------------------

sub _COUNTER
{
    my($session, $params, $theTopic, $theWeb) = @_;

	# increment the counter and throw up the page with this count
	my $FileLocation = &Foswiki::Func::getWorkArea( 'CounterPlugin' );
	my $DataFile = 'visitor_count.txt';
	my $CounterFile = "$FileLocation/$DataFile";
    	&Foswiki::Func::writeDebug( "- Foswiki::Plugins:CounterPlugin::FileLocation is $FileLocation" );
	
	if ( open(FILE , '<', $CounterFile) )
	{
	    $Count = <FILE>;
	    close FILE;
	}
	else
	{
	    # File doesn't exist
	    $Count = 0;
	}
	
	open(FILE, '>', $CounterFile) || die "Can't open $DataFile file";
	++$Count;
	print FILE $Count;
	close FILE;
	
	return $Count;
}

1;
