//
//  Foswiki javascript behavior
//

function fwAddStateActive(obj) 
	{
	obj.parents('.fw-buttonset-single:first').find(".fw-button.ui-state-active").removeClass("ui-state-active");
	if( obj.is('.ui-state-active.fw-button-toggleable, .fw-buttonset-multi .ui-state-active') ){ obj.removeClass("ui-state-active"); }
	else { obj.addClass("ui-state-active");}	
	} 	

function fwRemoveStateActive(obj) 
	{
	if(! obj.is('.fw-button-toggleable, .fw-buttonset-single .fw-button,  .fw-buttonset-multi .fw-button'))
		{
		obj.removeClass("ui-state-active");
		}		
	} 
	
//
//Function ready
//
$(document).ready(function()
	{
	//Hover and click logic for buttons
	$(".fw-button:not(.ui-state-disabled):not(.ui-state-error):not(.ui-state-highlight)")
		.hover
			(
			function()
				{
				$(this).addClass("ui-state-hover"); 
				},
			function()
				{ 
				$(this).removeClass("ui-state-hover"); 
				fwRemoveStateActive($(this));				
				}
			)
		.mousedown
			(
			function()
				{
				fwAddStateActive($(this));
				}
			)
		.mouseup
			(
			function()
				{
				fwRemoveStateActive($(this));
				}
			);		

	//fw-button with ui-state-error		
	$(".fw-button:.ui-state-error:not(.ui-state-disabled)")
		.hover
			(
			function()
				{
				$(this).addClass("ui-state-hover");
				$(this).removeClass("ui-state-error"); 				
				},
			function()
				{ 				
				$(this).removeClass("ui-state-hover"); 	
				fwRemoveStateActive($(this));
				$(this).addClass("ui-state-error"); 				
				}
			)
		.mousedown
			(
			function()
				{
				fwAddStateActive($(this));	
				$(this).removeClass("ui-state-error");
				}
			)
		.mouseup
			(
			function()
				{
				fwRemoveStateActive($(this));	
				}
			);		
			
	//fw-button with ui-state-highlight		
	$(".fw-button:.ui-state-highlight:not(.ui-state-disabled)")
		.hover
			(
			function()
				{
				$(this).addClass("ui-state-hover"); 
				$(this).removeClass("ui-state-highlight");
				},
			function()
				{ 				
				$(this).removeClass("ui-state-hover"); 	
				fwRemoveStateActive($(this));
				$(this).addClass("ui-state-highlight"); 				
				}
			)
		.mousedown
			(
			function()
				{
				fwAddStateActive($(this));	
				$(this).removeClass("ui-state-highlight");
				}
			)
		.mouseup
			(
			function()
				{
				fwRemoveStateActive($(this));				
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




