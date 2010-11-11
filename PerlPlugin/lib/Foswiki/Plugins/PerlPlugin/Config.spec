# ---+ Extensions
# ---++ PerlPlugin
# This is the configuration used by the <b>PerlPlugin</b>.
# **PERL**
# Control what opcodes are permitted in the safe container.
# See man Opcode for details of opcode names and opsets. The default set
# of permitted opcodes is =:default=. You can add to this
# set using this =Permit= and then remove from it using =Deny=.
$Foswiki::cfg{Plugins}{PerlPlugin}{Opcodes} = {
    Permit => [ ':base_math' ],
    Deny => [] };
# **PERL**
# Symbols to be made available within the container. This is a hash indexed
# on package name, that maps to the names of the symbols within that package
# to be shared with the safe container. The leading type identifier must be
# given on the symbol name. Code within the container will see these symbols
# within its namespace, so you cannot import the same symbol name from
# two different packages.
$Foswiki::cfg{Plugins}{PerlPlugin}{Share} = {
    'Foswiki::Func' => [
        '&getSkin',
        '&getUrlHost',
        '&getScriptUrl',
        '&getPubUrlPath',
        '&getExternalResource',
        '&getCgiQuery',
        '&getSessionKeys',
        '&getSessionValue',
        '&setSessionValue',
        '&clearSessionValue',
        '&getContext',
        '&pushTopicContext',
        '&popTopicContext',
        '&getPreferencesValue',
        '&getPreferencesFlag',
        '&setPreferencesValue',
        '&getWikiToolName',
        '&getMainWebname',
        '&getTwikiWebname',
        '&getDefaultUserName',
        '&getCanonicalUserID',
        '&getWikiName',
        '&getWikiUserName',
        '&wikiToUserName',
        '&userToWikiName',
        '&emailToWikiNames',
        '&wikinameToEmails',
        '&isGuest',
        '&isAnAdmin',
        '&isGroupMember',
        '&eachUser',
        '&eachMembership',
        '&eachGroup',
        '&isGroup',
        '&eachGroupMember',
        '&checkAccessPermission',
        '&getListOfWebs',
        '&webExists',
        '&createWeb',
        '&moveWeb',
        '&eachChangeSince',
        '&getTopicList',
        '&topicExists',
        '&checkTopicEditLock',
        '&setTopicEditLock',
        '&saveTopic',
        '&saveTopicText',
        '&moveTopic',
        '&getRevisionInfo',
        '&getRevisionAtTime',
        '&readTopic',
        '&readTopicText',
        '&attachmentExists',
        '&readAttachment',
        '&saveAttachment',
        '&moveAttachment',
        '&readTemplate',
        '&loadTemplate',
        '&expandTemplate',
        '&writeHeader',
        '&redirectCgiQuery',
        '&addToHEAD',
        '&expandCommonVariables',
        '&renderText',
        '&internalLink',
        '&sendEmail',
        '&wikiToEmail',
        '&expandVariablesOnTopicCreation',
        '&registerTagHandler',
        '&registerRESTHandler',
        '&decodeFormatTokens',
        '&searchInWebContent',
        '&getWorkArea',
        #'&readFile',
        #'&saveFile',
        '&getRegularExpression',
        '&normalizeWebTopicName',
        '&StaticMethod',
        '&spaceOutWikiWord',
        '&writeWarning',
        '&writeDebug',
        '&formatTime',
        '&isTrue',
        '&isValidWikiWord',
        '&extractParameters',
        '&extractNameValuePair',
       ]
    };
