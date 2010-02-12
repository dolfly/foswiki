# ---+ Extensions
# ---++ StringifierContrib

# **STRING**
# Comma seperated list of webs to skip
$Foswiki::cfg{StringifierContrib}{SkipWebs} = 'Trash';

# **STRING**
# List of topics to skip.
# Topics can be in the form of Web.MyTopic, or if you want a topic to be excluded from all webs just enter MyTopic.
# For example: Main.WikiUsers, WebStatistics
$Foswiki::cfg{StringifierContrib}{SkipTopics} = '';

# **SELECT antiword,wv,abiword**
# Select which MS Word indexer to use (you need to have antiword, abiword or wvHtml installed)
# <dl>
# <dt>antiword</dt><dd>is the default, and should be used on Linux/Unix.</dd>
# <dt>wvHtml</dt><dd> is recommended for use on Windows.</dd>
# <dt>abiword</dt><dd></dd>
# </dl>
$Foswiki::cfg{StringifierContrib}{WordIndexer} = 'antiword';

# **COMMAND**
# abiword command
$Foswiki::cfg{StringifierContrib}{abiwordCmd} = 'abiword';

# **COMMAND**
# antiword command
$Foswiki::cfg{StringifierContrib}{antiwordCmd} = 'antiword';

# **COMMAND**
# wvHtml command
$Foswiki::cfg{StringifierContrib}{wvHtmlCmd} = 'wvHtml';

# **COMMAND**
# ppthtml command
$Foswiki::cfg{StringifierContrib}{ppthtmlCmd} = 'ppthtml';

# **COMMAND**
# pdftotext command
$Foswiki::cfg{StringifierContrib}{pdftotextCmd} = 'pdftotext';

# **COMMAND**
# pptx2txt.pl command
$Foswiki::cfg{StringifierContrib}{pptx2txtCmd} = '../tools/pptx2txt.pl';

# **COMMAND**
# docx2txt.pl command
$Foswiki::cfg{StringifierContrib}{docx2txtCmd} = '../tools/docx2txt.pl';

# **COMMAND**
# xlsx2txt.pl command
$Foswiki::cfg{StringifierContrib}{xls2txtCmd} = '../tools/xls2txt.pl';

# **BOOLEAN**
# Debug setting
$Foswiki::cfg{StringifierContrib}{Debug} = '0';

1;
