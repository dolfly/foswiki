# ---+ Extensions
# ---++ SearchEngineKinoSearchAddOn

# **PERL**
# This setting is required to enable executing the kinosearch script from the bin directory
$Foswiki::cfg{SwitchBoard}{kinosearch} = [
          'Foswiki::Contrib::SearchEngineKinoSearchAddOn::Search',
          'searchCgi',
          {
            'kinosearch' => 1
          }
        ];


# **BOOLEAN**
#If using Wiki::Store::SearchAlgorithms::Kino, enable this for SEARCH to also show attachments (Default is false)
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{showAttachments} = 0;


# **BOOLEAN**
# Enable Automatic index updating when topics are modified (Default is false)
# warning: this will slow down save, rename and attach operations.
$Foswiki::cfg{SearchEngineKinoSearchPlugin}{EnableOnSaveUpdates} = 0;


# **SELECT antiword,wv,abiword**
# Select which MS Word indexer to use (you need to have antiword, abiword or wvHtml installed)
# <dl>
# <dt>antiword</dt><dd>is the default, and should be used on Linux/Unix.</dd>
# <dt>wvHtml</dt><dd> is recommended for use on Windows.</dd>
# <dt>abiword</dt><dd></dd>
# </dl>
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{WordIndexer} = 'antiword';

# **PATH**
# Where KinoSearh logs are stored
$Foswiki::cfg{KinoSearchLogDir} = '$Foswiki::cfg{PubDir}/../kinosearch/logs';


# **PATH**
# Where KinoSearh index is stored
$Foswiki::cfg{KinoSearchIndexDir} = '$Foswiki::cfg{PubDir}/../kinosearch/index';

