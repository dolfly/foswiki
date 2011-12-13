jQuery(document).ready(function($) {
	
	function smoothScroll() {
		var SCROLL_DURATION = 250,
			SCROLL_TOP = 20,
			$fixedElements = $('.foswikiMakeSticky'),
			offsetY = 0,
			scrollOpts,
			anchor,
			$target,
			i;
			
		for (i=0; i<$fixedElements.length; i=i+1) {
			offsetY += jQuery($fixedElements[i]).outerHeight();
		}
		offsetY += SCROLL_TOP;
		
		scrollOpts = {
			reset: true,
			lazy: true,
			hash: true,
			duration: SCROLL_DURATION,
			axis: 'y',
			offset: { top:(-offsetY), left:0 },
			easing: 'swing'
		};
		$('a').localScroll(scrollOpts);
	
		// also scroll on page load
		anchor = getAnchor();
		if (anchor) {
			$target = $('a[name=' + anchor + ']');
			if ($target.length === 0) {
				$target = $('#' + anchor);
			}
			if ($target.length !== 0) {
				$('body').scrollTo( $target, 1, scrollOpts );
			}
		}
	}
			
	function getAnchor( url ) {
		url = url || location.href;
		return url.replace( /^[^#]*#?!?(.*)$/, '$1' );
	}
	$('input.foswikiFocus').livequery(function() {
		$(this).focus();
	});
	
	smoothScroll();
	$('.foswikiMakeSticky').sticky({
		cssclass: 'foswikiSticky'
	});
});


(function( $ ){

	$.fn.sticky = function(options) {
	
		var settings = $.extend( {
		  'cssclass' : 'sticky'
		}, options);
		
		var $fixedElements = [],
			$fixedElement,
			offsetY = 0,
			scrollTop = 0,
			ival,
			i,
			$this,
			scrollZone,
			handleScroll,
			handleScrollEvent,
			// scroll wait duration depends if sticky element changes are within scroll zone
			SCROLL_WAIT_FINE = 5,
			SCROLL_WAIT_COURSE = 15,
			scrollWait = SCROLL_WAIT_COURSE;
	
		this.each(function() {
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
		
		handleScroll = function() {

			scrollTop = $(window).scrollTop();
			for (i=0; i<$fixedElements.length; i=i+1) {
				$fixedElement = $fixedElements[i];

				if (scrollTop >= $fixedElement.scrollY) {
					if (!$fixedElement.isFixed) {
						$fixedElement.isFixed = 1;
						
						// fix element at y position stickyY
						$fixedElement.addClass(settings.cssclass);
						$fixedElement.css({
							top: $fixedElement.stickyY + 'px'
						});			
						// add a div to hold the padding the fixed element has just removed
						$fixedElement.$div = jQuery('<div></div>').css({
							height: $fixedElement.outerHeight()
						});
						$fixedElement.after($fixedElement.$div);
					}
				} else {
					if ($fixedElement.isFixed) {
						$fixedElement.isFixed = 0;
						$fixedElement.$div.remove();
						$fixedElement.removeClass(settings.cssclass);
						$fixedElement.css({
							top: 'auto'
						});
					}
				}
			}
			scrollWait = scrollTop < scrollZone ? SCROLL_WAIT_FINE : SCROLL_WAIT_COURSE;
		};
		
		handleScrollEvent = function() {
			clearTimeout(ival);
			ival = setTimeout(function() {
				handleScroll();
			}, scrollWait);
		};
		
		$(window).scroll(handleScrollEvent);
		
		// update first time without scroll event
		handleScroll();
		
		return this;	
	};
	
})(jQuery);