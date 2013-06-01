# ---+ Extensions
# ---++ IpToUserMappingPlugin
# **PERL EXPERT**
# A hash mapping ip addresses to user logins
#the  hash key (ip address) and login field are mandatory, the wikiname entry is useful if the user is not in the 
# main usermapping system but needs to be given a preference setting (like SKIN=plain)
$Foswiki::cfg{IpToUserMappingPlugin}{Mapping} = {
    '192.168.1.220' => {login=>'one', wikiname=>'OneUser'},
    };


