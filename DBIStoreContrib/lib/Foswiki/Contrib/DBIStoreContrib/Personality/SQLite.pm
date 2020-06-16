# See bottom of file for license and copyright information
package Foswiki::Contrib::DBIStoreContrib::Personality::SQLite;

use strict;
use warnings;

use Foswiki::Contrib::DBIStoreContrib::Personality ();
our @ISA = ('Foswiki::Contrib::DBIStoreContrib::Personality');

sub setup {
    my $this = shift;

    # Load PCRE, required for regexes
    $this->{store}->{handle}
      ->do(".load $Foswiki::cfg{Extensions}{DBIStoreContrib}{SQLite}{PCRE}");
}

sub table_exists {
    my $this   = shift;
    my $tables = join( ',', map { "'$_'" } @_ );
    my $sql    = <<SQL;
SELECT name FROM sqlite_master
    WHERE type='table' AND name IN ($tables)
SQL
    my @rows = $this->{store}->{handle}->selectrow_array($sql);

    #print STDERR scalar(@rows)." tables exist of ".scalar(@_)."\n";
    return scalar(@rows);
}

sub regexp {
    my ( $this, $lhs, $op, $rhs ) = @_;
    $rhs =~ s/\\x([0-9a-f]{2})/_char("0x$1")/gei;
    $rhs =~ s/\\x{([0-9a-f]+)}/_char("0x$1")/gei;

    # The macro parser does horrible things with \, causing \\ to become \\\
    # Force it back to \\
    $rhs =~ s/\\{3}/\\\\/g;
    return $this->SUPER::regexp( $lhs, $op, $rhs ) if ( $op eq '~' );
    $rhs =~ s/'/\\'/g;
    return "$lhs REGEXP '$rhs'";
}

1;

__DATA__

Author: Crawford Currie http://c-dot.co.uk

Module of Foswiki - The Free and Open Source Wiki, http://foswiki.org/, http://Foswiki.org/

Copyright (C) 2013 Foswiki Contributors. All Rights Reserved.
Foswiki Contributors are listed in the AUTHORS file in the root
of this distribution. NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.