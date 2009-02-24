//
//  Foswiki javascript behavior
//

$(document).ready(function()
	{
	//Hover and click logic for buttons
	$(".fw-button:not(.ui-state-disabled)")
		.hover
			(
			function()
				{
				$(this).addClass("ui-state-hover"); 
				},
			function()
				{ 
				$(this).removeClass("ui-state-hover"); 
				}
			)
		.mousedown
			(
			function()
				{
				$(this).parents('.fw-buttonset-single:first').find(".fw-button.ui-state-active").removeClass("ui-state-active");
				if( $(this).is('.ui-state-active.fw-button-toggleable, .fw-buttonset-multi .ui-state-active') ){ $(this).removeClass("ui-state-active"); }
				else { $(this).addClass("ui-state-active");}	
				}
			)
		.mouseup
			(
			function()
				{
				if(! $(this).is('.fw-button-toggleable, .fw-buttonset-single .fw-button,  .fw-buttonset-multi .fw-button'))
					{
					$(this).removeClass("ui-state-active");
					}
				}
			);		
			
	//Here is some code to extend the jQuery offset function so that it can accept parameters
	//See http://groups.google.com/group/jquery-dev/browse_thread/thread/10fa400d3f9d9521
	jQuery.fn._offset = jQuery.fn.offset;
	jQuery.fn.extend
		({
    	offset: function()
    		{
        	var a = arguments;
        	return (a.length) ? this.animate({ top: a[0].top || a[0], left: a[0].left || a[1] }, (a[0].top ? a[1] : a[2]) || 1) : this._offset();
    		}
		});
			
	});




