#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::Mechanize::Foswiki' ) || print "Bail out!
";
}

diag( "Testing WWW::Mechanize::Foswiki $WWW::Mechanize::Foswiki::VERSION, Perl $], $^X" );
