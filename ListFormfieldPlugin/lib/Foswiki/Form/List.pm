# See bottom of file for license and copyright information
package Foswiki::Form::List;

use strict;
use warnings;

use Assert;
use Foswiki::Form::ListFieldDefinition ();
our @ISA = ('Foswiki::Form::FieldDefinition');

sub new {
    my ( $class, @args ) = @_;
    my %attrs = @args;
    my $type;

    $attrs{type} =~ /^list\+(\w+)/;
    $type = $1;

    # Ripped off from Foswiki::Form
    # The untaint is required for the validation *and* the ucfirst, which
    # retaints when use locale is in force
    my $fieldClass = Foswiki::Sandbox::untaint(
        $type,
        sub {
            my $theClass = shift;

            # E.g. list+checkbox
            $theClass =~ /^(\w+)/;    # cut off +buttons etc
            return 'Foswiki::Form::' . ucfirst($1);
        }
    );

    if ( not eval 'require ' . $fieldClass . '; 1;' or $@ ) {

        # Type not available; use base type
        require Foswiki::Form::FieldDefinition;
        $fieldClass = 'Foswiki::Form::FieldDefinition';
    }

    return $fieldClass->new(
        session => $Foswiki::Plugins::SESSION,
        type    => $type,
        @args
    );
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2011 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

Additional copyrights apply to some or all of the code in this
file as follows:

Copyright (C) 2005-2007 TWiki Contributors. All Rights Reserved.
TWiki Contributors are listed in the AUTHORS file in the root
of this distribution.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
