# ---+ Plugins
# ---++ EidoGoPlugin
# **STRING 300 M**
#  the root installation directory of the EidoGo installation (eg. http://<yourserver>/<rootdir>)
$Foswiki::cfg{Plugins}{EidoGoPlugin}{RootDir} = '/eidogo';
# **STRING 300**
#  the styles for the EidoGoPlugin
$Foswiki::cfg{Plugins}{EidoGoPlugin}{Config} = 'theme: "compact", showComments: true, showPlayerInfo: true, showGameInfo: true, showTools: false, showOptions: false, markCurrent: true, markVariations: true, markNext: false, problemMode: false, enableShortcuts: true';
# **STRING 300**
#  Default mode for display: eidogo-player-auto, eidogo-player-problem 
$Foswiki::cfg{Plugins}{EidoGoPlugin}{DefaultMode} = 'eidogo-player-auto';
# **BOOLEAN**
# enable debugging
$Foswiki::cfg{Plugins}{EidoGoPlugin}{Debug} = 0;

1;
