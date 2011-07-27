# See bottom of file for default license and copyright information

=begin TML

---+ package Foswiki::Plugins::ListFormfieldPlugin::Core

=cut

package Foswiki::Plugins::ListFormfieldPlugin::Core;

use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version
use Foswiki::Form();

sub beforeSaveHandler {
    my ( $text, $topic, $web, $topicObject ) = @_;
    my $formmeta = $topicObject->get('FORM');

    if ( defined $formmeta and $formmeta->{name} ) {
        my ( $formWeb, $formTopic ) =
          Foswiki::Func::normalizeWebTopicName( $web, $formmeta->{name} );
        my $formDef = Foswiki::Form->new( $Foswiki::Plugins::SESSION, $formWeb,
            $formTopic );

        if ( $formDef and $formDef->getFields() ) {
            my $fieldcount = 1;
            foreach my $def ( @{ $formDef->getFields() } ) {
                if ( $def->{type} =~ /^list/ ) {
                    parseField( $topicObject, $def->{name}, $fieldcount );
                    $fieldcount += 1;
                }
            }
        }
    }
    return;
}

sub parseField {
    my ( $topicObject, $fieldName, $fieldcount ) = @_;
    my $field = $topicObject->get( 'FIELD', $fieldName );
    my $keyseq = 1;

    if ( $field and $field->{value} ) {
        foreach my $item ( split( /\s*,\s*/, $field->{value} ) ) {
            $topicObject->putKeyed(
                'LISTITEM',
                {
                    name   => $fieldcount - 1 + $keyseq,
                    key    => $fieldName,
                    keyseq => $keyseq,
                    value  => $item
                }
            );
            $keyseq += 1;
        }
    }

    return;
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: Paul.W.Harvey@csiro.au, TRIN http://trin.org.au

Copyright (C) 2011-2011 Foswiki Contributors. Foswiki Contributors
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
