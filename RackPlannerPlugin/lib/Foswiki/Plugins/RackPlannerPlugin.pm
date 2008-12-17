# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2000-2003 Andrea Sterbini, a.sterbini@flashnet.it
# Copyright (C) 2001-2006 Peter Thoeny, peter@thoeny.org
# and TWiki Contributors. All Rights Reserved. TWiki Contributors
# are listed in the AUTHORS file in the root of this distribution.
# NOTE: Please extend that file, not this notice.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For licensing info read LICENSE file in the TWiki root.

# change the package name and $pluginName!!!
package Foswiki::Plugins::RackPlannerPlugin;

# Always use strict to enforce variable scoping
use strict;
require Foswiki::Plugins::RackPlannerPlugin::RackPlanner;

# $VERSION is referred to by TWiki, and is the only global variable that
# *must* exist in this package
use vars qw( $VERSION $RELEASE $debug $pluginName $REVISION );

# This should always be $Rev: 8670$ so that TWiki can determine the checked-in
# status of the plugin. It is used by the build automation tools, so
# you should leave it alone.
$VERSION = '$Rev: 8670$';

# This is a free-form string you can use to "name" your own plugin version.
# It is *not* used by the build automation tools, but is reported as part
# of the version number in PLUGINDESCRIPTIONS.
$RELEASE = 'Foswiki 1.0';

$REVISION = '1.006'
  ; #dro# fixed minor tooltip foreground/background color bug; added device icon shortcut feature; added some base device icons;

#$REVISION = '1.005'; #dro# fixed links in 'connected to' or 'owner' field bug; added new attribute (clicktooltip...); added documentation
#$REVISION = '1.004'; #dro# fixed replacement in tooltipformat bug; improved tooltipformat; improved HTML rendering performance;  added and fixed documenation;
#$REVISION = '1.003'; #dro# fixed displayowner/displaynotes bug reported by TWiki:Main.PatrickTuite; added horizontal rendering feature requested by TWiki:Main.OlofStockhaus; added new attributes (columnwidth, textdir); fixed HTML validation bug;
#$REVISION = '1.002'; #dro# allowed multiple entries in a single unit; fixed rendering bug reported by TWiki:Main.SteveWray; fixed link color bug reported by TWiki:Main.SteveWray
#$REVISION = '1.001'; #dro# improved some features (added statistics); added attributes (rackstatformat, displayunitcolumn, unitcolumn*); renamed attribute statformat; fixed documentation; fixed tooltip bug; fixed conflict bug;
#$REVISION = '1.000'; #dro# initial version

# Name of this Plugin, only used in this module
$pluginName = 'RackPlannerPlugin';

=pod

---++ initPlugin($topic, $web, $user, $installWeb) -> $boolean
   * =$topic= - the name of the topic in the current CGI query
   * =$web= - the name of the web in the current CGI query
   * =$user= - the login name of the user
   * =$installWeb= - the name of the web the plugin is installed in

REQUIRED

Called to initialise the plugin. If everything is OK, should return
a non-zero value. On non-fatal failure, should write a message
using Foswiki::Func::writeWarning and return 0. In this case
%FAILEDPLUGINS% will indicate which plugins failed.

In the case of a catastrophic failure that will prevent the whole
installation from working safely, this handler may use 'die', which
will be trapped and reported in the browser.

You may also call =Foswiki::Func::registerTagHandler= here to register
a function to handle tags that have standard TWiki syntax - for example,
=%MYTAG{"my param" myarg="My Arg"}%. You can also override internal
TWiki tag handling functions this way, though this practice is unsupported
and highly dangerous!

=cut

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 1.021 ) {
        Foswiki::Func::writeWarning(
            "Version mismatch between $pluginName and Plugins.pm");
        return 0;
    }

    # Get plugin preferences, variables defined by:
    #   * Set EXAMPLE = ...
    ####my $exampleCfgVar = Foswiki::Func::getPreferencesValue( "\U$pluginName\E_EXAMPLE" );
    # There is also an equivalent:
    # $exampleCfgVar = Foswiki::Func::getPluginPreferencesValue( 'EXAMPLE' );
    # that may _only_ be called from the main plugin package.

    ####$exampleCfgVar ||= 'default'; # make sure it has a value

    # register the _EXAMPLETAG function to handle %EXAMPLETAG{...}%
    ####Foswiki::Func::registerTagHandler( 'TIMETABLE', \&_TIMETABLE);

    # Allow a sub to be called from the REST interface
    # using the provided alias
    ####Foswiki::Func::registerRESTHandler('example', \&restExample);

    eval { &Foswiki::Plugins::RackPlannerPlugin::RackPlanner::initPlugin; };

    # Plugin correctly initialized
    return 1;
}

# The function used to handle the %EXAMPLETAG{...}% tag
# You would have one of these for each tag you want to process.
sub _TIMETABLE {
    my ( $session, $params, $theTopic, $theWeb ) = @_;

    # $session  - a reference to the TWiki session object (if you don't know
    #             what this is, just ignore it)
    # $params=  - a reference to a Foswiki::Attrs object containing parameters.
    #             This can be used as a simple hash that maps parameter names
    #             to values, with _DEFAULT being the name for the default
    #             parameter.
    # $theTopic - name of the topic in the query
    # $theWeb   - name of the web in the query
    # Return: the result of processing the tag

    # For example, %EXAMPLETAG{'hamburger' sideorder="onions"}%
    # $params->{_DEFAULT} will be 'hamburger'
    # $params->{sideorder} will be 'onions'
}

=cut

---++ earlyInitPlugin()

May be used by a plugin that requires early initialization. This handler
is called before any other handler.

If it returns a non-null error string, the plugin will be disabled.

=cut

sub DISABLE_earlyInitPlugin {
    return undef;
}

=pod

---++ initializeUserHandler( $loginName, $url, $pathInfo )
   * =$loginName= - login name recovered from $ENV{REMOTE_USER}
   * =$url= - request url
   * =$pathInfo= - pathinfo from the CGI query
Allows a plugin to set the username, for example based on cookies.

Return the user name, or =guest= if not logged in.

This handler is called very early, immediately after =earlyInitPlugin=.

__Since:__ Foswiki::Plugins::VERSION = '1.010'

=cut

sub DISABLE_initializeUserHandler {

    # do not uncomment, use $_[0], $_[1]... instead
    ### my ( $loginName, $url, $pathInfo ) = @_;

    Foswiki::Func::writeDebug(
        "- ${pluginName}::initializeUserHandler( $_[0], $_[1] )")
      if $debug;
}

=pod

---++ registrationHandler($web, $wikiName, $loginName )
   * =$web= - the name of the web in the current CGI query
   * =$wikiName= - users wiki name
   * =$loginName= - users login name

Called when a new user registers with this TWiki.

__Since:__ Foswiki::Plugins::VERSION = '1.010'

=cut

sub DISABLE_registrationHandler {

    # do not uncomment, use $_[0], $_[1]... instead
    ### my ( $web, $wikiName, $loginName ) = @_;

    Foswiki::Func::writeDebug(
        "- ${pluginName}::registrationHandler( $_[0], $_[1] )")
      if $debug;
}

=pod

---++ commonTagsHandler($text, $topic, $web )
   * =$text= - text to be processed
   * =$topic= - the name of the topic in the current CGI query
   * =$web= - the name of the web in the current CGI query
This handler is called by the code that expands %TAGS% syntax in
the topic body and in form fields. It may be called many times while
a topic is being rendered.

Plugins that want to implement their own %TAGS% with non-trivial
additional syntax should implement this function. Internal TWiki
tags (and any tags declared using =Foswiki::Func::registerTagHandler=)
are expanded _before_, and then again _after_, this function is called
to ensure all %TAGS% are expanded.

For tags with trivial syntax it is far more efficient to use
=Foswiki::Func::registerTagHandler= (see =initPlugin=).

__NOTE:__ when this handler is called, &lt;verbatim> blocks have been
removed from the text (though all other HTML such as &lt;pre> blocks is
still present).

__NOTE:__ meta-data is _not_ embedded in the text passed to this
handler.

=cut

require Foswiki::Plugins::RackPlannerPlugin::RackPlanner;

sub commonTagsHandler {

    # do not uncomment, use $_[0], $_[1]... instead
    ### my ( $text, $topic, $web ) = @_;

    Foswiki::Func::writeDebug(
        "- ${pluginName}::commonTagsHandler( $_[2].$_[1] )")
      if $debug;

    # do custom extension rule, like for example:
    # $_[0] =~ s/%XYZ%/&handleXyz()/ge;
    # $_[0] =~ s/%XYZ{(.*?)}%/&handleXyz($1)/ge;

    eval {

        $_[0] =~
s/<\/head>/<script src="%PUBURL%\/%SYSTEMWEB%\/$pluginName\/rackplannertooltips.js" language="javascript" type="text\/javascript"><\/script><\/head>/is
          unless ( $_[0] =~ /rackplannertooltips.js/ );

        $_[0] =~
s/%RACKPLANNER%/&Foswiki::Plugins::RackPlannerPlugin::RackPlanner::expand("",$_[0],$_[1],$_[2])/ge;
        $_[0] =~
s/%RACKPLANNER{(.*?)}%/&Foswiki::Plugins::RackPlannerPlugin::RackPlanner::expand($1, $_[0], $_[1], $_[2])/ge;

    };
    &Foswiki::Func::writeWarning($@) if $@;
}


1;
