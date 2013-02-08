jQuery(document).ready(function ($) {
    "use strict";
    
    var nowysiwyg = parseInt(jQuery('form[name=main] [name="nowysiwyg"]').val(), 10);
    if (!nowysiwyg) {
        $('body').addClass('foswikiHasWysiwyg');
    }
});
