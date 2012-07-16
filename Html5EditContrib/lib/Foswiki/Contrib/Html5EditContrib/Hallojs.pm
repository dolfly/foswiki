package Foswiki::Contrib::Html5EditContrib::Hallojs;
use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin ();
our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

use Foswiki::Plugins::JQueryPlugin::Plugin ();
use Foswiki::Contrib::Html5EditContrib ();

sub new {
    my $class = shift;
    my $session = shift || $Foswiki::Plugins::SESSION;
   
    my $this = $class->SUPER::new( 
        $session,
        name          => 'hallojs',
        version       => $Foswiki::Contrib::Html5EditContrib::RELEASE,
        author        => '(c) 2011 Henri Bergius, IKS Consortium',
        homepage      => 'http://hallojs.org',
        puburl        => '%PUBURLPATH%/%SYSTEMWEB%/Html5EditContrib',
        documentation => "$Foswiki::cfg{SystemWebName}.Html5EditContrib",
        summary       => $Foswiki::Contrib::Html5EditContrib::SHORTDESCRIPTION,
        dependencies  => ['bootstrap', 'JQUERYPLUGIN', 'UI', 'UI::Button'],
        javascript    => [ "hallo.js" ],
        css    => [ "hallo.css" ]
        );
    
    return $this;
}


sub renderCSS {
    my ( $this, $text ) = @_;

    $text =~ s/\.min// if $this->{debug};
    $text .= '?version=' . $this->{version};
    $text =
"<link rel='stylesheet' href='$this->{puburl}/$text' type='text/css' media='all' />\n";

    return $text;
}

sub renderJS {
    my ( $this, $text ) = @_;

#    $text =~ s/\.min//
#      if ( $this->{debug} );
      
    $text .= '?version=' . $this->{version} if ( $this->{version} =~ '$Rev$' );
    $text =
      "<script type='text/javascript' src='$this->{puburl}/$text'></script>\n".
      "<script type='text/javascript'>jQuery(function(){jQuery('.foswikiTopicText').hallo({
  toolbar: 'halloToolbarFixed',  
  plugins: {
    'halloformat': {},
    'halloheadings': {},
    'hallolists': {},
    'halloreundo': {},
    'hallolink': {}
  }
}).bind('hallodeactivated', function(){return false;});
})</script>\n";
    return $text;
}

1;
