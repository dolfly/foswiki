// Parse error formatting function
function reportParseError(error) {
    var s = "";
    for (var i=1; i<error.linepos; i++) {
    	s += " ";
    }
    r = "<font face=Verdana size=2><font size=4>XML Error loading '" + 
	error.url + "'</font>" +
      	"<P><B>" + error.reason + 
      	"</B></P></font>";
    if (error.line > 0)
    	r += "<font size=3><XMP>" +
    	"at line " + error.line + ", character " + error.linepos +
    	"\n" + error.srcText +
    	"\n" + s + "^" +
    	"</XMP></font>";
    return r;
}

// Runtime error formatting function
function reportRuntimeError(exception) {
    return "<font face=Verdana size=2><font size=4>XSL Runtime Error</font>" +
	"<P><B>" + exception.description + "</B></P></font>";
}

// Transform the XML document in the element "xml" in place, using "xsl"
function XMLXSL2HTML(xsl, xml) {
    if (xml.parseError.errorCode != 0)
	result = reportParseError(xml.parseError);
    else {
	if (xsl.parseError.errorCode != 0)
      	    result = reportParseError(xsl.parseError);
	else {
       	    try {
		result = xml.transformNode(xsl.XMLDocument);
            } catch (exception) {
		result = reportRuntimeError(exception);
            }
	}
    }

    xml.innerHTML = result;
}
