# ---+ Extensions
# ---++ FootNotePlugin

# **STRING 1**
# Default label numbering format.
$Foswiki::cfg{Plugins}{FootNotePlugin}{LabelFormat} = '1';

# **STRING 30**
# Footnote content section header.
$Foswiki::cfg{Plugins}{FootNotePlugin}{Header} = 'Notes';

# **STRING 30**
# Footnote content section footer.
$Foswiki::cfg{Plugins}{FootNotePlugin}{Footer} = '---';

# **STRING 50**
# Full URL of the CSS to use to format footnotes.
$Foswiki::cfg{Plugins}{FootNotePlugin}{CSS} = '%PUBURLPATH%/%SYSTEMWEB%/FootNotePlugin/styles.css';

# **BOOLEAN**
# Debug flag
$Foswiki::cfg{Plugins}{FootNotePlugin}{Debug} = 0;

1;
