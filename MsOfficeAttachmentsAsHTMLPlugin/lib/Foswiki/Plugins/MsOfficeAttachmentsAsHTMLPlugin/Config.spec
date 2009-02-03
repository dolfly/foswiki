# **COMMAND**
# Command to convert a Word document into HTML. Default is to use wvHtml.
# Use "AbiWord --to=html" if you have AbiWord
$Foswiki::cfg{Plugins}{MsOfficeAttachmentsAsHTMLPlugin}{doc2html} = '/usr/bin/wvHtml --targetdir=%ATTACHDIR|F% %SRC|F% %DEST|F%';

