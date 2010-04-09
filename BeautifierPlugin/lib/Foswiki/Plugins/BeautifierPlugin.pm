#
# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2002-2003 Ling Lo
# Copyright (C) 2006-2007 Will Norris, will@biohack.net
# Copyright (C) 2010      Bryan Thale, bryan.thale@motorola.com
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

=begin TML

---+ package BeautifierPlugin

Implements the %<nop>CODE% and %<nop>ENDCODE% macros to display code fragments
with formatting and syntax highlighting for improved readbility in wiki topics.

Plugin Version: $Rev$

=cut

package Foswiki::Plugins::BeautifierPlugin;

use strict;

require Foswiki::Func;
require Foswiki::Plugins;

# $VERSION is referenced by Foswiki and is the only global variable that
# *must* exist in this package.  This should always be '$Rev$'
# so that Foswiki can determine the checked-in status of the plugin.  It is
# used by the build automation tools, so you should leave it alone.
our $VERSION = '$Rev$';

# $RELEASE is a free-form string used to identify "releases" of a plugin
# independent of the build system.  It is *not* used by the build automation
# tools, but *is* reported as part of the version number by %PLUGINDESCRIPTIONS%.
#
# BeautifierPlugin uses a major.minor.patch numbering scheme for releases.
# 'major' releases indicate a break in compatibility with previous versions
# such as the removal of deprecated features.  'minor' releases indicate
# backward-compatible changes to or new additions of functionality.  'patch'
# releases indicate bug fixes or other internal implementation changes that
# don't alter the external interface contracts of the package.
our $RELEASE = '1.0';

# One line description of this plugin reported by %PLUGINDESCRIPTIONS%
our $SHORTDESCRIPTION =
'Provides the %<nop>CODE% and %<nop>ENDCODE% macros to display code fragments with formatting and syntax highlighting for improved readbility in wiki topics.';

# BeautifierPlugin uses the normal Foswiki preferences mechanism for settings
our $NO_PREFS_IN_TOPIC = 1;

# Cache of language syntax definitions
my %langs = ();

=begin TML

---++ initPlugin( $topic, $web, $user, $installWeb ) -> $boolean

Verifies compatibility with the current version of the Foswiki Plugin API and
returns.  All real initialization takes place in =handleCode= if/when the
%<nop>CODE% macro is actually invoked in a topic.

   * =$topic= - the name of the topic in the current CGI query
   * =$web= - the name of the web in the current CGI query
   * =$user= - the login name of the user
   * =$installWeb= - the name of the web the plugin topic is in

Returns: 1 on success, 0 on failure

=cut

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    my $min_api_version = 2.0;
    if ( $Foswiki::Plugins::VERSION < $min_api_version ) {

        # Oops! We are not compatible with this version of the Plugin API
        Foswiki::Func::writeWarning( "Version $RELEASE of "
              . __PACKAGE__
              . " requires at least version $min_api_version of the Foswiki "
              . "Plugin API.  Current version is $Foswiki::Plugins::VERSION" );
        return 0;
    }

    _debugEntryPoint( "$web.$topic", 'initPlugin',
        { user => $user, installWeb => $installWeb } );

    # Plugin correctly initialized
    _debug( "$web.$topic", "Plugin initialized" );
    return 1;
}

=begin TML

---++ commonTagsHandler($text, $topic, $web, $included, $meta )

Replace any %<nop>CODE%...%<nop>ENDCODE% blocks in the topic text with 
beautified HTML.  The topic text is modified in place.

   * =$text= - text to be processed
   * =$topic= - the name of the topic in the current CGI query
   * =$web= - the name of the web in the current CGI query
   * =$included= - Boolean flag indicating whether the handler has been invoked
                   from an included topic
   * =$meta= - meta-data object for the topic MAY BE =undef=

=cut

sub commonTagsHandler {
### my ( $text, $topic, $web, $included, $meta ) = @_;   # do not uncomment, use $_[0], $_[1]... instead

    _debugEntryPoint( "$_[2].$_[1]", 'commonTagsHandler',
        { included => $_[3] } );

    # Find code tag and beautify
    $_[0] =~
      s/%CODE({(.*?)})?%(.*?)%ENDCODE%/&handleCode($2, $3, "$_[2].$_[1]")/gseo;
}

=begin TML

---++ handleCode( $args, $text, $topic ) -> $string

Initializes the plugin, loads required submodules, beautifies and returns the 
given text according to the specified language syntax

   * =$args= - macro argument string (the text between the curly braces in the 
               macro invocation)
   * =$text= - text to be processed (the text between the %<nop>CODE% and 
               %<nop>ENDCODE% macros
   * =$topic= - the web.topic being processed

Returns: the supplied text with HTML markup for formatting and syntax highlights.

=cut

sub handleCode {
    my ( $args, $text, $topic ) = @_;

    # Parse the parameter string into a standard params object
    my %params = &Foswiki::Func::extractParameters($args);

    _debugEntryPoint( $topic, 'handleCode', \%params );

    # Load our submodules
    eval {
        require CGI;
        require Foswiki::Plugins::BeautifierPlugin::Core;
        require Foswiki::Plugins::BeautifierPlugin::HTML;
        require Foswiki::Plugins::BeautifierPlugin::HFile;
    };
    if ($@) {

        # Capture error message up to the first newline
        $@ =~ /^(.*)/;
        my $msg = "Error: Can't load required modules";
        _warning( "$topic", "$msg ($1)" );
        return "%ICON{bomb}% %RED%$msg%ENDCOLOR%";
    }

    # Add the base stylesheet to the HTML header
    Foswiki::Func::addToHEAD( 'BEAUTIFIERPLUGIN_CSS_BASE',
'<link rel="stylesheet" href="%PUBURL%/%SYSTEMWEB%/BeautifierPlugin/style.css" type="text/css" media="all" />'
    );

    # Check for user specified extensions to the stylesheet
    my $css = $params{css}
      || &Foswiki::Func::getPreferencesValue('BEAUTIFIERPLUGIN_CSS');
    if ($css) {

        # Add the user's stylesheet extensions to the HTML header.  They get
        # one CSS file and that's it so they need to consolidate their CSS into
        # a single stylesheet if they have multiple extensions in a single topic
        Foswiki::Func::addToHEAD( 'BEAUTIFIERPLUGIN_CSS_EXTENDED',
                '<link rel="stylesheet" href="'
              . CGI::escapeHTML($css)
              . '" type="text/css" media="all" />' );
    }

    # Find out what language we are supposed to work with
    my $lang =
         $params{_DEFAULT}
      || &Foswiki::Func::getPreferencesValue('BEAUTIFIERPLUGIN_LANGUAGE')
      || 'cpp';

    unless ( $langs{$lang} ) {

        # Need to instantiate a handler for this language
        if ( $lang =~ /^[a-z0-9]+$/ ) {

            # The language identifier is safe so we can use it
            my $hfile =
              &Foswiki::Plugins::BeautifierPlugin::HFile::getLanguage( $topic,
                $lang );
            if ($hfile) {

                # We know this language so set up a handler for it
                my $output = new Foswiki::Plugins::BeautifierPlugin::HTML();
                $langs{$lang} =
                  new Foswiki::Plugins::BeautifierPlugin::Core( $hfile,
                    $output );
            }
        }
    }

    if ( $langs{$lang} ) {
        $text = $langs{$lang}->highlight_text($text);
    }
    else {
        $text = <<EOT;
%ICON{bomb}% %RED%Language '$lang' not supported%ENDCOLOR%

<pre>
$text
</pre>
EOT
        $lang = '';
    }

    return <<EOT;
<div class="BeautifierPlugin"><div class="$lang fragment">
$text
</div></div>
EOT

}

=begin TML

---++ _warning( $topic, $msg )

Log a warning and debug message. The topic is prepended to the message.

   * =$topic= - the web.topic being processed
   * =$msg= - the message text to write to the warning and debug logs

=cut

sub _warning {
    my ( $topic, $msg ) = @_;
    Foswiki::Func::writeWarning( $topic, $msg );
    _debug( $topic, $msg );
}

=begin TML

---++ _debugEntryPoint( $topic, $func, $args )

Write a function entry message to the debug log if debug logging is enabled.
The topic is prepended to the message.

   * =$topic= - the web.topic being processed
   * =$func= - the name of the function being logged
   * =$args= - a reference to a hash containing the arguments passed to $func

=cut

sub _debugEntryPoint {
    if ( Foswiki::Func::getPreferencesFlag('BEAUTIFIERPLUGIN_DEBUG') ) {
        my ( $topic, $func, $args ) = @_;
        my $msg = '';
        foreach my $key ( sort keys %$args ) {
            $msg .= ", $key=>'$args->{$key}'";
        }
        $msg =~ s/^, //;
        _debug( $topic, "$func( $msg )" );
    }
}

=begin TML

---++ _debug( $topic, $msg )

Write the supplied message to the debug log if debug logging is enabled. The
Perl package name and topic are prepended to the message.

   * =$topic= - the web.topic being processed
   * =$msg= - the message text to write to the debug log

=cut

sub _debug {
    if ( Foswiki::Func::getPreferencesFlag('BEAUTIFIERPLUGIN_DEBUG') ) {
        my ( $topic, $msg ) = @_;
        Foswiki::Func::writeDebug( __PACKAGE__, $topic, $msg );
    }
}

1;
