#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::Mechanize::Fosiki' ) || print "Bail out!
";
}

diag( "Testing WWW::Mechanize::Fosiki $WWW::Mechanize::Fosiki::VERSION, Perl $], $^X" );
