#!/usr/bin/perl
# See bottom of file for license and copyright information

use strict;
use warnings;
use Storable qw( retrieve nstore );

my $hash_workdir = ".";

#
print "Input directory     => $hash_workdir\n";
my $cntin = 0;

opendir( my $df, "$hash_workdir" ) || die "Can't open $hash_workdir. $!";

foreach my $fn ( grep { /-filehash$/ } readdir($df) ) {

    chomp($fn);
    $cntin++;

    my $hashref  = Storable::retrieve("$hash_workdir/$fn");
    my %tempHash = %$hashref;
    Storable::nstore \%tempHash, "$hash_workdir/$fn";
    print "PROCESSED $fn \n";

}

close $df;

#
# finish up
#
print "   - rewritten hash files: $cntin\n";
1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2013 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

Additional copyrights apply to some or all of the code in this
file as follows:

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
