var foswiki;
if (!foswiki) {
	foswiki = {};
}

/**
Base script.
*/


foswiki.base = (function ($) {

	"use strict";
	
	return {
		
		removeYellowFromInputs: function() {
			if (navigator.userAgent.toLowerCase().indexOf('chrome') >= 0) {
				var chromechk_watchdog = 0,
					chromechk;
				chromechk = setInterval(function() {
					if ($('input:-webkit-autofill').length > 0) {
						clearInterval(chromechk);
						$('input:-webkit-autofill').each(function () {
							var value = $(this).val(),
								name = $(this).attr('name');
							$(this).after(this.outerHTML).remove();
							$('input[name=' + name + ']').val(value);
						});
					} else if (chromechk_watchdog > 20) {
						clearInterval(chromechk);
					}
					chromechk_watchdog++;
				}, 50);
			}
		}

	};
}(jQuery));

jQuery(document).ready(function ($) {

	foswiki.base.removeYellowFromInputs();

	// add focus to elements with class foswikiFocus
	$('input.foswikiFocus').each(function () {
		$(this).focus();
	});

});