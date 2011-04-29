# JSON-RPC for Foswiki
#
# Copyright (C) 2011 Michael Daum http://michaeldaumconsulting.com
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

package Foswiki::Contrib::JsonRpcContrib::Request;
use JSON ();
use Foswiki::Contrib::JsonRpcContrib::Error ();
use Error qw( :try );
use Foswiki::Func ();
use constant DEBUG => 0; # toggle me

###############################################################################
sub new {
  my ($class, $session) = @_;

  my $request = $session->{request};
  my $this = bless({}, $class);

  # get json-rpc request object
  my $data = $request->param('POSTDATA');
  if ($data) {
    $data = fromUtf8($data);
  } else {
    # minimal stup
    $data = '{"jsonrpc":"2.0"}';
  }
  writeDebug("data=$data");
  $this->initFromString($data);

  # get namespace from path info, maybe separate a REST-like method as well
  my $namespace = $request->pathInfo();
  my $method;
  if ($namespace =~ /^\/?([^\/]+)(?:\/(.*))?$/) {
    $namespace = $1;
    $method = $2; 
  }
  $this->namespace($namespace);
  writeDebug("namepsace=$namespace");

  # override json-rpc params using url params
  foreach my $key ($request->param()) {
    next if $key =~ /^(POSTDATA|method|id|jsonrpc)$/; # these are different
    my $val = fromUtf8($request->param($key));
    $request->param($key => $val); # play back to request
    $this->param($key, $val); # override json-rpc params using url params
  }

  # copy id from url params to  json-rpc request if required
  my $id = $request->param('id') || $this->id();
  $this->id($id) if defined $id;

  # copy method to json-rpc request 
  $method = $request->param("method") if defined $request->param("method");
  $this->method($method) if defined $method;

  # check that this is a http POST
  throw Foswiki::Contrib::JsonRpcContrib::Error(-32600, "Method must be POST")
    unless $request->method() =~ /post|jsonrpc/i;

  # some basic checks if this is a proper json-rpc 2.0 request
  
  # must have a version tag
  if (($this->version()||'') ne "2.0") { 
    throw Foswiki::Contrib::JsonRpcContrib::Error(-32600, "Invalid JSON-RPC request - must be jsonrpc: '2.0'");
  }

  # must have a method
  throw Foswiki::Contrib::JsonRpcContrib::Error(-32600, "Invalid JSON-RPC request - no method")
    unless defined $this->method();

  writeDebug("method=".$this->method());

  # must not have any other keys other than these
  foreach my $key (keys %{$this->{data}}) {
    throw Foswiki::Contrib::JsonRpcContrib::Error(-32600, "Invalid JSON-RPC request - unknown key $key")
      unless $key =~ /^(jsonrpc|method|params|id)$/;
  }

  return $this;
}

##############################################################################
sub initFromString {
  my ($this, $data) = @_;

  # parse json-rpc request
  eval {
    $this->{data} = $this->parser->decode($data);
  };

  if ($@) {
    my $error = $@;
    $error =~ s/,? +at.*$//s;
    throw Foswiki::Contrib::JsonRpcContrib::Error(-32700, "Parse error - invalid json-rpc request: $error");
  }

  $this->{data}{params} ||= {};

  return $this->{data};
}

##############################################################################
sub version {
  my ($this, $value) = @_;

  $this->{data}{jsonrpc} = $value if defined $value;
  return $this->{data}{jsonrpc};
}

##############################################################################
sub id {
  my ($this, $value) = @_;

  $this->{data}{id} = $value if defined $value;
  return $this->{data}{id};
}

##############################################################################
sub param {
  my ($this, $key, $value) = @_;

  $this->{data}{params}{$key} = $value if defined $value;
  return $this->{data}{params}{$key};
}

##############################################################################
sub method {
  my ($this, $value) = @_;

  $this->{data}{method} = $value if defined $value;
  return $this->{data}{method};
}

##############################################################################
sub namespace {
  my ($this, $value) = @_;

  $this->{namespace} = $value if defined $value;
  return $this->{namespace};
}

##############################################################################
sub parser {
  my $this = shift;

  unless (defined $this->{parser}) {
    $this->{parser} = new JSON;
  }

  return $this->{parser};
}

################################################################################
# static
sub writeDebug {
  print STDERR '- JsonRpcContrib::Request - '.$_[0]."\n" if DEBUG;
}

###############################################################################
sub fromUtf8 {
  my $string = shift;

  return $string unless $string;

  my $charset = $Foswiki::cfg{Site}{CharSet};
  return $string if $charset =~ /^utf-?8$/i;

  if ($] < 5.008) {

    # use Unicode::MapUTF8 for Perl older than 5.8
    require Unicode::MapUTF8;
    if (Unicode::MapUTF8::utf8_supported_charset($charset)) {
      return Unicode::MapUTF8::from_utf8({ -string => $string, -charset => $charset });
    } else {
      Foswiki::Func::writeWarning("Conversion from $charset no supported, ' . 'or name not recognised - check perldoc Unicode::MapUTF8");
      return $string;
    }
  } else {

    # good Perl version, just use Encode
    require Encode;
    import Encode;
    my $encoding = Encode::resolve_alias($charset);
    if (not $encoding) {
      Foswiki::Func::writeWarning("Warning: Conversion from $charset not supported, or name not recognised - check perldoc Encode::Supported");
      return $string;
    } else {

      # converts to $charset, generating HTML NCR's when needed
      my $octets = $string;
      $octets = Encode::decode('utf-8', $string) unless utf8::is_utf8($string);
      return Encode::encode($encoding, $octets, 0);#&Encode::FB_HTMLCREF());
    }
  }
}


1;
