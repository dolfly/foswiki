use inc::Module::Install;

name     'WWW-Mechanize-Foswiki';
all_from 'lib/WWW/Mechanize/Foswiki.pm';
author   q{Sven Dowideit <SvenDowideit@home.org.au>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

