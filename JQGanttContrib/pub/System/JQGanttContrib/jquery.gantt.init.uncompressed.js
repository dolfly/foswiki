jQuery(function($) {

  var defaults = {
    months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
    dow: ["Su", "Mo", "Tu", "We", "Thu", "Fri", "Sa"]
  };

  $(".jqGantt:not(.jqInitedGantt)").livequery(function() {
    var $this = $(this), opts = $.extend({}, defaults, $this.metadata());
  
    $this.addClass("jqInitedGantt").gantt(opts);
  });
});
