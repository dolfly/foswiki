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

---+ package BeautifierPlugin::HFile

Base class and object instance factory for Beautifier Language Syntax 
Highlighter definitions.  This class was originally derived from Mike Jewell's 
Beautifier: Flexible Syntax Highlighter package written in PHP.

=cut

package Foswiki::Plugins::BeautifierPlugin::HFile;

require Foswiki::Func;

=begin TML

---++ StaticMethod getLanguage( $topic, $lang ) -> $HFile

Factory method that loads the submodule for the requested language definition 
and instantiates and returns a handler object for it.

   * =$topic= - the web.topic of the topic being processed
   * =$lang= - the language specifier for the desired language definition

Returns: the language definition object on success or =undef= on failure

=cut

sub getLanguage {
    my ( $topic, $lang ) = @_;
    my $handler = __PACKAGE__ . "::HFile_$lang";

    # Load the language module
    eval "require $handler";
    if ($@) {

        # Capture error message up to the first newline
        $@ =~ /^(.*)/;
        my $msg = "Error: Can't load required module for language '$lang'";
        _warning( "$topic", "$msg ($1)" );
        return undef;
    }

    # Instantiate the language defintion handler
    $handler = eval "new ${handler}::";
    if ($@) {

        # Capture error message up to the first newline
        $@ =~ /^(.*)/;
        my $msg = "Error: Can't instantiate language '$lang'";
        _warning( "$topic", "$msg ($1)" );
        return undef;
    }

    return $handler;
}

=begin TML

---++ ClassMethod new( $class ) -> $HFile

Contructor for the abstract BeautifierPlugin::HFile superclass.

   * =$class= - the invocant (i.e., the class being instantiated into an object)

Returns: a reference to the newly instantiated object

=cut

sub new {
    my ($class) = @_;
    $self = {};
    bless $self, $class;

    $self->{config}          = ();
    $self->{validkeys}       = ();
    $self->{indent}          = ();
    $self->{unindent}        = ();
    $self->{blockcommenton}  = ();
    $self->{blockcommentoff} = ();
    $self->{linecommenton}   = ();
    $self->{preprocessors}   = ();
    $self->{zones}           = ();
    $self->{keywords}        = ();
    $self->{keypats}         = ();
    $self->{stringchars}     = ();
    $self->{delimeters}      = ();
    $self->{escchar}         = "\\";
    $self->{perl}            = 0;
    $self->{notrim}          = 0;
    $self->{nocase}          = 0;

    return $self;
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
            $msg .= ", $key=>'args->{$key}'";
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
