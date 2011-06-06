jQuery(function($) {
  var opts = {
    classname: 'hyphenate',
    donthyphenateclassname: 'donthyphenate',
    minwordlength: 6,
    intermediatestate: 'visible',
    displaytogglebox: false,
    hyphenchar: '&shy;',
    urlhyphenchar: '',
    remoteloading: true,
    orphancontrol: 2,
    defaultlanguage: 'en',
    onhyphenationdonecallback: function() {
      $("."+opts.classname).addClass("jqInitedHyphenate");
      //$("#HyphenatorToggleBox").css({position:'fixed'});
      //console.log("done hyphenate");
    }
  };
  
  // mark them hyphenated right away in case livequery executes
  // earlier than the hyphenator
  $("."+opts.classname).addClass("jqInitedHyphenate");

  // global config
  Hyphenator.config(opts);

  // run the first time manually
  Hyphenator.run();

  // any further run is initiated by async content later on
  $("."+opts.classname+":not(.jqInitedHyphenate)").livequery(function() {
    Hyphenator.run();
  });

});
