jQuery(function($) {
  var defaults = {
    source: "",
    separator: " ",
    prefix: "",
    suffix: ""
  };

  $(".jqTopicTitle:not(.jqTopicTitleInited)").livequery(function() {
    var $this = $(this), 
        opts = $.extend({}, defaults, $this.data());

    function updateTopicTitle() {
      var result = [], topicTitle = "";

      $(opts.source).each(function() {
        result.push($(this).is(':input')?$(this).val():$(this).text());
      });

      
      if (result.length) {
        topicTitle = opts.prefix + result.join(opts.separator) + opts.suffix;
      } 

      $this.val(topicTitle);
    }

    $(opts.source).change(updateTopicTitle).keyup(updateTopicTitle);
    updateTopicTitle();
  });
});
