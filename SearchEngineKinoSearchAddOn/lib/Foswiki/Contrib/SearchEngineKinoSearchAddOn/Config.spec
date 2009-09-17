# ---+ Extensions
# ---++ SearchEngineKinoSearchAddOn

# **STRING**
# Comma seperated list of webs to skip
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipWebs} = 'Trash, Sandbox';

# **STRING**
# Comma seperated list of extenstions to index
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{IndexExtensions} = '.txt, .html, .xml, .doc, .docx, .xls, .xlsx, .ppt, .pptx, .pdf';

# **STRING**
# List of attachments to skip
# For example: Web.SomeTopic.AnAttachment.txt, Web.OtherTopic.OtherAttachment.pdf
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipAttachments} = '';

# **STRING**
# List of topics to skip.
# Topics can be in the form of Web.MyTopic, or if you want a topic to be excluded from all webs just enter MyTopic.
# For example: Main.WikiUsers, WebStatistics
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{SkipTopics} = '';

# **STRING**
# User language setting for KinoSearch
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{UserLanguage} = 'en';

# **NUMBER**
# Summary length
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{SummaryLength} = '300';

# **NUMBER**
# Absolute maximum limit for a search
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{MaxLimit} = '2000';

# **BOOLEAN**
# Search attachments only
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{SearchAttachmentsOnly} = '0';

# **SELECT antiword,wv,abiword**
# Select which MS Word indexer to use (you need to have antiword, abiword or wvHtml installed)
# <dl>
# <dt>antiword</dt><dd>is the default, and should be used on Linux/Unix.</dd>
# <dt>wvHtml</dt><dd> is recommended for use on Windows.</dd>
# <dt>abiword</dt><dd></dd>
# </dl>
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{WordIndexer} = 'antiword';

# **COMMAND**
# abiword command
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{abiwordCmd} = 'abiword';

# **COMMAND**
# antiword command
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{antiwordCmd} = 'antiword';

# **COMMAND**
# wvHtml command
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{wvHtmlCmd} = 'wvHtml';

# **COMMAND**
# ppthtml command
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{ppthtmlCmd} = 'ppthtml';

# **COMMAND**
# pdftotext command
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{pdftotextCmd} = 'pdftotext';

# **COMMAND**
# pptx2txt.pl command
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{pptx2txtCmd} = 'pptx2txt.pl';

# **COMMAND**
# docx2txt.pl command
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{docx2txtCmd} = 'docx2txt.pl';

# **BOOLEAN**
#If using Foswiki::Store::SearchAlgorithms::Kino, enable this for SEARCH to also show attachments (Default is false)
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{showAttachments} = 0;

# **BOOLEAN**
# Enable Automatic index updating when topics are modified (Default is false)
# Warning: this will slow down save, rename and attach operations.
$Foswiki::cfg{SearchEngineKinoSearchPlugin}{EnableOnSaveUpdates} = 0;

# **PATH**
# Where KinoSearh logs are stored
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{LogDirectory} = '$Foswiki::cfg{PubDir}/../kinosearch/logs';

# **PATH**
# Where KinoSearh index is stored
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{IndexDirectory} = '$Foswiki::cfg{PubDir}/../kinosearch/index';

# **BOOLEAN**
# Debug setting
$Foswiki::cfg{SearchEngineKinoSearchAddOn}{Debug} = '0';

# **PERL H**
# This setting is required to enable executing the kinosearch script from the bin directory
$Foswiki::cfg{SwitchBoard}{kinosearch} = [
          'Foswiki::Contrib::SearchEngineKinoSearchAddOn::Search',
          'searchCgi',
          {
            'kinosearch' => 1
          }
        ];
