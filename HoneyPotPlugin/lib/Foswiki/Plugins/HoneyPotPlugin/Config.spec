# ---+ Extensions
# ---++ HoneyPotPlugin
# **STRING 40**
# Your Project Honeypot http:BL API key (if you have one; if not, register at <a href='http://www.projecthoneypot.org'>http://www.projecthoneypot.org</a> and get one). Leave blank if honeypot checking is not required.
$Foswiki::cfg{Plugins}{HoneyPotPlugin}{APIKey}  = '';

# **PERL**
# Lists of conditions to test against the honeypot for different actions e.g.
# view, attach, save, edit. Each list is a list of names of predicates e.g.
# <tt>is_comment_spammer,is_suspicious</tt>. Visit <a href='http://search.cpan.org/dist/WWW-Honeypot-httpBL/lib/WWW/Honeypot/httpBL.pm'>http://search.cpan.org/dist/WWW-Honeypot-httpBL/lib/WWW/Honeypot/httpBL.pm</a>
# for more details on the available predicates. If the IP address of the
# source of the save request triggers any of these predicates, then the
# save will be rejected.
$Foswiki::cfg{Plugins}{HoneyPotPlugin}{Conditions} = {
    'save' => [ 'is_comment_spammer', 'is_suspicious' ],
    'attach' => [ 'is_comment_spammer', 'is_suspicious' ],
    'view' => [ 'is_harvester' ],
    'edit' => [ 'is_search_engine', 'is_harvester', 'is_suspicious' ],
    'rest' => [ 'is_comment_spammer', 'is_search_engine', 'is_harvester', 'is_suspicious' ],
};
