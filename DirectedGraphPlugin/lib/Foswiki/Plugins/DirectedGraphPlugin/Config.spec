# ---+ Extensions
# ---++ Directed Graph Plugin 
# Settings for the Directed Graph Plugin.  This plugin generates graphs using the &lt;dot&gt; language.
# Note that <b>Expert Settings</b> are available to override the storage location for attachments. Press the 
# button at the top of this page to access expert settings.
# **PATH**
# Path to the GraphViz executable.  On many systems this is not required if the GraphViz executables are on the default path
$Foswiki::cfg{Plugins}{DirectedGraphPlugin}{enginePath} = '';
# **PATH**
# Path to the ImageMagick convert utility.  <br>
#   -  This is used to support antialias output <br> 
#      (Required if GraphViz doesn't have Cairo rendering support.)
$Foswiki::cfg{Plugins}{DirectedGraphPlugin}{magickPath} = '';
# **PATH**
# Path to the Foswiki tools directory . <br>
# The DirectedGraphPlugin.pl helper script is found in this directory.
# Typically found in the web server root along with bin, data, pub, etc.
# If not provided the plugin will guess based upon the current working directory
$Foswiki::cfg{Plugins}{DirectedGraphPlugin}{toolsPath} = '';
# **PATH M**
# Perl command used on this system <br>
#  On many systems this can just be the "perl" command
$Foswiki::cfg{Plugins}{DirectedGraphPlugin}{perlCmd} = 'perl';
# **PATH EXPERT**
# Path for plugin to store generated attachments<br>
#  Optional.  If not provided, plugin will manage attachments using the standard Foswiki attachment functions.
#  If not provided, first visit to System.DirectedGraphPlugin will require admin / sudo login for write access, in order to save generated attachments.
#  If set to the /pub path, generated attachments will be invisible to Foswiki topics.
#  This directory must be web readable.  <b>If not set to /pub, web server changes will be required to enable access.</b>
$Foswiki::cfg{Plugins}{DirectedGraphPlugin}{attachPath} = '';
# **PATH EXPERT**
# URL Path for generated attachments <br>
#  Optional.  Only required if attachPath is not the Foswiki pubDir. 
# If not provided, plugin will use the pub directory for linking to attachments.
# If the attachPath is not provided, then this parameter will be ignored.
$Foswiki::cfg{Plugins}{DirectedGraphPlugin}{attachUrlPath} = '';

