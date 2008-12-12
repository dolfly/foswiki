# Copyright (C) 2007 Eugen Mayer@Impressive-media.de
# www.impressive-media.de
# All rights reserved

package Foswiki::Plugins::AttachmentUrlShortcutPlugin;

use strict;
use Assert;
use vars qw( $VERSION $RELEASE $SHORTDESCRIPTION $debug $pluginName $NO_PREFS_IN_TOPIC );

$VERSION = '$Rev: 12445$';
$RELEASE = 'Dakar';
$SHORTDESCRIPTION = 'Lets you use shortened syntax for links for attachments with %A%';

$NO_PREFS_IN_TOPIC = 1;

# Name of this Plugin, only used in this module
$pluginName = 'AttachmentUrlShortcutPlugin';

sub initPlugin {
    my( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if( $Foswiki::Plugins::VERSION < 1.026 ) {
        Foswiki::Func::writeWarning( "Version mismatch between $pluginName and Plugins.pm" );
        return 0;
    }

    Foswiki::Func::registerTagHandler( 'A', \&_AURLSHORT );

    return 1;
}

sub _AURLSHORT {
    my($this, $params, $topic, $web) = @_;
    $web = $params->{'Bereich'} || $params->{'web'} || $web;
    $topic = $params->{'Dokument'} || $params->{'topic'} || $topic;
    my $file = $params->{'Anhang'} || $params->{'file'} || "";
    my $name = $params->{'Name'} || $params->{'name'} || $file;
    my $url;
    if($file eq "") {
       return Foswiki::Func::getScriptUrl($web, $topic, 'viewfile', 'filename'=>'');	
    }
    #else
    $url = Foswiki::Func::getScriptUrl($web, $topic, 'viewfile', 'filename'=>$file);
    return "[[$url][$name]]";
}

1;
