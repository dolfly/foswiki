
var Slion;
if (!Slion) Slion = {};

Slion.Edit = {

	EDIT_PREF_NAME:"Edit",
	EDITBOX_PREF_FONTSTYLE_ID:"TextareaFontStyle",
	EDITBOX_FONTSTYLE_MONO:"mono",
	EDITBOX_FONTSTYLE_PROPORTIONAL:"proportional",
	EDITBOX_FONTSTYLE_MONO_CLASSNAME:"slionButtonFontSelectorMonospace",
	EDITBOX_FONTSTYLE_PROPORTIONAL_CLASSNAME:"slionButtonFontSelectorProportional",
	
	buttons:{"font":null,"enlarge":null, "shrink":null},
	
	setFontStyleState:function(el, inShouldUpdateEditBox, inButtonState) {			
		var pref  = foswiki.Pref.getPref(Slion.Edit.EDIT_PREF_NAME + Slion.Edit.EDITBOX_PREF_FONTSTYLE_ID);

		if (!pref || (pref != Slion.Edit.EDITBOX_FONTSTYLE_PROPORTIONAL && pref != Slion.Edit.EDITBOX_FONTSTYLE_MONO)) pref = Slion.Edit.EDITBOX_FONTSTYLE_PROPORTIONAL;
	
		// toggle
		var newPref = (pref == Slion.Edit.EDITBOX_FONTSTYLE_PROPORTIONAL) ? Slion.Edit.EDITBOX_FONTSTYLE_MONO : Slion.Edit.EDITBOX_FONTSTYLE_PROPORTIONAL;
		

		
		var prefCssClassName = (pref == Slion.Edit.EDITBOX_FONTSTYLE_MONO) ? Slion.Edit.EDITBOX_FONTSTYLE_MONO_CLASSNAME : Slion.Edit.EDITBOX_FONTSTYLE_PROPORTIONAL_CLASSNAME;
		
		var toggleCssClassName = (newPref == Slion.Edit.EDITBOX_FONTSTYLE_MONO) ? Slion.Edit.EDITBOX_FONTSTYLE_MONO_CLASSNAME : Slion.Edit.EDITBOX_FONTSTYLE_PROPORTIONAL_CLASSNAME;		
			
		if (inButtonState && inButtonState == 'over') {
			if (foswiki.CSS.hasClass(el, prefCssClassName)) foswiki.CSS.removeClass(el, prefCssClassName);
			if (!foswiki.CSS.hasClass(el, toggleCssClassName)) foswiki.CSS.addClass(el, toggleCssClassName);
		} else if (inButtonState && inButtonState == 'out') {
			if (foswiki.CSS.hasClass(el, toggleCssClassName)) foswiki.CSS.removeClass(el, toggleCssClassName);
			if (!foswiki.CSS.hasClass(el, prefCssClassName)) foswiki.CSS.addClass(el, prefCssClassName);
		}
		
		if (inShouldUpdateEditBox) {
			Slion.Edit.setEditBoxFontStyle(newPref);
		}
		
		return false;
	},
	
	setEditBoxFontStyle:function(inFontStyle) {
		if (inFontStyle == Slion.Edit.EDITBOX_FONTSTYLE_MONO) {
			foswiki.CSS.replaceClass(document.getElementById(EDITBOX_ID), EDITBOX_FONTSTYLE_PROPORTIONAL_STYLE, EDITBOX_FONTSTYLE_MONO_STYLE);
			foswiki.Pref.setPref(PREF_NAME + Slion.Edit.EDITBOX_PREF_FONTSTYLE_ID, inFontStyle);
			return;
		}
		if (inFontStyle == Slion.Edit.EDITBOX_FONTSTYLE_PROPORTIONAL) {
			foswiki.CSS.replaceClass(document.getElementById(EDITBOX_ID), EDITBOX_FONTSTYLE_MONO_STYLE, EDITBOX_FONTSTYLE_PROPORTIONAL_STYLE);
			foswiki.Pref.setPref(PREF_NAME + Slion.Edit.EDITBOX_PREF_FONTSTYLE_ID, inFontStyle);
			return;
		}
	},
	
	initTextAreaStyles:function (inNames) {
		var i, ilen=inNames.length;
		for (i=0; i<ilen; ++i) {
			var button = Slion.Edit.buttons[inNames[i]];
			if (button != null) {
				Slion.Edit.buttons[inNames[i]].style.display = 'inline';
			}
		}
	}

}

var slionEditPageRules = {
	'.slionButtonFontSelector' : function(el) {
		el.style.display = 'none';
		Slion.Edit.buttons["font"] = el;
		Slion.Edit.setFontStyleState(el, false, 'out');
		el.onclick = function(){
			return Slion.Edit.setFontStyleState(el, true);
		}
		el.onmouseover = function() {
			return Slion.Edit.setFontStyleState(el, false, 'over');
		}
		el.onmouseout = function() {
			return Slion.Edit.setFontStyleState(el, false, 'out');
		}
	},
	'.slionButtonEnlarge' : function(el) {
		el.style.display = 'none';
		Slion.Edit.buttons["enlarge"] = el;
		el.onclick = function(){
			return changeEditBox(1);
		}
	},
	'.slionButtonShrink' : function(el) {
		el.style.display = 'none';
		Slion.Edit.buttons["shrink"] = el;
		el.onclick = function(){
			return changeEditBox(-1);
		}
	}
};
Behaviour.register(slionEditPageRules);

function slionInitTextArea() {
	initTextArea();
	Slion.Edit.initTextAreaStyles(["font", "enlarge", "shrink"]);
}

foswiki.Event.addLoadEvent(slionInitTextArea, false);
