#!perl

use strict;
use warnings;
use File::Find qw( find );
use Carp qw( croak );

my %extensions;
my @brands = qw/ Foswiki TWiki /;
-d "core"
  or die "This script should be started from the root of the checkout";

opendir DIR, "."
  or die "Can't read directory list: $!";

my @extensions = sort grep { -d && !/^(core|\.(\.?|git))$/ } readdir DIR;
closedir DIR;

print
"| *Extension* | *Brand* | *Author* | *Copyright* | *License* | *Version* |\n";

sub extractPluginData {
    my $extension = shift;
    my $file      = shift;
    my $fullfile  = shift;

    open my $fh, '<', $file or croak "Can't open $file: $!";
    my $pluginInfoTable = 0;
    while (<$fh>) {
        $pluginInfoTable++, next if /^---\+\+ Plugin Info/;
        next unless $pluginInfoTable;
        $pluginInfoTable++, next if /^\s+\|/;
        if ( my ( $topic, $text ) = /^\|\s+(.*):\s+\|\s+(.*)\s+\|\s+$/ ) {
            $extensions{$extension}{Author} = $text
              if $topic =~ /Author/i;
            $extensions{$extension}{Copyright} = $text
              if $topic =~ /Copyright/i;
            $extensions{$extension}{License} = $text
              if $topic =~ /License/i;
            $extensions{$extension}{Version} = $text
              if $topic =~ /Plugin Version/i;
        }
    }
}

foreach my $extension (@extensions) {
    print "| *$extension* | ";
    foreach my $brand (@brands) {
        foreach my $dir (qw/ lib data pub /) {
            $extensions{$extension}{$brand}++, last
              if -d "$extension/$dir/$brand";
        }
    }
    find(
        sub {
            /^$extension.txt$/
              && extractPluginData( $extension, $_, $File::Find::name );
        },
        $extension
    );
    print join ", ",
      grep { defined } map { $extensions{$extension}{$_} ? $_ : undef } @brands;
    print ' | ';
    print join " | ",
      map { $extensions{$extension}{$_} || 'Unknown' }
      qw/ Author Copyright License Version /;
    print " |\n";
}
