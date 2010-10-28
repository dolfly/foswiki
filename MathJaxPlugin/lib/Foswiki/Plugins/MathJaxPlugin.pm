# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
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

=pod

---+ package Foswiki::Plugins::MathJaxPlugin

=cut


package Foswiki::Plugins::MathJaxPlugin;

# Always use strict to enforce variable scoping
use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = '$Rev: 2083 (2010-10-27) $';
our $RELEASE = '0.9.0';

# Short description of this plugin
# One line description, is shown in the %SYSTEMWEB%.TextFormattingRules topic:
our $SHORTDESCRIPTION = 'Macros for embedding MathJax (an open source JavaScript display engine for mathematics)';

our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # Example code of how to get a preference value, register a macro
    # handler and register a RESTHandler (remove code you do not need)

    # Set your per-installation plugin configuration in LocalSite.cfg,
    # like this:
    # $Foswiki::cfg{Plugins}{MathJaxPlugin}{ExampleSetting} = 1;
    # See %SYSTEMWEB%.DevelopingPlugins#ConfigSpec for information
    # on integrating your plugin configuration with =configure=.

    # Always provide a default in case the setting is not defined in
    # LocalSite.cfg.
    # my $setting = $Foswiki::cfg{Plugins}{MathJaxPlugin}{ExampleSetting} || 0;

    Foswiki::Func::registerTagHandler( 'MATHMODE', \&_MATHMODE );
#    Foswiki::Func::registerTagHandler( '$', \&_MATHMODE );

    # Allow a sub to be called from the REST interface
    # using the provided alias
#    Foswiki::Func::registerRESTHandler( 'example', \&restExample );

    # Plugin correctly initialized
    return 1;
}

sub _MATHMODE {
    my($session, $params, $theTopic, $theWeb) = @_;
    # $session  - a reference to the Foswiki session object
    #             (you probably won't need it, but documented in Foswiki.pm)
    # $params=  - a reference to a Foswiki::Attrs object containing 
    #             parameters.
    #             This can be used as a simple hash that maps parameter names
    #             to values, with _DEFAULT being the name for the default
    #             (unnamed) parameter.
    # $theTopic - name of the topic in the query
    # $theWeb   - name of the web in the query
    # Return: the result of processing the macro. This will replace the
    # macro call in the final text.

#    Foswiki::Func::writeDebug( "MathJaxPlugin [" . $params->{_DEFAULT} . "]" );

    Foswiki::Func::addToZone( 'head', 'MATHJAX_PLUGIN', <<__SCRIPT__ );
<script type="text/javascript" src="%PUBURL%/%SYSTEMWEB%/MathJaxPlugin/MathJax/MathJax.js">
    MathJax.Hub.Config({
        jax: ["input/TeX", "output/HTML-CSS"],
        delayStartupUntil: "onload"
    });
</script>
__SCRIPT__
    return '<noautolink><script type="math/tex">' . $params->{_DEFAULT} . "</script></noautolink>\n";
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2010 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
