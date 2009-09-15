# Test for KinoSearch
package KinoSearchTests;
use base qw( FoswikiFnTestCase );

use strict;

use Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch;

sub test_new {
    my $this = shift;

    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");
    $this->assert(defined($ks), "KinoSearch object not created");
    $this->assert(defined($ks->{Log}), "Log} stream not opened");
    
    $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("update");
    $this->assert(defined($ks), "KinoSearch object not created");
    $this->assert(defined($ks->{Log}), "Log} stream not opened");

    $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("search");
    $this->assert(defined($ks), "KinoSearch object not created");
    $this->assert(!defined($ks->{Log}), "Log} stream must not be opened");
}

sub test_logDirName {
    my $this = shift;

    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{LogDirectory}="";

    my $dir = Foswiki::Func::getPubDir();
    $dir .="/../kinosearch/logs";
    $this->assert_str_equals( $dir, $ks->logDirName(), "Bad default log dir");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{LogDirectory}="dummy";
    $this->assert_str_equals( "dummy", $ks->logDirName(), "Bad configured log dir");
}

sub test_indexPath {
    my $this = shift;

    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{IndexDirectory}="";
    my $dir = Foswiki::Func::getPubDir();
    $dir .="/../kinosearch/index";
    $this->assert_str_equals( $dir, $ks->indexPath(), "Bad default index dir");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{IndexDirectory}="dummy";
    $this->assert_str_equals( "dummy", $ks->indexPath(), "Bad configured index dir");
}

sub test_pubPath {
    my $this = shift;

    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    my $dir = Foswiki::Func::getPubDir(); 
    $this->assert_str_equals( $dir, $ks->pubPath(), "Bad pub path.")
}

sub test_skipWebs {
    my $this = shift;
    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    my @default_webs = ("Trash", "Sandbox");
    my @config_webs  = ("web1", "web2");
    my $a_web;

    # check default webs setting
    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs}="";
    my %webs = $ks->skipWebs();
    foreach $a_web (@default_webs) {
	$this->assert($webs{$a_web}, "Web $a_web not skipped in default.")
	}

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs} = "web1, web2";
    %webs = $ks->skipWebs();
    foreach $a_web (@config_webs) {
	$this->assert($webs{$a_web}, "Web $a_web not skipped in config.")}

    # Now let's try some different writings of the list
    # Just a comma, no space
    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs} = "web1,web2";
    %webs = $ks->skipWebs();
    foreach $a_web (@config_webs) {
	$this->assert($webs{$a_web}, "Web $a_web not skipped in config (comma, no space).")}

    # Just additional spaces
    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs} = "web1,   web2";
    %webs = $ks->skipWebs();
    foreach $a_web (@config_webs) {
	$this->assert($webs{$a_web}, "Web $a_web not skipped in config (additional spaces).")}

    # Only space
    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs} = "web1 web2";
    %webs = $ks->skipWebs();
    foreach $a_web (@config_webs) {
	$this->assert($webs{$a_web}, "Web $a_web not skipped in config (only space).")}

    # Many spaces
    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs} = "web1    web2";
    %webs = $ks->skipWebs();
    foreach $a_web (@config_webs) {
	$this->assert($webs{$a_web}, "Web $a_web not skipped in config (many space).")}

    # Spaces before comma
    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs} = "web1  ,  web2";
    %webs = $ks->skipWebs();
    foreach $a_web (@config_webs) {
	$this->assert($webs{$a_web}, "Web $a_web not skipped in config (many space).")}
}

sub test_skipAttachments {
    my $this = shift;
    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    my @config_atts  = ("att1", "att2");
    my $a_att;

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipAttachments} = "";
    my %atts = $ks->skipAttachments();
    my $num = %atts;
    $this->assert($num == 0, "List of skipped attachments not empty. : $num");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipAttachments} = "att1, att2";
    %atts = $ks->skipAttachments();
    foreach $a_att (@config_atts) {
	$this->assert($atts{$a_att}, "Attachment $a_att not skipped in config.")
	}
}

sub test_indexExtensions {
    my $this = shift;
    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");
    
    my @default_exts = ('.txt', '.html', '.xml', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.pdf');
    my @config_exts  = (".ext1", ".ext2");
    my $a_ext;

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{IndexExtensions} = "";
    my %exts = $ks->indexExtensions();
    foreach $a_ext (@default_exts) {
	$this->assert($exts{$a_ext}, "Extension $a_ext not set.")
	}

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{IndexExtensions} = ".ext1, .ext2";
    %exts = $ks->indexExtensions();
    foreach $a_ext (@config_exts) {
	$this->assert($exts{$a_ext}, "Extension $a_ext not set in config.")
	}
}

sub test_analyserLanguage {
    my $this = shift;
    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{UserLanguage} = "";
    my $lang = $ks->analyserLanguage();
    $this->assert_str_equals('en', $lang, "Default language not O.K.");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{UserLanguage} = "de";
    $lang = $ks->analyserLanguage();
    $this->assert_str_equals('de', $lang, "Configured language not O.K.");
}

sub test_summaryLength {
    my $this = shift;
    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SummaryLength} = "";
    my $lenth = $ks->summaryLength();
    $this->assert(300 == $lenth, "Default length not O.K.");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{SummaryLength} = 299;
    $lenth = $ks->summaryLength();
    $this->assert(299 == $lenth, "Configured length not O.K.");
}

sub test_debugPref {
    my $this = shift;
    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{Debug} = 0;
    my $deb = $ks->debugPref();
    $this->assert(!$deb, "Debug not false on default");

    $Foswiki::cfg{SearchEngineKinoSearchAddOn}{Debug} = 1;
    $deb = $ks->debugPref();
    $this->assert($deb, "Debug not true on configuration");
}

sub test_analyser {
    my $this = shift;
    my $ks = new Foswiki::Contrib::SearchEngineKinoSearchAddOn::KinoSearch("index");

    my $analyser = $ks->analyser('de');
    $this->assert(defined($analyser), "Analyser not created.");
}

1;
