# ---+ SetSkinByCookiePlugin
# This is the configuration used by the <b>SetSkinByCookiePlugin</b> and the
# <h2>General</h2>

# **STRING**
# Defines the CookieName which should be inspected to set the skin to
$Foswiki::cfg{Plugins}{SetSkinByCookiePlugin}{CookieName} = 'SetSkin';

# **INTEGER**
# how long should the SetSkin cookie be valid
$Foswiki::cfg{Plugins}{SetSkinByCookiePlugin}{Expire} = 9999999;
