jQuery(function($) {

  var defaults = {
    navSelector: '.jqInfiniteScrollNavi',
    nextSelector: '.jqInfiniteScrollNext',
    itemSelector: '.jqInfiniteScrollItem',
    donetext:'',
    loadingText:'',
    loadingMsgRevealSpeed: 0,
    loadingImg: foswiki.getPreference("PUBURLPATH")+"/"+foswiki.getPreference("SYSTEMWEB")+"/InfiniteScrollContrib/loading.gif"
  };

  $(".jqInfiniteScroll:not(.jqInitedInfiniteScroll)").livequery(function() {
    var $this = $(this), opts = $.extend({}, defaults, $this.metadata());
    $this.addClass("jqInitedInfiniteScroll").infinitescroll(opts);
  });
});
