# ---+ Extensions
# ---++ OEmbedPlugin
# This is the configuration used by the <b>OEmbedPlugin</b>.

# **STRING**
# To use embed.ly as an oEmbed gateway, you'll have to register and copy-paste the api-key in here.
# Otherwise embed.ly providers won't be available.
$Foswiki::cfg{OEmbedPlugin}{EmbedlyKey} = '';

# **PERL**
# List of providers and their oEmbed API endpoints.
# See http://oembed.com/ and http://embed.ly for more.
$Foswiki::cfg{OEmbedPlugin}{Providers} = {
  CollegeHumor => {
    url => 'http://www.collegehumor.com/video/*',
    api => 'http://www.collegehumor.com/oembed.json',
  },

  Jest => {
    url => 'http://www.jest.com/video/*',
    api => 'http://www.jest.com/oembed.json',
  },

  Flickr => {
    url => 'http://*.flickr.com/*',
    api => 'http://www.flickr.com/services/oembed/',
  },

  Hulu => {
    url => 'http://www.hulu.com/watch/*',
    api => 'http://www.hulu.com/api/oembed.json',
  },
 
  Viddler => {
    url => 'http://www.viddler.com/v/*',
    api => 'http://www.viddler.com/oembed/',
  },

  Vimeo => {
    url => ['http://vimeo.com/*', 'http://vimeo.com/groups/*/videos/*'],
    api => 'http://vimeo.com/api/oembed.json',
  },
 
  Qik => {
    url => 'http://qik.com/video/*',
    api => 'http://qik.com/api/oembed.json',
  },

  Revision3 => {
    url => 'http://revision3.com/*',
    api => 'http://revision3.com/api/oembed/',
  },
 
  Ted => {
    url => 'http://www.ted.com/talks/*',
    api => 'http://www.ted.com/talks/oembed.json',
  },
 
  Youtube => {
    url => ['http://*.youtube.com/*', 'https://*.youtube.com/*'],
    api => 'http://www.youtube.com/oembed',
  },

  PollEverywhere => {
    url => ['http://www.polleverywhere.com/polls/*', 'http://www.polleverywhere.com/multiple_choice_polls/*', 'http://www.polleverywhere.com/free_text_polls/*'],
    api => 'http://www.polleverywhere.com/services/oembed/'
  },

# SMELL: provider doesn't ecode urls properly
# SmugMug => {
#   url => 'http://www.smugmug.com/.*', #'http://*.example.com/* (where example.com = SmugMug customer domain)
#   api => 'http://api.smugmug.com/services/oembed/',
# },

  iFixit => {
    url => 'http://www.ifixit.com/*',
    api => 'http://www.ifixit.com/Embed',
  },

  SlideShare => {
    url => 'http://www.slideshare.net/*/*',
    api => 'http://www.slideshare.net/api/oembed/2',
  },

  WordPress_com => {
    url => 'http://*.wordpress.com',
    api => 'http://public-api.wordpress.com/oembed/',
    params => {
      for => "foswiki"
    }
  },

  chirbit => {
    url => 'http://chirb.it/*',
    api => 'http://chirb.it/oembed.json',
  },

  CircuitLab => {
    url => 'https://www.circuitlab.com/circuit/*',
    api => 'https://www.circuitlab.com/circuit/oembed/',
  },

  Geograph_Britain_Ireland => {
    url => [
      'http://*.geograph.org.uk/*', 
      'http://*.geograph.co.uk/*', 
      'http://*.geograph.ie/*',
      'http://*.wikimedia.org/*_geograph.org.uk_*',
    ],
    api => 'http://api.geograph.org.uk/api/oembed',
  },

  Geograph_Germany => {
    url => [
      'http://geo-en.hlipp.de/*', 
      'http://geo.hlipp.de/*', 
      'http://germany.geograph.org/*',
    ],
    api => 'http://geo.hlipp.de/restapi.php/api/oembed',
  },

  Geograph_Channel_Islands => {
    url => ['http://*.geograph.org.gg/*', 'http://*.geograph.org.je/*', 'http://channel-islands.geograph.org/*', 'http://channel-islands.geographs.org/*', 'http://*.channel.geographs.org/*',],
    api => 'http://www.geograph.org.gg/api/oembed',
  },

  Quiz_biz => {
    url => 'http://www.quiz.biz/quizz*',
    api => 'http://www.quiz.biz/api/oembed',
  },

  Coub => {
    url => ['http://coub.com/view/*', 'http://coub.com/embed/*',],
    api => 'http://coub.com/api/oembed.json',
  },

  Twitter => {
    url => 'https://twitter.com/*/status/*',
    api => 'https://api.twitter.com/1/statuses/oembed.json',
  },

  BlibTv => {
    url => 'http://*.blip.tv/*', 
    api => 'http://blip.tv/oembed/', 
  },

  DailyMotion => {
    url => 'http://*.dailymotion.com/*', 
    api => 'http://www.dailymotion.com/api/oembed/'
  },

  nfb => {
    url => 'http://*.nfb.ca/film/*',
    api => 'http://www.nfb.ca/remote/services/oembed/', 
  },

  Scribd => {
    url => 'http://*.scribd.com/*',
    api => 'http://www.scribd.com/services/oembed',
  },

  DotSub => {
    url => 'http://dotsub.com/view/*',
    api => 'http://dotsub.com/services/oembed',
  },

  ClikTrough => {
    url => 'http://www.clikthrough.com/theater/*',
    api => 'http://www.clikthrough.com/services/oembed',
  },

  Kinomap => {
    url => 'http://*.kinomap.com/*',
    api => 'http://www.kinomap.com/oembed',
  },
  
  Mixcloud => {
    url => 'http://*.mixcloud.com/*',
    api => 'http://www.mixcloud.com/oembed/',
  },

  Embedly => {
    url => [
      'http://*.amazon.com/*', 
      'http://*.amazon.de/*', 
      'http://*.clipfish.de/*',
      'http://goo.gl/maps/*',
      'http://*.imdb.com/*',
      'http://instagram.com/p/*',
      'http://*.screencast.com/*',
      'https://foursquare.com/*',
      'https://maps.google.com/maps/*',
      'http://twitpic.com/*',
      'http://www.washingtonpost.com/*',
    ],
    api => 'http://api.embed.ly/1/oembed',
  },

  Screenr => {
    url => 'http://*.screenr.com/*',
    api => 'http://www.screenr.com/api/oembed.json',
  },

  Aol => {
    url => 'http://on.aol.com/*',
    api => 'http://on.aol.com/api',
  },

  Deviantart => {
    url => [
      'http://*.deviantart.com/art/*',
      'http://*.deviantart.com/*#/d*',
      'http://fav.me/*',
      'http://sta.sh/*',
    ],
    api => 'http://backend.deviantart.com/oembed',
  },

  SpeakerDeck => {
    url => 'https://speakerdeck.com/*',
    api => 'https://speakerdeck.com/oembed.json',
  }

  VideoJug => {
    url => ['http://www.videojug.com/film/*','http://www.videojug.com/interview/*'],
    api => 'http://www.videojug.com/oembed.json',
  },

  JustinTV => {
    url => 'http://www.justin.tv/*',
    api => 'http://api.justin.tv/api/embed/from_url.json',
  },

  MobyPicture => {
    url => ['http://www.mobypicture.com/user/*/view/*', 'http://mobypicture.com/user/*/view/*', 'http://moby.to/*'],
    api => 'http://api.mobypicture.com/oEmbed',
    params => {
      format => 'json'
    },
  },

  '23hq' => {
    url => 'http://www.23hq.com/*/photo/*',
    api => 'http://www.23hq.com/23/oembed',
  },

  OfficialFM => {
    url => ['http://official.fm/tracks/*', 'http://official.fm/playlists/*'],
    api => 'http://official.fm/services/oembed.json',
  },

  SapoVideos => {
    url => 'http://videos.sapo.pt/*',
    api => 'http://videos.sapo.pt/oembed',
    params => {
      format => 'json'
    },
  },

  PollyDaddy => {
    url => ['http://*.polldaddy.com/s/*', 'http://*.polldaddy.com/poll/*', 'http://*.polldaddy.com/ratings/*' ],
    api => 'http://polldaddy.com/oembed/',
    params => {
      format => 'json'
    },
  },

  Roomshare => {
    url => ['http://roomshare.jp/post/*', 'http://roomshare.jp/en/post/*'],
    api => 'http://roomshare.jp/en/oembed.json',
  },

  Urtak => {
    url => [
      'https://urtak.com/u/*', 
      'https://urtak.com/clr/*',
      'http://urtak.com/u/*', 
      'http://urtak.com/clr/*',
      'https://www.urtak.com/u/*', 
      'https://www.urtak.com/clr/*',
      'http://www.urtak.com/u/*', 
      'http://www.urtak.com/clr/*',
    ],
    api => 'http://oembed.urtak.com/1/oembed',
  },

  CrowdRanking => {
    url => 'http://crowdranking.com/*/*',
    api => 'http://crowdranking.com/api/oembed.json',
  }

  Cacoo => {
    url => 'https://cacoo.com/diagrams/*',
    api => 'http://cacoo.com/oembed.json',
  },

  HuffDuffer => {
    url => 'http://huffduffer.com/*/*',
    api => 'http://huffduffer.com/oembed',
    params => {
      format => 'json'
    },
  },

  MyOpera => {
    url => 'http://my.opera.com/*',
    api => 'http://my.opera.com/service/oembed',
    params => {
      format => 'json'
    },
  },

  FunnyOrDie => {
    url => 'http://www.funnyordie.com/videos/*',
    api => 'http://www.funnyordie.com/oembed.json',
  },

  Animoto => {
    url => 'http://animoto.com/play/*',
    api => 'http://animoto.com/oembeds/create',
    params => {
      format => 'json'
    },
  },

  Rdio => {
    url => ['http://*.rdio.com/artist/*', 'http://*.rdio.com/people/*'],
    api => 'http://www.rdio.com/api/oembed/',
  },

  Dipity => {
    url => 'http://www.dipity.com/*/*/',
    api => 'http://www.dipity.com/oembed/timeline/',
  },

  SoundCloud => {
    url => [
      'http://soundcloud.com/*',
      'http://www.soundcloud.com/*',
      'https://soundcloud.com/*',
      'https://www.soundcloud.com/*',
    ],
    api => 'http://soundcloud.com/oembed',
    params => {
      format => 'json'
    },
  },

  Instagram => {
    url => [
      'http://instagram.com/p/*',
      'http://instagr.am/p/*',
    ],
    api => 'http://api.instagram.com/oembed',
  },

  Kickstarter => {
    url => 'http://www.kickstarter.com/projects/*',
    api => 'http://www.kickstarter.com/services/oembed',
  },

  Ustream => {
    url => [
      'http://*.ustream.tv/*',
      'http://*.ustream.com/*',
    ],
    api => 'http://www.ustream.tv/oembed',
  },

  Sketchfab => {
    url => [
      'http://sketchfab.com/show/*',
      'https://sketchfab.com/show/*',
    ],
    api => 'http://sketchfab.com/oembed',
  },

  Meetup => {
    url => [
      'http://www.meetup.com/*',
      'http://meetup.com/*',
      'http://meetu.ps/*',
    ],
    api => 'https://api.meetup.com/oembed',
  },

};


1;
