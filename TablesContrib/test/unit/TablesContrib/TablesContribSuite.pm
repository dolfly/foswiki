package TablesContribSuite;

use Unit::TestSuite;
our @ISA = qw( Unit::TestSuite );

sub name {
    'TablesContribSuite';
}

sub include_tests {
    qw(TablesContribTests);
}

1;
