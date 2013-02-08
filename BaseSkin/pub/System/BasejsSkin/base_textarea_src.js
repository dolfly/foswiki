var foswiki;
if (!foswiki) {
    foswiki = {};
}
if (!foswiki.base) {
    foswiki.base = {};
}

foswiki.base.textarea = (function ($) {

    "use strict";
    var MIN_HEIGHT = 400,
    
        getTextarea = function() {
            var $textarea = jQuery('.foswikiEditTextarea:not(.foswikiWysiwygEdit)');
            if (!$textarea.length) {
                $textarea = jQuery('.foswikiTextareaRawView:not(.foswikiWysiwygEdit)');
            }
            return $textarea;
        },
        
        fitToContent = function ($elem) {
            var SAFE_PADDING = 15,
                adjustedHeight,
                elemMinHeight,
                windowScrollTop;

            if (!$elem.length) {
                return;
            }

            elemMinHeight = document.documentElement.clientHeight - MIN_HEIGHT;
            windowScrollTop = $(window).scrollTop();
            
            // Account for deleted lines
            if ($elem[0].clientHeight <= $elem[0].scrollHeight) {
                $elem[0].style.height = elemMinHeight + 'px';
            }

            adjustedHeight = Math.max($elem[0].scrollHeight, $elem[0].clientHeight) + SAFE_PADDING;
            if (adjustedHeight > $elem[0].clientHeight) {
                $elem[0].style.height = adjustedHeight + 'px';
            }
            // scroll to position before height change (to prevent jumping around)
            $(window).scrollTop(windowScrollTop);
        },

        updateUI = function () {
            var $textarea = getTextarea();
            setTimeout(function () {
                fitToContent($textarea);
            }, 10);
        };
    
    return {

        /**
        Sets up the fit to content calls for the raw editor.
        */
        init: function () {
            var $textarea = getTextarea();           
            $textarea.livequery(function () {
                fitToContent($textarea);
            }).on('focus blur keyup paste change', function () {
                fitToContent($textarea);
            });
        }
        
    };

}(jQuery));

jQuery(document).ready(function ($) {
    "use strict";
    foswiki.base.textarea.init();
});