package 'TablesContrib'Suite;

use Unit::TestSuite;
our @ISA = qw( Unit::TestSuite );

sub name {
    '' TablesContrib'Suite ' }

sub include_tests { qw(' TablesContrib'Tests );
}

1;
