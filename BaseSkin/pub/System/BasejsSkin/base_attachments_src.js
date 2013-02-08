var foswiki;
if (!foswiki) {
    foswiki = {};
}
if (!foswiki.base) {
    foswiki.base = {};
}

foswiki.base.attachments = (function ($) {

    "use strict";

    var DISPLAY_LIST = 'list',
        DISPLAY_GRID = 'grid',
        SORT_NAME = 'data-name',
        COOKIE_DISPLAY = "COOKIE_ATTACHMENT_DISPLAY",
        COOKIE_SORT = "COOKIE_ATTACHMENT_SORT",
        SELECTOR_VIEW_SWITCH = ".js-attach-view",

    sort = function($sortable, mode) {	
		var direction = $sortable.attr("data-sort-direction"),
		    pref,
		    comparator,
		    type,
		    $attachments;
		pref = foswiki.Pref.getPref(COOKIE_SORT);
		if (direction === undefined) {
			direction = 1;
		}
		if (mode === "data-date" || mode === "data-rev") {
			// latest on top
			direction = -direction;
		}
		type = "string";
		if (mode === "data-size" || mode === "data-date") {
			// number
			comparator = function(a, b) {
				return parseInt($(a).attr(mode), 10) > parseInt($(b).attr(mode), 10) ? -direction : direction;
			};
		} else {
			// string
			comparator = function(a, b) {
				return $(a).attr(mode).toLowerCase() > $(b).attr(mode).toLowerCase() ? direction : -direction;
			};
		}
		// find parent with class foswikiAttachments
		$attachments = $sortable.closest(".foswikiAttachments");
		$(".foswikiAttachment", $attachments).sortElements(comparator);

		updateSortUI($sortable, mode);
		
        foswiki.Pref.setPref(COOKIE_SORT, mode);
	},

	updateSortUI = function($sortable, state) {
        var current = $("li.foswikiActive", $sortable),
	        newli = $("li[data-sort='" + state + "']", $sortable),
	        label = $(".foswikiDropdownToggle span", $sortable).first(),
	        labelValue = newli.text();
        current.removeClass("foswikiActive");
        newli.addClass("foswikiActive");
        label.text(labelValue);
    },
    
    setDisplay = function($el, mode) {
        var $attachments = $el.closest(".foswikiAttachments"),
            pref;
        $(".foswikiButton[data-display='list']", $attachments)
                .removeClass("foswikiActive");
        $(".foswikiButton[data-display='grid']", $attachments)
                .removeClass("foswikiActive");
        if (mode === "list") {
            $attachments.removeClass("foswikiDisplayGrid")
                .addClass("foswikiDisplayList");            
            $(".foswikiAttachment", $attachments)
                .removeClass("span3").addClass("span12");
            $(".foswikiButton[data-display='list']", $attachments)
                .addClass("foswikiActive");
        } else if (mode === "grid") {
            $attachments.removeClass("foswikiDisplayList")
                .addClass("foswikiDisplayGrid");
            $(".foswikiAttachment", $attachments).removeClass("span12")
                .addClass("span3");
            $(".foswikiButton[data-display='grid']", $attachments)
                .addClass("foswikiActive");
        }
        foswiki.Pref.setPref(COOKIE_DISPLAY, mode);
    };

    return {

        /**
        Finds the currently selected value and sorts.
        Inits the click event on sort links.
        */
        initSort: function () {
            // read current view from cookie
            var mode,
                $sortable;

            mode = foswiki.Pref.getPref(COOKIE_SORT);
            
            $(".foswikiSortable").each(function() {
                $sortable = $(this);
                var $active = $("li.foswikiActive", $sortable);
                if (!mode) {
                    mode = $active.attr("data-sort");
                }
                if (!mode) {
                    mode = SORT_NAME;
                }                
                sort($sortable, mode);
            });
            
            $(".foswikiSortable > ul > li > a").on("click", function() {
                var $this = $(this),
                    $sortable = $this.closest(".foswikiSortable"),
                    li = $this.closest("li"),
                    newMode = li.attr("data-sort");
                if (newMode) {
                    sort($sortable, newMode);
                }
                return false;
            });
        },
        
        initDisplay: function () {
            // read current view from cookie
            var mode,
                $button;

            mode = foswiki.Pref.getPref(COOKIE_DISPLAY);

            $(SELECTOR_VIEW_SWITCH).each(function() {
                var $switchable = $(this);
                if (!mode) {
                    mode = $switchable.attr("data-display");
                }
                if (!mode) {
                    mode = DISPLAY_LIST;
                }                
                setDisplay($switchable, mode);
            });

            $(".foswikiButton", $(SELECTOR_VIEW_SWITCH)).click(function() {
                var bmode = $(this).attr("data-display"),
                    $switchable = $(this).closest($(SELECTOR_VIEW_SWITCH));
                if (bmode) {
                    setDisplay($switchable, bmode);
                }
                return false;
            });
        }

    };

}(jQuery));

jQuery(document).ready(function ($) {
    "use strict";
    foswiki.base.attachments.initDisplay();
    foswiki.base.attachments.initSort();
});

/*
function toggleAttachmentDetails($el, showDetails) {			
    // find corresponding foswikiAttachments
    var $attachments = $el.parents('.foswikiAttachments');
    if (showDetails) {
        $attachments.removeClass('bsHideDetails');
    } else {
        $attachments.addClass('bsHideDetails');
    }
}
    var COOKIE_SHOWATTACHMENT_DETAILS = 'COOKIE_SHOWATTACHMENT_DETAILS';

$(':checkbox[name="showdetails"]').on(function () {
    var pref = parseInt(foswiki.Pref.getPref(COOKIE_SHOWATTACHMENT_DETAILS), 10);
    if (pref) {
        $(this).attr('checked', true);
    } else {
        $(this).removeAttr('checked');
    }
    var showDetails = $(this).is(':checked') ? 1 : 0;
    toggleAttachmentDetails($(this), showDetails);
});

$(':checkbox[name="showdetails"]').on('change', function () {
    var showDetails = $(this).attr('checked') ? 1 : 0;
    toggleAttachmentDetails($(this), showDetails);
    foswiki.Pref.setPref(COOKIE_SHOWATTACHMENT_DETAILS, showDetails);
});

$('.foswikiAttachment .bsVersions').on(function() {
    var PUBURL = foswiki.getPreference('PUBURLPATH') + '/' + foswiki.getPreference('SYSTEMWEB') + '/' + 'BaseSkinJs/';
    
    var url = $(this).attr('href') + ';cover=baseajax;def=history';
    
    //$(this).addClass('jqSimpleModal {url: \'' + url + '\'}');
});

$('.foswikiAttachment .bsVersions').bind('hidden', function () {
    //console.log("click .foswikiAttachment .bsVersions:" + $(this).attr('href'));
})
*/
/*
$('.foswikiAttachment .bsVersions').on('click', function() {
    var PUBURL = foswiki.getPreference('PUBURLPATH') + '/' + foswiki.getPreference('SYSTEMWEB') + '/' + 'BaseSkinJs/';
    
    $.facebox.settings.closeImage = PUBURL + 'closelabel.png';
    $.facebox.settings.loadingImage = PUBURL + 'loading.gif';

    console.log("PUBURL=" + PUBURL);
    
    var url = $(this).attr('href') + ';cover=baseajax;def=history';
    console.log(url);
    return false;
});
*/

/**
 * jQuery.fn.sortElements
 * --------------
 * @author James Padolsey (http://james.padolsey.com)
 * @version 0.11
 * @updated 18-MAR-2010
 * --------------
 * @param Function comparator:
 *   Exactly the same behaviour as [1,2,3].sort(comparator)
 *   
 * @param Function getSortable
 *   A function that should return the element that is
 *   to be sorted. The comparator will run on the
 *   current collection, but you may want the actual
 *   resulting sort to occur on a parent or another
 *   associated element.
 *   
 *   E.g. $('td').sortElements(comparator, function(){
 *      return this.parentNode; 
 *   })
 *   
 *   The <td>'s parent (<tr>) will be sorted instead
 *   of the <td> itself.
 */
jQuery.fn.sortElements = (function(){
    
    var sort = [].sort;
    
    return function(comparator, getSortable) {
        
        getSortable = getSortable || function(){return this;};
        
        var placements = this.map(function(){
            
            var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,
                
                // Since the element itself will change position, we have
                // to have some way of storing it's original position in
                // the DOM. The easiest way is to have a 'flag' node:
                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );
            
            return function() {
                
                if (parentNode === this) {
                    throw new Error(
                        "You can't sort elements if any one is a descendant of another."
                    );
                }
                
                // Insert before flag:
                parentNode.insertBefore(this, nextSibling);
                // Remove flag:
                parentNode.removeChild(nextSibling);
                
            };
            
        });
       
        return sort.call(this, comparator).each(function(i){
            placements[i].call(getSortable.call(this));
        });
        
    };
    
})();