

# ---+ User Managers
# ---++ phpBB3 User Manager
# to use PhpBB3UserMapping, you need to set the following settings in the "Security Setup" above
# <ol><li>
# UserMappingManager = 'Foswiki::Users::PhpBB3UserMapping';
# </li><li>
# SuperAdminGroup = 'Super Administrator';
# </li><li>
# LoginManager = 'Foswiki::LoginManager::PhpBB3Login'; - (This setting will allow TWiki to use the 'stay logged in' cookie that phpBB3 makes.)
# </li></ol>
# **STRING 50**
# The DSN to connect to the phpBB3 Database.
$Foswiki::cfg{Plugins}{PhpBB3User}{DBI_dsn} = 'dbi:mysql:phpBB3_db:localhost';
# **STRING 25**
# The user to connect to the phpBB3 Database.
$Foswiki::cfg{Plugins}{PhpBB3User}{DBI_username} = 'mysqlpassword';
# **PASSWORD**
# The password to connect to the phpBB3 Database.
$Foswiki::cfg{Plugins}{PhpBB3User}{DBI_password} = 'pwd';
