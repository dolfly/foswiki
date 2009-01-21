# This script Copyright (c) 2008 Impressive.media 
# and distributed under the GPL (see below)
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

# =========================
package Foswiki::Plugins::JQueryCompatibilityModePlugin;

# =========================
use strict;
use warnings;
use Error qw(:try);

# $VERSION is referred to by Foswiki, and is the only global variable that
# *must* exist in this package.
use vars
  qw( $VERSION $RELEASE $SHORTDESCRIPTION $debug $pluginName $NO_PREFS_IN_TOPIC );

# This should always be $Rev: 12445$ so that Foswiki can determine the checked-in
# status of the plugin. It is used by the build automation tools, so
# you should leave it alone.
$VERSION = '$Rev: 12445$';

# This is a free-form string you can use to "name" your own plugin version.
# It is *not* used by the build automation tools, but is reported as part
# of the version number in PLUGINDESCRIPTIONS.
$RELEASE = '0.4';

# Short description of this plugin
# One line description, is shown in the %FoswikiWEB%.TextFormattingRules topic:
$SHORTDESCRIPTION =
'Just the same as JqueryPlugin but using the compatibilty mode to provide use with other frameworks';

# Name of this Plugin, only used in this module
$pluginName = 'JQueryCompatibilityModePlugin';

# =========================

my $jqPluginName = $pluginName;
sub initPlugin {# ---+ AutoCompletitionLibPlugin
# This is the configuration used by the <b>ToPDFPlugin</b> and the
# <h2>General</h2>

# **BOOLEAN**
# should the .js and .css files be included automatically 
$Foswiki::cfg{Plugins}{AutoCompletitionLibPlugin}{AutoInclude} = 1;
    my ( $topic, $web, $user, $installWeb ) = @_;
    my $pluginPubHome = Foswiki::Func::getPubUrlPath()."/System/$pluginName";
    
    # introducing a variable which helps the users use the current ScriptURL PubURL and other
    # foswiki system variables in his javascripts 
    if(   $Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{InitializeFoswikiVar} ) {
	    my $foswikiJSvars = "var Foswiki;\nif (!Foswiki) { Foswiki = {};}";
	    $foswikiJSvars .= "\nFoswiki.systemWeb='" . $Foswiki::cfg{SystemWebName}."';"; 
	    $foswikiJSvars .= "\nFoswiki.userWeb='" . $Foswiki::cfg{UsersWebName}."';";
	    $foswikiJSvars .= "\nFoswiki.scriptUrlPath='" . Foswiki::Func::getScriptUrlPath()."';";
	    $foswikiJSvars .= "\nFoswiki.pubUrlPath='" . Foswiki::Func::getPubUrlPath() ."';";
	    $foswikiJSvars .= "\nFoswiki.pubDir='" . Foswiki::Func::getPubDir()."';";
	    $foswikiJSvars .= "\nFoswiki.scriptSuffix='" . $Foswiki::cfg{ScriptSuffix}."';";
	    $foswikiJSvars .= "\nFoswiki.scriptUrlPath='" . $Foswiki::cfg{ScriptUrlPath}."';";	    
	    $foswikiJSvars .= "\nFoswiki.viewScript='" . Foswiki::Func::getScriptUrl("view") ."';";
	    my $output = "<script type='text/javascript'>$foswikiJSvars</script>";
	    
	    Foswiki::Func::addToHEAD($jqPluginName."_fowikiVars",$output); 
    }
    
    if(   $Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{AutoIncludeCore} ) {
	    my $output = "<script language='javascript' type='text/javascript' src='$pluginPubHome/jquery.js'></script>";
	    Foswiki::Func::addToHEAD($jqPluginName."_jq",$output,$jqPluginName."_fowikiVars");
	    $output = "<script language='javascript' type='text/javascript' src='$pluginPubHome/jquery_init.js'></script>";
	    Foswiki::Func::addToHEAD($jqPluginName."_jq_init",$output,$jqPluginName."_jq");
    }
 
    addDialogScripts() if($Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{DialogInclude});
    return 1;
}

sub addDialogScripts() {    
    my $pluginPubHome = Foswiki::Func::getPubUrlPath()."/System/$jqPluginName";
    my $output = "<script language='javascript' type='text/javascript' src='$pluginPubHome/ui/ui.core.js'></script>";
    Foswiki::Func::addToHEAD($jqPluginName."_jqui.core",$output,$jqPluginName."_jq_init");
    
    $output = "<script language='javascript' type='text/javascript' src='$pluginPubHome/ui/ui.draggable.js'></script>";    
    Foswiki::Func::addToHEAD($jqPluginName."_jqui.draggable",$output,$jqPluginName."_jqui.core");
    
    $output = "<script language='javascript' type='text/javascript' src='$pluginPubHome/ui/ui.dialog.js'></script>";
    Foswiki::Func::addToHEAD($jqPluginName."_jqui.dialog",$output,$jqPluginName."_jqui.core"); 
    
    $output = "<script language='javascript' type='text/javascript' src='$pluginPubHome/ui/ui.resizable.js'></script>";
    Foswiki::Func::addToHEAD($jqPluginName."_jqui.resiz",$output,$jqPluginName."_jqui.core");
    


   
    #$output = "<script language='javascript' type='text/javascript' src='$pluginPubHome/misc/ui.dimensions.js'></script>";
    #Foswiki::Func::addToHEAD($pluginName."_jquerylibdimensions",$output,$pluginName."_jqueryuicore");
}
