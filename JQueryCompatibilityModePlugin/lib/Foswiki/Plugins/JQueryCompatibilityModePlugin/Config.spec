# ---+ JQueryCompatibilityModePlugin
# This is the configuration used by the <b>JQueryCompatibilityModePlugin</b> and the
# <h2>JQuery Core</h2>

# **BOOLEAN**
# Should the window.Foswiki variable be initilazed
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{InitializeFoswikiVar} = 1;


# **BOOLEAN**
# auto-include the Jquery-core
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{AutoIncludeCore} = 1;

# <h2>JQuery UI</h2>
# **STRING**
# JQuery-UI theme name
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{UITheme} = "base";

# **BOOLEAN**
# auto-include JQuery-UI theme
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{ThemeInclude} = "1";

# <h2>Foswiki DialogAPI</h2>
# **BOOLEAN**
# auto-include JQuery-Dialog api
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{DialogInclude} = 0;

# **BOOLEAN**
# auto-include the default settings for DialogAPI? You dont want this if you implemented own dialogs ( and use handlers )
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{DialogDefaultSettingsInclude} = 1;

# <h2>JQuery Plugins</h2>
# **BOOLEAN**
# Plugin: should be the ajax-upload-plugin be included?
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{IncludePlugins} = 0;

# **STRING**
# All JQuery files to include. A comma seperate list,relativ to pub/System/JQueryCompatibiltyPlugin. 
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{AutoIncludeFiles} = "plugins/jquery.ajax_upload.min.js,plugins/mbMenu.min.js";




