# See bottom of file for default license and copyright information

=begin TML

---+ package TinyMCETableToolsPlugin::Core

=cut

package Foswiki::Plugins::TinyMCETableToolsPlugin::Core;

use strict;
use warnings;

use Foswiki::Func();

=begin TML

---++ setup()

=cut

sub setup {
    my @plugin_ensure  = qw(tabletools);
    my @plugin_prefs   = qw(MCEPLUGINS ADDITIONAL_MCEPLUGINS);
    my $plugin_near    = 'table';
    my @buttons_ensure = qw(tabletoolscopy tabletoolsclean);
    my @buttons_prefs  = (
        qw(BUTTONS1 BUTTONS2 BUTTONS3),
        qw(ADDITIONAL_BUTTONS1 ADDITIONAL_BUTTONS2 ADDITIONAL_BUTTONS3)
    );
    my $buttons_near = 'tablecontrols';

    _ensure( \@plugin_ensure,  \@plugin_prefs,  $plugin_near );
    _ensure( \@buttons_ensure, \@buttons_prefs, $buttons_near );

    return;
}

# Ensure that items in $ensurelist appear in the values of $preflist,
# and if not, insert them into whatever preference contains $ensurenear.
# Magically, if the preferences aren't set, then pull them from topic sections
sub _ensure {
    my ( $ensurelist, $preflist, $ensurenear ) = @_;
    my %prefs      = ();   # preference values (keyed from $preflist)
    my @absentlist = ();   # $ensurelist items not appearing in $preflist values
    my $target_pref;       # The pref var to insert into

    foreach my $pref ( @{$preflist} ) {
        $prefs{$pref} = _getPref($pref);
    }
    $target_pref = _contains( $ensurenear, \%prefs );

    # No point continuing if missing $near occurance to insert next to
    if ($target_pref) {
        my $setpref = $prefs{$target_pref};
        foreach my $item ( @{$ensurelist} ) {
            if ( not _contains( $item, \%prefs ) ) {
                push( @absentlist, $item );
            }
        }
        print STDERR "before, $target_pref is $setpref ensuring $ensurenear";
        foreach my $item (@absentlist) {
            $setpref =~ s/$ensurenear/$ensurenear, $item/;
        }
        print STDERR "after, $target_pref is $setpref";
        Foswiki::Func::setPreferencesValue( 'TINYMCEPLUGIN_' . $target_pref,
            $setpref );
    }

    return ( $target_pref and 1 );
}

# Try to get a TinyMCEPlugin preference value; if not set, then try to get the
# default from TinyMCEPlugin's INIT_TOPIC via the equivalent topic section
sub _getPref {
    my ($pref) = @_;
    my $preftopic =
      Foswiki::Func::getPreferencesValue('TINYMCEPLUGIN_INIT_TOPIC')
      || $Foswiki::cfg{SystemWebName} . '.TinyMCEPlugin';
    my $value = Foswiki::Func::getPreferencesValue( 'TINYMCEPLUGIN_' . $pref )
      || Foswiki::Func::expandCommonVariables(<<"HERE");
%INCLUDE{"$preftopic" section="$pref" warn="off"}%\\
HERE

    return $value;
}

# Check if \b$something\b is contained in a $list (hash). If it is, then return
# the key for the first occurance in which it was found.
sub _contains {
    my ( $something, $list ) = @_;
    my $found = 0;

    while ( ( my ( $key, $value ) = each %{$list} ) and ( not $found ) ) {
        if ( $value =~ /\b$something\b/ ) {
            $found = $key;
        }
    }

    return $found;
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2010 Paul.W.Harvey@csiro.au, http://trin.org.au

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
