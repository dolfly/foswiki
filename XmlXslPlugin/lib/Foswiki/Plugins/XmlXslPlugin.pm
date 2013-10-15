#
package Foswiki::Plugins::XmlXslPlugin;

use strict;

our $VERSION           = '1.0.0';
our $RELEASE           = '$Rev$';
our $NO_PREFS_IN_TOPIC = 1;
our $SHORTDESCRIPTION =
  'Return HTML created from the application of an XSL to some XML';

our %blocks;
our $counter;

our $UNIQUE = "\7X\6M\5L";

sub initPlugin {
    %blocks = ();
    Foswiki::Func::registerTagHandler( 'XMLXSLTRANSFORM', \&XMLXSLTRANSFORM );
    $counter = 0;

    return 1;
}

sub completePageHandler {

    # Replace tags with generated HTML
    while ( my ( $k, $v ) = each %blocks ) {
        $_[0] =~ s/$UNIQUE$k/$v/;
    }
}

sub onFirstExpansion {
    Foswiki::Func::addToZone( 'script', 'XML2XSL_base', <<SCRIPT);
<script language="javascript">
</script>
SCRIPT

}

sub getTopicContent {
    my ( $web, $name ) = @_;
    my ( $webName, $topicName ) =
      Foswiki::Func::normalizeWebTopicName( $web, $name );

    # check if the topic exists
    if ( Foswiki::Func::topicExists( $webName, $topicName ) ) {

        # the topic does exist so read from the file
        my ( $meta, $text ) = Foswiki::Func::readTopic( $webName, $topicName );
        return $text;
    }
    return '';

}

sub XMLXSLTRANSFORM {
    my ( $session, $params, $topic, $web, $topicObject ) = @_;

    my $xmlsource = $params->{xml};
    my $xslsource = $params->{xsl};
    my $csssource = $params->{css} || "";

    # Must generate a valid HTML element id
    my $id = $params->{id} || 'xmlxsl2html:' . $counter;

    unless ($counter) {
        onFirstExpansion();
        $counter++;
    }

    my $cssisland = '';
    if ( $csssource =~ /(^http|.css)/ ) {
        $cssisland = <<CSS1;
<style type="text/css" media="all">
    \@import url($csssource);
</style>
CSS1
    }
    else {

        # get the CSS from a topic
        my $cssTopicText = getTopicContent( $web, $csssource );
        $cssisland = <<CSS2;
<style type="text/css" media="all">
<!--
$cssTopicText
-->
</style>
CSS2
    }

    my $xmldataisland = "";
    if ( $xmlsource =~ /(^http|.xml|.xsl)/ ) {
        $xmldataisland = <<DATA;
<!--Remote XML source--><XML id="$id" src="$xmlsource"></XML>
DATA
    }
    else {

        my $xmlTopicText = getTopicContent( $web, $xmlsource );

        if ( length($xmlTopicText) > 0 ) {
            $xmldataisland = "<XML id=\"$id\">$xmlTopicText</XML>";
        }
        else {

            # the topic does not exist so put in anything
            $xmldataisland =
"<font size='+2'>The XML you specified, $xmlsource, does not exist </font>";
        }
    }

    my $xsldataisland = "";
    if ( $xslsource =~ /(^http|.xml|.xsl)/ ) {
        $xsldataisland = "<XML id=\"style$id\" src=\"$xslsource\"></XML>";
    }
    else {

        my $xslTopicText = getTopicContent( $web, $xslsource );

        if ( length($xslTopicText) > 0 ) {
            $xsldataisland = "<XML id=\"style$id\">$xslTopicText</XML>";
        }
        else {

            # the topic does not exist so put in just the XML
            $xsldataisland =
"<font size='+2'>The XSL you specified, $xslsource, does not exist </font>";
        }
    }

    Foswiki::Func::addToZone( 'script', 'XML2XSL_' . $id, <<SCRIPT);
<script language="javascript">XMLXSL2HTML(style$id, $id)</script>
SCRIPT

    $blocks{$id} = <<DATA;
<!--XMLXSL START-->
<!--CSSISLAND-->
$cssisland
<!--CSSISLAND-->
<!--XMLISLAND-->
$xmldataisland
<!--XMLISLAND-->
<!--XSLISLAND-->
$xsldataisland
<!--XSLISLAND END-->
<div id="$id"></div>
<!--XMLXSL END-->
DATA
    return "$UNIQUE$id";
}

1;
