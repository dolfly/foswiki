# Test for PDF.pm
package PdfTests;
use base qw( FoswikiFnTestCase );

use strict;

use Foswiki::Func;
use Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyBase;
use Foswiki::Contrib::SearchEngineKinoSearchAddOn::Stringifier;

sub set_up {
    my $this = shift;

    $this->SUPER::set_up();
    
    $this->{attachmentDir} = 'attachement_examples/';
    if (! -e $this->{attachmentDir}) {
        #running from foswiki/test/unit
        $this->{attachmentDir} = 'SearchEngineKinoSearchAddOn/attachement_examples/';
    }
}

sub tear_down {
    my $this = shift;
    $this->SUPER::tear_down();
}

sub test_stringForFile {
    my $this = shift;
    my $stringifier = Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyPlugins::PDF->new();

    my $text  = $stringifier->stringForFile($this->{attachmentDir}.'Simple_example.pdf');
    my $text2 = Foswiki::Contrib::SearchEngineKinoSearchAddOn::Stringifier->stringFor($this->{attachmentDir}.'Simple_example.pdf');

    $this->assert(defined($text), "No text returned.");
    $this->assert_str_equals($text, $text2, "PDF stringifier not well registered.");

    my $ok = $text =~ /Adobe/;
    $this->assert($ok, "Text Adobe not included");

    $ok = $text =~ /Äußerung/;
    $this->assert($ok, "Text Äußerung not included");
}

1;
