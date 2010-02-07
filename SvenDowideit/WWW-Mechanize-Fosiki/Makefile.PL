use inc::Module::Install;

name     'WWW-Mechanize-Fosiki';
all_from 'lib/WWW/Mechanize/Fosiki.pm';
author   q{Sven Dowideit <SvenDowideit@home.org.au>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

