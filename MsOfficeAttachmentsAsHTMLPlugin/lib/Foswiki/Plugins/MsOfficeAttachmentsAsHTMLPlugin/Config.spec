#---+ Extensions
#---++ MsOfficeAttachmentsAsHTMLPlugin
# **COMMAND**
# Command to convert a Word document into HTML. Default is to use wvHtml.
# Use "AbiWord --to=html" if you have AbiWord
$Foswiki::cfg{Plugins}{MsOfficeAttachmentsAsHTMLPlugin}{doc2html} = '/usr/bin/wvHtml --targetdir=%ATTACHDIR|F% %SRC|F% %DEST|F%';
# **PERL**
# Regex filters that are used to post-process the HTML, for example to correct
# paths.
$Foswiki::cfg{Plugins}{MsOfficeAttachmentsAsHTMLPlugin}{filters} = [
    's#(<img[^>]*\bsrc=)(["\'])([^/]+?)\\2#$1$2%ATTACHURL%/$3$2#sgi'
];
