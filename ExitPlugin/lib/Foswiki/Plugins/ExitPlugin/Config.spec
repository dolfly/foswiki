# ---+ Extensions
# ---++ ExitPlugin

# **PERL**
# This setting is required to enable executing the exit script from the bin directory
$Foswiki::cfg{SwitchBoard}{exit} = [
          'Foswiki::Plugins::ExitPlugin',
          'exitRedirect',
          {
            'exitredirect' => 1
          }
        ];

# **PERL**
# An array of strings listing the URI schemes to be redirected
$Foswiki::cfg{Plugins}{ExitPlugin}{Schemes} = ['http', 'https'];

# **URL**
# Exit handler
$Foswiki::cfg{Plugins}{ExitPlugin}{RedirectVia} = '$Foswiki::cfg{DefaultUrlHost}$Foswiki::cfg{ScriptUrlPath}/exit?url=';

# **PERL**
# An array of strings listing the hosts for which no exit page should be shown.
$Foswiki::cfg{Plugins}{ExitPlugin}{NoExit} = ['.twiki.org', '.foswiki.org'];

# **STRING 30**
# External link marks (you can use an image if you want). These are optional.
$Foswiki::cfg{Plugins}{ExitPlugin}{Premark} = '';

# **STRING 30**
# External link marks (you can use an image if you want). These are optional.
$Foswiki::cfg{Plugins}{ExitPlugin}{Postmark} = '';

# **BOOLEAN**
# Include the external link marks withing the HREF tag.
$Foswiki::cfg{Plugins}{ExitPlugin}{MarksInLink} = 0;

# **BOOLEAN**
# Debug flag
$Foswiki::cfg{Plugins}{ExitPlugin}{Debug} = 0;

1;
