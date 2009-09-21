# For licensing info read LICENSE file in the Foswiki root.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at 
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyPlugins::DOC_antiword;
use base 'Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyBase';
use File::Temp qw/tmpnam/;

my $antiword = $Foswiki::cfg{SearchEngineKinoSearchAddOn}{antiwordCmd} || 'antiword';

if (!defined($Foswiki::cfg{SearchEngineKinoSearchAddOn}{WordIndexer}) || 
    ($Foswiki::cfg{SearchEngineKinoSearchAddOn}{WordIndexer} eq 'antiword')) {
    # Only if antiword exists, I register myself.
    if (__PACKAGE__->_programExists($antiword)){
        __PACKAGE__->register_handler("application/word", ".doc");
    }
}

sub stringForFile {
    my ($self, $file) = @_;
    
    my $cmd = $antiword . ' %FILENAME|F%';
    my ($output, $exit) = Foswiki::Sandbox->sysCommand($cmd, FILENAME => $file);
    
    return '' unless ($exit == 0);

    return $output;
}

1;
