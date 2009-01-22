
function preinit() {
	// Initialize
	tinyMCE.setWindowArg('mce_windowresize', false);
}

;(function($j){
window.initFoswikiLinks = function() {
	tinyMCEPopup.resizeToInnerSize();   

	var selecetedText = tinyMCE.selectedInstance.selection.getSelectedHTML();
    
    $j('#link_name_intern').val(selecetedText);
    $j('#link_name_extern').val(selecetedText);
    $j('#insert').val( tinyMCE.getLang('lang_isert', 'Insert', true) ); 
    init_webs();
    init_topics();
	window.focus();
}

window.init_topics= function() {        
        var url = window.Foswiki.scriptUrl+"/rest/TopicListPlugin/topiclist?topic=System.WebHome&max=0&format=%TOPIC&globalformat=%TOPICS&delimiter=%NL";
        $j("#topic_name").autocomplete(url,
        {
           extraParams: {
               searchwebs: function() { return $j("#web_name").val(); },
               pattern: function() { return '^'+$j("#topic_name").val()+'.*'; }
           },
           cacheLength:100,
           max:20,
           minChars:1,
           autoFill:1,
           selectFirst: true
        });
}

window.init_webs = function () {
    var url = window.Foswiki.scriptUrl+"/rest/TopicListPlugin/weblist?topic=System.WebHome&excludewebs=Trash,_default,_empty";
    $j.getJSON(url, 
          function(data){
              var output='<select name="web_name" id="web_name">';
              $j.each(data, function(i,item){
                 output += '<option value="'+item+'">'+item+'</option>';
              });
              output += '</select>';          
              $j("#webcontainer").html(output);
              
              $j("#web_name").change( function() {
              	$j("#topic_name").flushCache();
              	}
              );
              $j("#web_name").keyup( function() {
              	$j("#topic_name").flushCache();
              	}
              );
          }
          );
    
}

window.convertURL =  function (url, node, on_save) {
	return eval("tinyMCEPopup.windowOpener." + tinyMCE.settings['urlconverter_callback'] + "(url, node, on_save);");
}

window.insertFoswikiLink = function() {
    var href = "";
    var title = "";
    var link_name = tinyMCE.selectedInstance.selection.getSelectedHTML();
    var target = "_self";
    var errormsg = "";
    if($j("div[id='internal_link_panel'][class*='current']").length > 0) {
        var web = $j("#web_name").val();        
        if(web =="")
            errormsg +="You must select a web\n";
            
        var topic = $j("#topic_name").val();        
        if(topic == "")
            errormsg += "You must define the topic to link to\n";
            
        var title = $j("#internal_link_title").val();
        href = '[['+web+'.'+topic+']['+link_name+']]';        
    }
    else if ($j("div[id='external_link_panel'][class*='current']").length > 0) {
        var ext_link = $j("#external_link_href").val();
        if(ext_link == "" || ext_link == "http://")
            errormsg += "You must define the link\n";
            
        var title = $j("#external_link_title").val();
        href = '[['+ext_link+']['+link_name+']]';  
    }
    if(errormsg != "") {
        alert(errormsg);
        return;
    }
    tinyMCEPopup.restoreSelection();
    tinyMCEPopup.execCommand("mceBeginUndoLevel");
    tinyMCEPopup.execCommand("mceInsertContent", false, '<span class="WYSIWYG_LINK">'+href+'</span>');
    tinyMCEPopup.execCommand("mceEndUndoLevel");
    tinyMCEPopup.close();
}
})(jQuery);
// While loading
preinit();
initFoswikiLinks ();
