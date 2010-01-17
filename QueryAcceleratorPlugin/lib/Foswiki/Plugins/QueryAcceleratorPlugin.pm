# Please see the bottom of this file for license and copyright information

=begin TML

---+ package Foswiki::Plugins::QueryAcceleratorPlugin

Plugin for an alternative query algorithm using DBCacheContrib

=cut

package Foswiki::Plugins::QueryAcceleratorPlugin;

use strict;
use Error qw(:try);
use Assert;

use Sleepycat::DbXml;

use Foswiki::Meta ();
use Foswiki::Func ();

our $NO_PREFS_IN_TOPIC = 1;
our $SHORTDESCRIPTION = 'Accelerate standard queries in large webs';
our $RELEASE = '5 Jun 2009';
our $VERSION = '$Rev$';
our $env;

sub initPlugin {
    Foswiki::Func::registerRESTHandler('makedb', \&_RESTmakeDB);
    Foswiki::Func::registerTagHandler('XPATH', \&_XPATH);
    return 1;
}

# Update the cache when a topic is saved
sub afterSaveHandler {
    my ( $text, $topic, $web, $error, $meta ) = @_;
}

sub _openDBEnv {
    $env = new DbEnv(0);
    $env->set_cachesize(0, 64 * 1024 * 1024, 1);
    $env->open(Foswiki::Func::getWorkArea('QueryAcceleratorPlugin'),
               Db::DB_INIT_MPOOL | Db::DB_CREATE | Db::DB_INIT_LOCK
                   | Db::DB_INIT_LOG | Db::DB_INIT_TXN, 0);
    return new XmlManager($env);
}

# Handle the %XPATH{path}% tag
sub _XPATH {
    my ($session, $params, $topic, $web ) = @_;
    my $query = $params->{_DEFAULT};

    my $xmlman = _openDBEnv();
    my $txn = $xmlman->createTransaction();
    my $xmlcon = $xmlman->openContainer($txn, 'foswiki.dbxml');
    $txn->commit();
    my $context = $xmlman->createQueryContext();

    #  Perform the query. Result type is by default Result Document
    my $fullQuery = "collection('" .$xmlcon->getName() . "')$query";
    my $item;
    eval {
        print STDERR "Exercising query '$fullQuery' \n";
        my $results = $xmlman->query($fullQuery, $context );
        die "Result set != 1" unless $results->size() == 1 ;
        my $value = new XmlValue();
        while( $results->next($value) ) {
            # Retrieve the value as a document
            my $theDocument = $value->asDocument();
            # wildcard in the query expression allows us to not worry
            # about what namespace this document uses.
            $item = _getValue(
                $xmlman, $theDocument, "/*/product/text()", $context);
            print STDERR "Got $item\n";
        }
    };

    if (my $e = catch std::exception) {
        return "Query $fullQuery failed: ". $e->what();
    } elsif ($@) {
        return "Query $fullQuery failed: $@";
    }
    return $item;
}

# Create a new XML database, and populate it with our content.
sub _RESTmakeDB {

    my $xmlman = _openDBEnv();
    my $txn = $xmlman->createTransaction();
    my $xcc = new XmlContainerConfig();
    $xcc->setAllowCreate(1);
    my $xmlcon = $xmlman->openContainer($txn, 'foswiki.dbxml', $xcc);
    $txn->commit();
    eval {
        $txn = $xmlman->createTransaction();
        my $xmlDoc;
        eval {
            $xmlDoc = $xmlcon->getDocument($txn, 'foswiki');
            if ($xmlDoc) {
                $xmlcon->deleteDocument($txn, $xmlDoc);
                $txn->commit();
                $txn = $xmlman->createTransaction();
            }
        };

        $xmlDoc = $xmlman->createDocument();
        $xmlDoc->setName('foswiki');

        my @webs = grep { !/\// } Foswiki::Func::getListOfWebs();
@webs = qw(Main);
        my $xml = '<root xmlns="http://foswiki.org/Support/XTML/">';
        foreach my $web (grep { !/\// } @webs) {
            my $wObj = new Foswiki::Meta($Foswiki::Plugins::SESSION, $web);
            $xml .= xml($wObj, 0, 1);
        }
        $xml .= '</root>';

        $xmlDoc->setContent($xml);
        $xmlcon->putDocument($txn, $xmlDoc);
        $txn->commit();
    };

    if (my $e = catch std::exception) {
        print STDERR $e->what();
    };
}

sub _cdata {
    my $text = shift;
    # Escape out ]]>
    $text =~ s/]]>/]]><![CDATA[>]]><![CDATA[/g;
    return '<![CDATA['.$text.']]>';
}

sub _attribute {
    my ($k, $v) = @_;

    return $k.'="'._entityEscape($v).'"';
}

sub _entityEscape {
    # XML requires < and & to be escaped in attribute values. We add
    # " to this to allow us to use double-quoted strings for attributes.
    my $string = shift;

    $string =~ s/&/&amp;/g;
    $string =~ s/</&lt;/g;
    $string =~ s/"/&quot;/g;
    return $string;
}

=begin TML

---++ xml( $metaObject, $fullpath, [$notroot] ) -> $xmlString

Generate an XML string that represents the contents of the object.

If $fullpath is true, will generate pseudo-containers for containing webs.

For example, if we have an object for a web =X/Y= then *without* $fullpath
this method will generate =<web name="Y"</web>=. However *with* $fullpath
it will generate =<web name="X"><web name="Y"</web></web>=.

A namespace specifier will be generated with a default namespace if
$notroot is false (the default when this method is not being called
recursively)

=cut

sub xml {
    my ($meta, $fullpath, $notroot) = @_;
    my $xml = '';
    my $webPath = $meta->web();
    my $dns = ''; # default namespace attribute

    unless ($notroot) {
        $dns .= ' xmlns="http://foswiki.org/Support/XTML/"';
    }
    if ($meta->topic()) {
        # Get the text first, to get a lazy load if necessary
        my $text = $meta->text();
        $xml .= "<topic$dns name=\"".$meta->topic().'"';
        my $ti = $meta->get('TOPICINFO');
        if ($ti) {
            while (my ($k, $v) = each %$ti) {
                $xml .= ' '._attribute($k, $v);
            }
        }
        $xml .= '>';
        # Handle the embedded form first. This schema allows us
        # to embed multiple different form types (future-proof)
        my $form = $meta->get('FORM');
        if ($form) {
            $xml .= '<form '._attribute('name', $form->{name}).'>';
            foreach my $field (@{$meta->{FIELD}}) {
                $xml .= '<field ';
                while (my ($k, $v) = each %$field) {
                    next if ($k eq 'value');
                    $xml .= _attribute($k, $v).' ';
                }
                $xml .= '>';
                if (defined $field->{value}) {
                    $xml .= '<value>';
                    # Don't really need to do this, but it just makes the
                    # XML a bit more readable.
                    if ($field->{value} =~ /\n/s) {
                        $xml .= _cdata($field->{value});
                    } else {
                        $xml .= _entityEscape($field->{value});
                    }
                    $xml .= '</value>';
                }
                $xml .= '</field>';
            }
            $xml .= '</form>';
        }
        foreach my $type (grep { !/^_/ } keys %$meta) {
            next if ($type =~ /^(FORM|FIELD|TOPICINFO)$/);
            foreach my $item (@{$meta->{$type}}) {
                $xml .= '<'.lc($type).' ';
                while (my ($k, $v) = each %$item) {
                    $xml .= _attribute($k, $v).' ';
                }
                $xml .= '/>';
            }
        }
        # SMELL: no escaping of ]]> in the text
        $xml .= '<body>'._cdata($text).'</body>';
        $xml .= '</topic>';
    } else {
        my $it = $meta->eachTopic();
        while ($it->hasNext()) {
            my $topic = $it->next();
            my $tom = new Foswiki::Meta(
                $meta->session(), $meta->web(), $topic);
            $xml .= xml($tom, 0, 1);
        }
        $it = $meta->eachWeb();
        while ($it->hasNext()) {
            my $subweb = $it->next();
            my $topic = $it->next();
            my $tom = new Foswiki::Meta(
                $meta->session(), $meta->web()."/$subweb");
            $xml .= xml($tom, 0, 1);
        }
        $webPath =~ s#/?([^/]*$)##;
        $xml = "<web$dns "._attribute('name', $1).">$xml</web>";
    }

    # if fullpath is requested, generate web pseudo-containers
    # down to this web
    if ($fullpath) {
        while ($webPath) {
            $webPath =~ s#/?([^/]*)$##;
            $xml = "<web$dns "._attribute('name', $1).'>'.$xml.'</web>';
        }
    }

    return $xml;
}

1;
__DATA__
# Module of Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2009 Foswiki Contributors. All Rights Reserved.
# Foswiki Contributors are listed in the AUTHORS file in the root
# of this distribution. NOTE: Please extend that file, not this notice.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# As per the GPL, removal of this notice is prohibited.
#
# Author: Crawford Currie
