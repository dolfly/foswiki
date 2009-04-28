#! /bin/echo Need-mod_perl
use strict;
use warnings;

$ENV{MOD_PERL} =~ /mod_perl/
or die "mod_perl.pl called, but mod_perl not used!";

use lib '/home/babar/work/wiki/core/bin';
return require '/home/babar/work/wiki/core/bin/setlib.cfg';

use ModPerl::RegistryLoader;
use File::Spec;

my $binurlbase = '/foswiki/bin'; # must be set by the user
my $binbase = '/home/babar/work/wiki/core/bin'; # must be set by the user
my $registrymodule = 'ModPerl::Registry'; # must be set by the user

my $rl = ModPerl::RegistryLoader->new(
   package => $registrymodule, # must be set by the user
);

chdir $binbase;
$Foswiki::cfg{Engine} = 'Foswiki::Engine::CGI';

foreach my $binscript (<$binbase/*>) {
   my (undef,undef,$scriptname) = File::Spec->splitpath($binscript);
   $scriptname =~ m|^([^/]+)$|;
   my $script = $1;
   if ($script !~ m/configure|register|resetpasswd/) { # don't precompile uncommon commands especially configure which has a ton of unnecessary s***
            $binscript =~ m|^(.+)$|;
            my $bin = $1;
            open BINSCRIPT,'<',$binscript;
            if (<BINSCRIPT> =~ m|^\#\!/usr/bin/perl|) {
                    $rl->handler("$binurlbase/$script", $bin);
            }
            close BINSCRIPT;
   }
}

1;
