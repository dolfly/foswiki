# Copyright (C) 2009 TWIKI.NET (http://www.twiki.net)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For licensing info read LICENSE file in the Foswiki root.

package Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyPlugins::PPTX;
use base 'Foswiki::Contrib::SearchEngineKinoSearchAddOn::StringifyBase';
use Foswiki::Contrib::SearchEngineKinoSearchAddOn::Stringifier;
use File::Temp qw/tmpnam/;
use Encode;
use CharsetDetector;

my $pptx2txt = $Foswiki::cfg{SearchEngineKinoSearchAddOn}{pptx2txtCmd} || 'pptx2txt.pl';

# Only if ppthtml.pl exists, I register myself.
if (__PACKAGE__->_programExists($pptx2txt)){
    __PACKAGE__->register_handler("text/pptx", ".pptx");
}

sub stringForFile {
    my ($self, $filename) = @_;
    my $tmp_file = tmpnam();

    return '' if (-f $tmp_file);
    
    my $cmd = "$pptx2txt '$filename' $tmp_file 2>/dev/null";
    my ($output, $exit) = Foswiki::Sandbox->sysCommand($cmd);
    
    return '' unless ($exit == 0);
  
    my $in;
    open $in, $tmp_file or return "";
    my $text = "";
   
     while (<$in>) {
        chomp;

        my $charset = CharsetDetector::detect1($_);
        my $aux_text = "";
        if ($charset =~ "utf") {
            $aux_text = encode("iso-8859-15", decode($charset, $_));
            $aux_text = $_ unless($aux_text);
        } else {
            $aux_text = $_;
        }
        $text .= " " . $aux_text;
    }

    close($in);
    unlink($tmp_file);
    
    return $text;
}

1;
