# ---+ Directed Graph Plugin 
# Settings for the GraphViz interface.  Generates graphs using the &lt;dot&gt; language
# **PATH M**
# Path to the GraphViz executable. (Must include trailing slash)
$Foswiki::cfg{DirectedGraphPlugin}{enginePath} = '/usr/bin/';
# **PATH M**
# Path to the ImageMagick convert utility. (Must include trailing slash) <br>
#   -  This is used to support antialias output <br> 
#      (Required if GraphViz doesn't have Cario rendering support.)
$Foswiki::cfg{DirectedGraphPlugin}{magickPath} = '/usr/bin/';
# **PATH M**
# Path to the Foswiki tools directory .(Must include trailing slash) <br>
# The DirectedGraphPlugin.pl helper script is found in this directory.
# Typically found in the web server root along with bin, data, pub, etc.
$Foswiki::cfg{DirectedGraphPlugin}{toolsPath} = $Foswiki::cfg{PubDir}/../tools ;
# **PATH M**
# Perl command used on this system <br>
#  On many systems this can just be the "perl" command
$Foswiki::cfg{DirectedGraphPlugin}{perlCmd} = '/usr/bin/perl';
# **PATH**
# Path for plugin to store generated attachments<br>
#  Optional.  If not provided, plugin will manage attachments using the standard Foswiki attachment functions.
#  <b>If not provided, first visit to System.DirectedGraphPlugin will require admin / sudo login for write access, in order to save generated attachments</b>
#  If set to the /pub path, generated attachments will be invisible to Foswiki topics.
#  This directory must be web readable.
$Foswiki::cfg{DirectedGraphPlugin}{attachPath} = '';
# **PATH**
# URL Path for generated attachments <br>
#  Optional.  Only required if attachPath is not the Foswiki pubDir. 
# If not provided, plugin will use the pub directory for linking to attachments.
# If the attachPath is not provided, then this parameter will be ignored.
$Foswiki::cfg{DirectedGraphPlugin}{attachUrlPath} = '';

