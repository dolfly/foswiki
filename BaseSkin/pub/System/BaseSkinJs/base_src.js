var foswiki;
if (!foswiki) {
	foswiki = {};
}

/**
Base script. Handles:
- smooth scrolling
- sticky behaviour
*/


foswiki.base = (function () {

	"use strict";

	var getAnchor;
	
	getAnchor = function (url) {
		url = url || location.href;
		return url.replace(/^[^#]*#?!?(.*)$/, '$1');
	};

	return {

		smoothScroll: function ($) {
			var SCROLL_DURATION = 250,
				SCROLL_TOP = 20,
				$fixedElements = $('.foswikiMakeSticky'),
				offsetY = 0,
				scrollOpts,
				anchor,
				$target,
				i;

			for (i = 0; i < $fixedElements.length; i = i + 1) {
				offsetY += $($fixedElements[i]).outerHeight();
			}
			offsetY += SCROLL_TOP;

			scrollOpts = {
				reset: true,
				lazy: true,
				hash: true,
				duration: SCROLL_DURATION,
				axis: 'y',
				offset: { top: (-offsetY), left: 0 },
				easing: 'swing'
			};
			$('a').localScroll(scrollOpts);

			// also scroll on page load
			anchor = getAnchor();
			if (anchor) {
				$target = $('a[name=\'' + anchor + '\']');
				if ($target.length === 0) {
					$target = $('#' + anchor);
				}
				if ($target.length !== 0) {
					$('body').scrollTo($target, 1, scrollOpts);
				}
			}
		},
		
		removeYellowFromInputs: function($) {
			if (navigator.userAgent.toLowerCase().indexOf('chrome') >= 0) {
				var chromechk_watchdog = 0,
					chromechk;
				chromechk = setInterval(function() {
					if ($('input:-webkit-autofill').length > 0) {
						clearInterval(chromechk);
						$('input:-webkit-autofill').livequery(function () {
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
}());

jQuery(document).ready(function ($) {

	foswiki.base.smoothScroll($);
	foswiki.base.removeYellowFromInputs($);

	// add focus to elements with class foswikiFocus
	$('input.foswikiFocus').livequery(function () {
		$(this).focus();
	});

	// make elements with class foswikiMakeSticky stick to the window	
	$('.foswikiMakeSticky').sticky({
		cssclass: 'foswikiSticky'
	});
});

/**
Sticky plugin
https://github.com/ArthurClemens/jquery-sticky-plugin
*/

(function ($) {
	"use strict";
	$.fn.sticky = function (options) {

		var settings = $.extend({
			'cssclass': 'sticky'
		}, options),
			$fixedElements = [],
			$fixedElement,
			offsetY = 0,
			scrollTop = 0,
			ival,
			i,
			$this,
			scrollZone,
			fix,
			unfix,
			handleScroll,
			handleScrollEvent,
			// scroll wait duration depends if sticky element changes are within scroll zone
			SCROLL_WAIT_FINE = 5,
			SCROLL_WAIT_COURSE = 15,
			scrollWait = SCROLL_WAIT_COURSE;

		this.each(function () {
			$this = $(this);
			// scrollY: y position from where to fixate
			$this.scrollY = $this.position().top - offsetY;

			// stickyY: y position when being sticky
			$this.stickyY = offsetY;
			offsetY += $this.outerHeight();

			// scrollZone: to get finegrained scroll updates when sticking/unsticking happens
			scrollZone = $this.scrollY + $this.outerHeight();

			$fixedElements.push($this);
		});

		fix = function ($element) {
			// fix element at y position stickyY
			$element.addClass(settings.cssclass);
			$element.css({
				top: $element.stickyY + 'px'
			});
			// add a div to hold the padding the fixed element has just removed
			$element.$div = jQuery('<div></div>').css({
				height: $element.outerHeight()
			});
			$element.after($element.$div);
			$fixedElement.isFixed = 1;
		};

		unfix = function ($element) {
			$element.$div.remove();
			$element.removeClass(settings.cssclass);
			$element.css({
				top: 'auto'
			});
			$fixedElement.isFixed = 0;
		};

		handleScroll = function () {

			scrollTop = $(window).scrollTop();
			for (i = 0; i < $fixedElements.length; i = i + 1) {
				$fixedElement = $fixedElements[i];

				if (scrollTop >= $fixedElement.scrollY) {
					if (!$fixedElement.isFixed) {
						fix($fixedElement);
					}
				} else {
					if ($fixedElement.isFixed) {
						unfix($fixedElement);
					}
				}
			}
			scrollWait = scrollTop < scrollZone ? SCROLL_WAIT_FINE : SCROLL_WAIT_COURSE;
		};

		handleScrollEvent = function () {
			clearTimeout(ival);
			ival = setTimeout(function () {
				handleScroll();
			}, scrollWait);
		};

		$(window).scroll(handleScrollEvent);

		// update first time without scroll event
		handleScroll();

		return this;
	};

}(jQuery));