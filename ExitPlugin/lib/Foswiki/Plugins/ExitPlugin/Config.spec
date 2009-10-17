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

# **STRING 200**
# Comma-seperated list of URI schemes to be redirected
$Foswiki::cfg{Plugins}{ExitPlugin}{Schemes} = 'http, https';

# **URL**
# Exit handler
$Foswiki::cfg{Plugins}{ExitPlugin}{RedirectVia} = '$Foswiki::cfg{DefaultUrlHost}$Foswiki::cfg{ScriptUrlPath}/exit?url=';

# **STRING 200**
# Comma-seperated list of hosts for which no exit page should be shown.
$Foswiki::cfg{Plugins}{ExitPlugin}{NoExit} = 'foswiki.org, www.myfoswikihost.com';

# **STRING 200**
# Comma-separated list of webs to redirect links from.<br />
# Use <code>*</code> as wildcard to enable redirection of links in all webs.
$Foswiki::cfg{Plugins}{ExitPlugin}{EnableWebs} = '*';

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
