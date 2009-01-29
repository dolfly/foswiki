# ---+ JQueryCompatibilityModePlugin
# This is the configuration used by the <b>ToPDFPlugin</b> and the
# <h2>General</h2>

# **BOOLEAN**
# Should the window.Foswiki variable be initilazed
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{InitializeFoswikiVar} = 1;


# **BOOLEAN**
# auto-include the Jquery-core
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{AutoIncludeCore} = 1;

# **STRING**
# JQuery-UI theme name
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{UITheme} = "base";

# **BOOLEAN**
# auto-include JQuery-UI theme
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{ThemeInclude} = "1";

# **BOOLEAN**
# auto-include JQuery-Dialog api
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{DialogInclude} = 0;

# **BOOLEAN**
# auto-include the default settings for DialogAPI? You dont want this if you implemented own dialogs ( and use handlers )
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{DialogDefaultSettingsInclude} = 1;

# **BOOLEAN**
# Plugin: should be the ajax-upload-plugin be included?
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{AjaxUploadPlugin} = 0;





