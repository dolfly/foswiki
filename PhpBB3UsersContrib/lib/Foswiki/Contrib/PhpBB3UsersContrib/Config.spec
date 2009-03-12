# ---+ User Managers
# ---++ phpBB3 User Manager
# to use PhpBB3UserMapping, you need to set the following settings in the "Security setup" above
# <ol><li>
# UserMappingManager = 'Foswiki::Users::PhpBB3UserMapping'
# </li><li>
# SuperAdminGroup = 'ADMINISTRATORS'
# </li><li>
# LoginManager = 'Foswiki::LoginManager::PhpBB3Login' (This setting will allow Foswiki to use the 'stay logged in' cookie that phpBB provides.)
# </li></ol>
# **STRING 50**
# The DSN to connect to the phpBB3 Database.
$Foswiki::cfg{Plugins}{PhpBB3User}{DBI_dsn} = 'dbi:mysql:phpBB:localhost';
# **STRING 25**
# The user to connect to the phpBB3 Database.
$Foswiki::cfg{Plugins}{PhpBB3User}{DBI_username} = 'mysql_user';
# **PASSWORD**
# The password to connect to the phpBB3 Database.
$Foswiki::cfg{Plugins}{PhpBB3User}{DBI_password} = 'mysql_password';
