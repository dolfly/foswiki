jQuery(document).ready(function($) {
	
	$('input.foswikiFocus').livequery(function() {
		$(this).focus();
	});
	
/*
	var offset = $('.foswikiTopicActions').offset();
	var INITIAL_TOPIC_ACTIONS_Y = offset.top;
	console.log("INITIAL_TOPIC_ACTIONS_Y=" + INITIAL_TOPIC_ACTIONS_Y);
	var INITIAL_TOPIC_ACTIONS_LEFT = offset.left;
	console.log("INITIAL_TOPIC_ACTIONS_LEFT=" + INITIAL_TOPIC_ACTIONS_LEFT);
	
	console.log(INITIAL_TOPIC_ACTIONS_Y);
	$(window).scroll(function() {
    	if ($(window).scrollTop() >= INITIAL_TOPIC_ACTIONS_Y) {
        	$('.foswikiTopicActions').css({
        		position: 'fixed',
        		left: INITIAL_TOPIC_ACTIONS_LEFT,
        		top: 45
        	});
		} else {
			$('.foswikiTopicActions').css({
				position: 'absolute',
				right: 0,
				top: INITIAL_TOPIC_ACTIONS_Y
			});
		}
	});
*/

	var SCROLL_DURATION = 250;
	var scrollOpts = {
		reset: true,
		lazy: true,
		hash: true,
		duration: SCROLL_DURATION,
		axis: 'y',
		offset: { top:-($('.foswikiTopbar').height() + 10), left:0 },
		easing: 'swing'
	};
	$('a').localScroll(scrollOpts);

	// also scroll on page load
	var anchor = getAnchor();
	if (anchor) {
		var $target = $('a[name=' + anchor + ']');
		if ($target.length === 0) {
			$target = $('#' + anchor);
		}
		if ($target.length !== 0) {
			$('body').scrollTo( $target, SCROLL_DURATION, scrollOpts );
		}
	}

});



function getAnchor( url ) {
	url = url || location.href;
	return url.replace( /^[^#]*#?(.*)$/, '$1' );
};