# ---+ Extensions
# ---++ KinoSearchPlugin

# **BOOLEAN**
# If true, the index will be updated when a topic is saved, or when an attachment is attached.
# WARNING: this can cause topic saves and attachments to become unacceptably slow, as the index update happens before the browser operation has completed. 
$Foswiki::cfg{Plugins}{KinoSearchPlugin}{EnableOnSaveUpdates} = '0';

# **BOOLEAN**
# Debug setting
$Foswiki::cfg{Plugins}{KinoSearchPlugin}{Debug} = '0';
