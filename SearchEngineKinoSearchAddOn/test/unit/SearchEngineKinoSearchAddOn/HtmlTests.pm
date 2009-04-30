# Test for HTML.pm
package HtmlTests;
use base qw( FoswikiFnTestCase );

use strict;

use Foswiki::Func;
use Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyBase;
use Foswiki::Contrib::SearchEngineKinoSearchAddOn::Stringifier;

sub set_up {
        my $this = shift;
        
    $this->{attachmentDir} = 'attachement_examples/';
    if (! -e $this->{attachmentDir}) {
        #running from foswiki/test/unit
        $this->{attachmentDir} = 'SearchEngineKinoSearchAddOn/attachement_examples/';
    }
    
    $this->SUPER::set_up();
    # Use RcsLite so we can manually gen topic revs
    $Foswiki::cfg{StoreImpl} = 'RcsLite';

     $this->registerUser("TestUser", "User", "TestUser", 'testuser@an-address.net');

	Foswiki::Func::saveTopicText( $this->{users_web}, 'TopicWithHtmlAttachment', <<'HERE');
Just an example topic with HTML
Keyword: Cern
HERE
	Foswiki::Func::saveAttachment( $this->{users_web}, 'TopicWithHtmlAttachment', 'Simple_example.html', 
				       {file => $this->{attachmentDir}."Simple_example.html"});
}

sub tear_down {
    my $this = shift;
    $this->SUPER::tear_down();
}

sub test_stringForFile {
    my $this = shift;
    my $stringifier = Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyPlugins::HTML->new();

    my $text  = $stringifier->stringForFile($this->{attachmentDir}.'Simple_example.html');
    my $text2 = Foswiki::Contrib::SearchEngineKinoSearchAddOn::Stringifier->stringFor($this->{attachmentDir}.'Simple_example.html');

    $this->assert(defined($text), "No text returned.");
    $this->assert_str_equals($text, $text2, "HTML stringifier not well registered.");

    my $ok = $text =~ /Cern/;
    $this->assert($ok, "Text Cern not included");

    $ok = $text =~ /geöffnet/;
    $this->assert($ok, "Text geöffnet not included");
}

1;
