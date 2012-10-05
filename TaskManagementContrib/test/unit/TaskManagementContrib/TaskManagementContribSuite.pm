package TaskManagementContribSuite;

use Unit::TestSuite;
our @ISA = qw( Unit::TestSuite );

sub name { 'TaskManagementContribSuite' }

sub include_tests { qw(TaskManagementContribTests) }

1;
