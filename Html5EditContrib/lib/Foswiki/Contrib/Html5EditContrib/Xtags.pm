package Foswiki::Contrib::Html5EditContrib::Xtags;
use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin ();
our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

use Foswiki::Plugins::JQueryPlugin::Plugin ();
use Foswiki::Contrib::Html5EditContrib     ();

sub new {
    my $class = shift;
    my $session = shift || $Foswiki::Plugins::SESSION;

    my $this = $class->SUPER::new(
        $session,
        name          => 'xtag',
        version       => $Foswiki::Contrib::Html5EditContrib::RELEASE,
        author        => '(c) 2012 Mozilla',
        homepage      => 'http://x-tag.org',
        puburl        => '%PUBURLPATH%/%SYSTEMWEB%/Html5EditContrib',
        documentation => "$Foswiki::cfg{SystemWebName}.Html5EditContrib",
        summary       => $Foswiki::Contrib::Html5EditContrib::SHORTDESCRIPTION,
        dependencies  => [  ],
        javascript    => ["x-tag/x-tag.js"],
#        css           => ["hallo.css"]
    );

    return $this;
}


1;
