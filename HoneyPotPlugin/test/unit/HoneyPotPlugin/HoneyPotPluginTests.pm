# See bottom of file for license and copyright information
use strict;
use warnings;

package HoneyPotPluginTests;

use FoswikiTestCase;
our @ISA = qw( FoswikiTestCase );

use strict;
use warnings;
use Foswiki;
use CGI;
use Foswiki::Plugins::HoneyPotPlugin;

my $foswiki;

sub new {
    my $self = shift()->SUPER::new(@_);
    return $self;
}

# Set up the test fixture
sub set_up {
    my $this = shift;

    $this->SUPER::set_up();

    $Foswiki::Plugins::SESSION = $foswiki;
}

sub tear_down {
    my $this = shift;
    $this->SUPER::tear_down();
}

sub test_honeypot {
    my $this = shift;

    # Assume we have a project honeypot registration
    $this->assert( $Foswiki::cfg{Plugins}{HoneyPotPlugin}{APIKey},
        "Must have {Plugins}{HoneyPotPlugin}{APIKey} to run this test" );

    my @tests = (
        '127.0.0.1', '',

        # SIMULATE DIFFERENT TYPES
        '127.1.1.0', 'is_search_engine',
        '127.1.1.1', 'is_suspicious',
        '127.1.1.2', 'is_harvester',
        '127.1.1.3', 'is_harvester',
        '127.1.1.4', 'is_comment_spammer',
        '127.1.1.5', 'is_comment_spammer',
        '127.1.1.6', 'is_harvester',
        '127.1.1.7', 'is_harvester',

        # SIMULATE DIFFERENT THREAT LEVELS
        '127.1.10.1', 'is_suspicious',
        '127.1.20.1', 'is_suspicious',
        '127.1.40.1', 'is_suspicious',
        '127.1.80.1', 'is_suspicious',

        # SIMULATE DIFFERENT NUMBER OF DAYS
        '127.10.1.1', 'is_suspicious',
        '127.20.1.1', 'is_suspicious',
        '127.40.1.1', 'is_suspicious',
        '127.80.1.1', 'is_suspicious',
    );

    for ( my $i = 0 ; $i < scalar(@tests) ; $i += 2 ) {
        $this->assert_equals(
            $tests[ $i + 1 ],
            Foswiki::Plugins::HoneyPotPlugin::check(
                $tests[$i],
                'is_harvester,is_comment_spammer,is_search_engine,is_suspicious'
            )
        );
    }
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: CrawfordCurrie

Copyright (C) 2008-2011 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
