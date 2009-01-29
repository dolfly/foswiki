# ---+ JQueryCompatibilityModePlugin
# This is the configuration used by the <b>ToPDFPlugin</b> and the
# <h2>General</h2>

# **BOOLEAN**
# Should the window.Foswiki variable be initilazed
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{InitializeFoswikiVar} = 1;


# **BOOLEAN**
# should the Jquery-core api included automatically
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{AutoIncludeCore} = 1;

# **BOOLEAN**
# include JQuery-Dialog api
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{DialogInclude} = 0;


# **BOOLEAN**
# should the default settings for DialogAPI be included? You dont want this if you implemented own dialogs ( and use own skins, handlers )
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{DialogDefaultSettingsInclude} = 1;

# **BOOLEAN**
# Plugin: should be the ajax-upload-plugin be included?
$Foswiki::cfg{Plugins}{JQueryCompatibilityModePlugin}{AjaxUploadPlugin} = 0;





