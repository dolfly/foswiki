;(function($j) {
if (!window.Foswiki) { window.Foswiki = {};}

if (!window.Foswiki.Func) { window.Foswiki.Func = {};}

window.Foswiki.Func.getScriptUrl = function (web, topic, script) {
		return Foswiki.scriptUrlPath+"/"+script+Foswiki.scriptSuffix+"/"+web+"/"+topic;
}

window.Foswiki.Func.getRestUrl = function (web, topic, plugin, restmethod) {
	if(web == undefined)
		web = "";
	
	if(topic == undefined)
		topic = "";
	return Foswiki.scriptUrlPath+"/rest"+Foswiki.scriptSuffix+"/"+plugin+"/"+restmethod+"?topic="+web+"."+topic;
}

})(jQuery);