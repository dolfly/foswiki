/* This script Copyright (c) 2008 Collaborganize
* and distributed under the GPL (see below)
* 
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details, published at 
* http://www.gnu.org/copyleft/gpl.html
* 
* Author: Eugen Mayer
*/
/* ******** Settings *********/
// TODO: provide settings for that


/*****************************/
;(function($j) {
window.generalDialogActionHandler = function (selector,data,scriptname,uri) {
	$j(selector).html(data);
}

window.generalActionHandler = function (selector,data,scriptname,uri) {
	document.location = uri;	
}
	
	
function bootupDialog(selector, atitle, amodal, awidth, aheight ) {
	// remove the main window scrollbars, so users dont get confused by scrolling the outer window
	if(amodal) {
		setupScrollock();
	}
 
	showWaitingLayer(selector);
	// show this while we are waiting for the content
    $j(selector).dialog("position", "center");
	// initialize the dialog
	$j(selector).dialog({
											dialogClass: Foswiki.jquery.themeName,
											title:atitle,
 											autoOpen:false,
											width:awidth,
											height:aheight,
											modal: amodal, 
								    		overlay: { 
								        		opacity: 0.4, 
								        		background: "black"
											},
											close: function() { uninstallScrollock(); }
	}); 	
}
/* makes it possible to show a dialog without knowing the jquery.dialog api.
 * selector: The div ID which should be used as the dialog-destination. Generally its a display:hidden 
 * 			 layer hidden somewhere in the layout. You must add a # to your id here, so if the id is
 * 			 "example" you must use "#example" as parameter here
 * aurl:	 url to fetch
 * atitle:	 title of the dialog
 * amodal: 	 boolean, should the dialog be shown modal, so you must close it before you can use the page further
 * awidth:	 size of the dialog
 * aheight:  size of the dialog
 */
window.fetchAndShowDialog = function(selector, aurl, atitle, amodal, awidth, aheight ) {
	fetchAndSetupDialog(selector, aurl, atitle, amodal, awidth, aheight );	
	showDialog(selector);
}
/* makes it possible to sertup a dialog without knowing the jquery.dialog api.
 * selector: The div ID which should be used as the dialog-destination. Generally its a display:hidden 
 * 			 layer hidden somewhere in the layout. You must add a # to your id here, so if the id is
 * 			 "example" you must use "#example" as parameter here
 * data:	 data ( mostyl HTML ) to put inside the dialog
 * atitle:	 title of the dialog
 * amodal: 	 boolean, should the dialog be shown modal, so you must close it before you can use the page further
 * awidth:	 size of the dialog
 * aheight:  size of the dialog
 */

window.setupDialog = function (selector, data, atitle, amodal, awidth, aheight ) {
	bootupDialog(selector, atitle, amodal, awidth, aheight);
	$j(selector).html(data);
}

window.fetchAndSetupDialog = function(selector, aurl, atitle, amodal, awidth, aheight, responseHandler ) {
	if(responseHandler == undefined ) {
		responseHandler = {};
		// setting 200 / 401 .. just to show how its used, actually only "all" is important here
		responseHandler['other'] = 'generalRestResponseHandler';
		responseHandler['200'] = 'handleDialogCompleteResponse';
		responseHandler['401'] = 'generalRestResponseHandler';
		responseHandler['403'] = 'generalRestResponseHandler';
		responseHandler['500'] = 'generalRestResponseHandler';		
	}
	
	bootupDialog(selector, atitle, amodal, awidth, aheight);
	// ok show the waiting dialog

	// adding the skin as parameter, so the fetched data is without layout
	aurl = addSkinParameter(aurl,window.SKIN.ajaxreqskin);	
	// adding this to avoid the hardcore IE caching breaks up the header. Thank you MS
	var timestamp = new Date();
	aurl += "&t="+timestamp.getTime();
	// now fetch the content	
	$j.ajax({			
					 url : aurl,	
					 type: "GET",  			
		  			 scriptCharset: "iso-8859-1",
		  			 dataType:"html",	
		  			 complete: function(xmlHttp, status) { 
						var handler = "";
						status = xmlHttp.status;
						// if no handler for the returned status is provided, use the "other" handler
						if(responseHandler[status] == undefined)  {
							
							if(responseHandler["other"] != undefined) {
								// but if the "other" handler is also undefined, use a dummy 
								// which displays an error
								handler = "resposneHandlerNotDefined";
							}
							else {
								// ok other is set, so use it
								handler =  responseHandler["other"];								
							}
						}
						else {
							handler = responseHandler[status];
						}	

						// call the corresponding handler
						window[handler](xmlHttp, status,selector);
					 }				 
	});
}

window.showDialog = function (selector) {	
	$j(selector).show();    	
	$j(selector).dialog("open");
}

window.closeDialog = function (selector) {
	$j(selector).hide(); 
	$j(selector).dialog("close");
	$j(selector).dialog("destroy"); 
}
// General handler, which can be called after a fetch has been completed
window.handleDialogCompleteResponse = function (xmlHttp, status,selector) {
	if(xmlHttp.status != 200){ // error 
			// TODO: what to do if error
			 return;
	}
	var data = xmlHttp.responseText;	
	// welcome to foswiki`s world. Lets remove all the useful "p`s" in arround the dialog
	$j(selector+" > p").remove();
	var action = xmlHttp.getResponseHeader("X-FoswikiAction");
	var uri = xmlHttp.getResponseHeader("X-FoswikiURI");
	handleGeneralData(selector,data,action,uri);
}

// Handling specific action-scripts retuned by foswiki. Much more to add
window.handleGeneralData = function (selector,data,scriptname, uri) {
	// general stuff to do
	$j(selector).css("overflow-y","auto");
	
	switch(scriptname) {
		case 'attach':
			window[Foswiki.actionHandlers.attach](selector,data,scriptname,uri);
		break;
		case 'login':
			window[Foswiki.actionHandlers.login](selector,data,scriptname,uri);
		break;	
		case 'rename':
			window[Foswiki.actionHandlers.rename](selector,data,scriptname,uri);
		break;	
		case 'manage':
			window[Foswiki.actionHandlers.manage](selector,data,scriptname,uri);
		break;	
		case 'rdiff':
			window[Foswiki.actionHandlers.rdiff](selector,data,scriptname,uri);
		break;	
		case 'register':
			window[Foswiki.actionHandlers.register](selector,data,scriptname,uri);
		break;
		case 'rest':
			window[Foswiki.actionHandlers.rest](selector,data,scriptname,uDialogri);
		break;	
		case 'search':
			window[Foswiki.actionHandlers.search](selector,data,scriptname,uri);
		break;	
		case 'changes':
			window[Foswiki.actionHandlers.changes](selector,data,scriptname,uri);
		break;	
		case 'view':
			window[Foswiki.actionHandlers.view](selector,data,scriptname,uri);
		break;
		case 'oops':
			alert(Foswiki.actionHandlers.oops);
			window[Foswiki.actionHandlers.oops](selector,data,scriptname,uri);
		break;
		default:
			alert("Cant handle the returned script - it is not implemented. Script: "+scriptname);
		break;
	}	
}


window.setupScrollock= function () {
    var a = [
        self.pageXOffset ||
        document.documentElement.scrollLeft ||
        document.body.scrollLeft
        ,
        self.pageYOffset ||
        document.documentElement.scrollTop ||
        document.body.scrollTop
        ];
    $j("body").css("overflow","hidden");
}

window.uninstallScrollock = function () {
    $j("body").css("overflow","scroll");
}


window.addSkinParameter = function (url,skin) {
	var ausdruck = /.*[?].*/;
	// if there are parameters already
	if(url.match(ausdruck)) {
		url += "&skin="+skin;
	}// else add this one
	else { url += "?skin="+skin; }	
	return url;
}

window.showWaitingLayer= function (dialogselector, message) {
	if(message == undefined) {
		message = "loading...";
	}

	var wait = '<table width="100%" height="100%"><tr><td width="100%" align="center" valign="center" style="font-weight:bolder">'+message+'<br><br><img src="'+Foswiki.pubUrlPath+'/System/JQueryCompatibilityModePlugin/themes/loader.gif"></td></tr></table>';
    $j(dialogselector).html(wait);
}

window.generalRestResponseHandler = function (xmlHttp, status,selector) {
	var data = xmlHttp.responseText;
	
	switch(status) {
		case 200:
			$j(selector).html(data);
			$j(selector+" > p").remove();
		break;
		case 401:			
		case 403:
			window[Foswiki.UI.showLogin](selector);
		break;
		case 500:
			window[Foswiki.UI.showOops](selector);
		break;
	}
}

window.showLoginForm = function (dialogselector) {
	// this is the way how we would show a normal login dialog
	//fetchAndShowDialog(dialogselector,"/bin/login","Login",true,400,400);
	
	// but right now as nobody really seperates the login forms and other dialogs using the ajax skin
	// we make a normal redirect to the login form
	
	document.location = "/bin/login";
}

window.showLoginForm = function (dialogselector) {
	// this is the way how we would show a normal login dialog. This is for later use or as an example
	// fetchAndShowDialog(dialogselector,"/bin/login","Login",true,400,400);
	
	// but right now as nobody really seperates the login forms and other dialogs using the ajax skin
	// we make a normal redirect to the login form	
	document.location = "/bin/login";
}

window.showOops = function (dialogselector) {
	// we could try to give the user some feedback what could have happend, but right now, we just 
	// display a alert that something bad happened. This is to overwrite later by better logic
	alert("An error occured during your operation");
}


window.resposneHandlerNotDefined = function (xmlHttp, status,selector) {

	alert("No handler defined for status:"+status);
}
})(jQuery);