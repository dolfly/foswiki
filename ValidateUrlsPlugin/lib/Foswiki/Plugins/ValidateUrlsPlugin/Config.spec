# ---+ Extensions
# ---++ ValidateUrlsPlugin
# **TEXT**
# restrict the WebExternalURLsReport topics to the following users. defaults to AdminGroup for safety of possibly delicate url's
# set to WikiGuest for public Wiki's
$Foswiki::cfg{Plugins}{ValidateUrlsPlugin}{ReportViewPermission} = 'AdminGroup';

