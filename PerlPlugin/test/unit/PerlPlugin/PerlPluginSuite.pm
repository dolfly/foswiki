package PerlPluginSuite;

use strict;
use Unit::TestSuite;
our @ISA = 'Unit::TestSuite';

sub include_tests { return 'PerlPluginTests' }

1;
