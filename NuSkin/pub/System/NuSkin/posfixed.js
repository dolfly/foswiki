$ = jQuery;

// Making the toolbar detach and stay at the top of the browser window
// when scrolling down: the following is 
// adapted from js found at www.quirksmode.com (doesn't work for lte IE6
// because it doesn't support position:fixed)
var badBrowser = (/MSIE ((5\.5)|6)/.test(navigator.userAgent)
                  && navigator.platform == "Win32");

function setMenuOffset() { 
	var header = document.getElementById('toolBar');
	if (!header) return;
	var currentOffset = document.documentElement.scrollTop
        || document.body.scrollTop; // body for Safari
	var startPos = parseInt(setMenuOffset.initialTop) || 200;
	var desiredOffset = startPos + currentOffset;
	if (!badBrowser) {
		if (currentOffset > startPos) {
			header.style.position = 'fixed';
			header.style.top = 0 + 'px';
			$("div.officetools-menu").css("position","fixed");
		} else {
			header.style.position = 'static';
			$("div.officetools-menu").css("position","absolute");
		}
	}
}

$(document).ready(
    function() {
        var x = document.getElementById('toolBar');
		if (!x) return;
		setMenuOffset.initialTop = x.offsetTop;
		setMenuOffset.initialLeft = x.firstChild.offsetLeft;
		window.onscroll = document.documentElement.onscroll = setMenuOffset;
		setMenuOffset();
		/* in Moz 1.7.12/FF 1.5 window.onscroll is wiped when you use the
           mouse wheel while 
           the pointer is NOT above a true page element (ie. when it is above
           the naked documentElement)
           ... or something ...
           Of course Safari doesn't accept document.documentElement.onscroll;
           Op and IE 7 do */
    });
