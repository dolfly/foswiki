# ---+ Extensions
# ---++ TweetOnSavePlugin
# This plugin sends a status update to twitter on each save or
# topic creation.

# **STRING,M**
# Specify the template to use for status updates, $user will be replaced by the username, $action by either 'saved' or 'created', $web by the web, $topic by the topic name, $url with the (possibly shortened) url
$Foswiki::cfg{Plugins}{TweetOnSavePlugin}{Template} = '$user $action topic $web.$topic $url';

# **STRING**
# A comma-seperated list of webs for which no updates will be done (optional)
$Foswiki::cfg{Plugins}{TweetOnSavePlugin}{ExcludeWebs} = '';

# **STRING,M**
# Specify the username for the twitter account
$Foswiki::cfg{Plugins}{TweetOnSavePlugin}{StatusUser} = '';

# **STRING,M**
# Specify the password for the twitter account
$Foswiki::cfg{Plugins}{TweetOnSavePlugin}{StatusPassword} = '';

# **STRING**
# Optionally, specify a bit.ly username
$Foswiki::cfg{Plugins}{TweetOnSavePlugin}{BitlyUser} = '';

# **STRING**
# Optionally, specify a bit.ly API key
$Foswiki::cfg{Plugins}{TweetOnSavePlugin}{BitlyKey} = '';

