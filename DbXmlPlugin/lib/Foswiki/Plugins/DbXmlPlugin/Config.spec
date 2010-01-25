# ---+ DbXml settings
# This is the configuration used by the <b>DbXmlPlugin</b>.

# **BOOLEAN**
# Turn on/off debugging in debug.txt
$Foswiki::cfg{Plugins}{DbXmlPlugin}{Debug} = 0;

# **BOOLEAN**
# Should the =debug_rawxml= function be exported by the REST interface? 
# This function shows the XML representation of any given topic. 
# For security reasons you may want to disable this.
$Foswiki::cfg{Plugins}{DbXmlPlugin}{AllowRaw} = 0;

# **STRING**
# Include Webs (=default= means all but Sandbox, Trash and Template webs)
$Foswiki::cfg{Plugins}{DbXmlPlugin}{IncludeWeb} = 'default';
