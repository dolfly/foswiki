package Web::oEmbed::Response;
use strict;
use Carp;
use Any::Moose;

has 'http_response', is => 'ro', isa => 'HTTP::Response';

has 'matched_uri', is => 'ro';
has 'type', is => 'rw';
has 'version', is => 'rw';
has 'title', is => 'rw';
has 'author_name', is => 'rw';
has 'author_url', is => 'rw';
has 'provider_name', is => 'rw';
has 'provider_url', is => 'rw';
has 'cache_age', is => 'rw';
has 'thumbnail_url', is => 'rw';
has 'thumbnail_width', is => 'rw';
has 'thumbnail_height', is => 'rw';

has 'web_page', is => 'rw'; # SMELL: non standard
has 'url', is => 'rw';
has 'width', is => 'rw';
has 'height', is => 'rw';

has 'html', is => 'rw';

use HTML::Element;

sub new_from_response {
    my($class, $http_res, $uri) = @_;

    return if $http_res->is_error;

    my $res = $class->new( http_response => $http_res, matched_uri => $uri );

    my $data;

    if ($http_res->content_type =~ /json|text\/plain|javascript/) { # SMELL
        $data = $res->parse_json($http_res->content);
    } elsif ($http_res->content_type =~ /xml/) {
        $data = $res->parse_xml($http_res->content);
    } else {
        croak "Content-Type is not either JSON or XML: " . $http_res->content_type;
    }

    for my $key (keys %$data) {
        if ($res->can($key)) {
            $res->$key( $data->{$key} );
        } else {
            $res->{$key} = $data->{$key};
        }
    }

    $res;
}

sub parse_json {
    my($self, $json) = @_;
    require JSON::XS;
    JSON::XS->new->decode($json);
}

sub parse_xml {
    my($self, $xml) = @_;
    require XML::LibXML::Simple;
    XML::LibXML::Simple->new->XMLin($xml);
}

sub render {
    my ($self, $opts) = @_;

    if ($self->type eq 'photo') {
        my $width = $self->width;
        my $height = $self->height;

        if ($opts->{maxwidth} && $width > $opts->{maxwidth}) {
          $width = $opts->{maxwidth};
          $height = "auto"; # TODO set according to aspect ratio
        } 

        if ($opts->{maxheight} && $height > $opts->{maxheight}) {
          $height = $opts->{maxheight};
          $width = "auto"; # TODO set according to aspect ratio
        } 

        my $element = HTML::Element->new('a', href => $self->web_page || $self->url);
        $element->attr(title => $self->title) if defined $self->title;
        my $img     = HTML::Element->new(
            'img',
            src    => $self->url,
            width  => $width,
            height => $height,
        );
        $img->attr(alt => $self->title) if defined $self->title;

        $element->push_content($img);
        return $element->as_HTML;
    }

    if ($self->type eq 'link') {
        my $element = HTML::Element->new('a', href => $self->url);
        $element->push_content(defined $self->title ? $self->title : $self->url);
        return $element->as_HTML;
    }

    if ($self->html) {
        return $self->html;
    }
}

1;
