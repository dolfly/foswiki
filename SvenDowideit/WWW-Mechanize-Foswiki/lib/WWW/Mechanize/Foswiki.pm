
package WWW::Mechanize::Foswiki;

use warnings;
use strict;

use Exporter;
use WWW::Mechanize;

our @ISA = qw(Exporter WWW::Mechanize);

our %EXPORT_TAGS = ( 'all' => [qw()] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw();

use Digest::MD5;
use Carp;

=head1 NAME

WWW::Mechanize::Foswiki - simplify importing and exporting data from foswiki

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WWW::Mechanize::Foswiki;

    my $foo = WWW::Mechanize::Foswiki->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new {
    my $class = shift;
    my %args  = @_;

    my %mechanize_args;
    my @cols = grep( /(cgibin|scriptSuffix|pub|username|password)/,
        keys(%mechanize_args) );
    @mechanize_args{@cols} = @args{@cols};

    my $self = $class->SUPER::new(
        stack_depth => 1,
        cookie_jar  => {},
        %mechanize_args
    );

    $self->{cgibin} = $args{cgibin} if ( defined( $args{cgibin} ) );
    $self->{scriptSuffix} = $args{scriptSuffix} || '';
    $self->{pub}      = $args{pub}      if ( defined( $args{pub} ) );
    $self->{username} = $args{username} if ( defined( $args{username} ) );
    $self->{password} = $args{password} if ( defined( $args{password} ) );

    if (    defined( $self->{cgibin} )
        and defined( $self->{username} )
        and defined( $self->{password} ) )
    {

#we can set up the basic auth credentials now
#TODO: really need to defer this until we can detect if its digest, basic, or templatelogin
#at that point, $args{autocheck}=>1 will have to be turned off.
        $self->credentials();
    }

    return $self;
}

=head2 credentials($username, $password)

parameters optional - may as well set these when we start.

currently assumes we're using basic auth.
need to wait until we know what the server is asking - what about Digest?

=cut

sub credentials {
    require MIME::Base64;
    my $self     = shift;
    my $username = shift || $self->{username};
    my $password = shift || $self->{password};

    $self->SUPER::credentials( $self->{cgibin}, '', $username, $password );
    $self->add_header( Authorization => 'Basic '
          . MIME::Base64::encode( $username . ':' . $password ) );
}

=head2 getPageList

=cut

sub getPageList {
    my $self      = shift;
    my $iWeb      = shift;
    my $overrides = shift || {};

    my $tagStartTopics = '__TOPICS__';
    my $xxx            = $self->foswikiRequest(
        'search',
        $iWeb,
        {
            skin     => '',  # has no (real/positive) effect during a search :-(
            nosearch => 'on',
            nototal  => 'on',
            scope     => 'topic',
            search    => '.+',
            regex     => 'on',
            format    => '<topic>$web.$topic</topic>',
            separator => '$n',
            header    => "!$tagStartTopics",
            %{$overrides},    # overrides these defaults
        }
    );

    #TODO: test with i8n foswiki
    my $topic = $xxx->decoded_content();

    $topic =~ s|^.+?$tagStartTopics||s;    # strip up to start tag
    $topic =~ s|<p />.+?$||s;              # strip after formatted output

    my @topics = ();
    while ( $topic =~ /<topic>([^<]+?)<\/topic>/gi ) {
        push @topics, $1;
    }

    return @topics;
}

=head2 getAttachmentsList

=cut

sub getAttachmentsList {
    my $self  = shift;
    my $topic = shift;
    my $parms = shift;

    my @attachments = ();

    my $attachments = $self->attach($topic)->content();

    my @cols = qw( Attachment Comment Attribute );

    # qw(I Attachment Action Size Date Who Comment Attribute)
    my $te = HTML::TableExtract->new( headers => [@cols] ) or die $!;
    $te->parse($attachments);

    foreach my $row ( $te->rows ) {
        my %attach = ();
        my $idxCol = 0;
        foreach my $col (@cols) {
            my $data = $row->[ $idxCol++ ];
            $data =~ s/^\s+//;
            $data =~ s/\s+$//;
            $attach{$col} = $data;
        }
        ( my $attachTopic = $topic ) =~ s|\.|\/|;
        $attach{_filename}  = $attach{Attachment};
        $attach{Attachment} = "$self->{pub}/$attachTopic/" . $attach{_filename};
        push @attachments, { %attach, };
    }

    return @attachments;
}

sub _templateLogin {
    my $self = shift;

    return if ( $self->{loggedIn} );

    $self->foswikiRequest( 'login', 'System.WebHome' );
    $self->form_name('loginform');
    $self->set_fields(
        username       => $self->{username},
        password       => $self->{password},
        validation_key => $self->_strikeone()
    );
    $self->click_button( value => 'Logon' );
    $self->{loggedIn} = 1;
}

###### from BuildContrib
sub _strikeone {
    my $this = shift;

    my $validationKey = $this->value('validation_key');
    if ( not defined $validationKey ) {
        warn "WARNING: The form does not have a validation_key field\n";
        return '';
    }

    my $cookie;
    $this->cookie_jar()->scan(
        sub {
            my ( $version, $key, $value ) = @_;
            $cookie = $value if $key eq 'FOSWIKISTRIKEONE';
        }
    );
    if ( not defined $cookie ) {
        warn
"WARNING: Could not find strikeone cookie in cookiejar - disabling strikeone\n";
        return $validationKey;
    }
    $validationKey =~ s/^\?//;

    return Digest::MD5::md5_hex( $validationKey . $cookie );
}

=head2 NO_AUTOLOAD

maps function calls into twiki urls

Sven doesn't like this :) it will try to create any method that doesn't exist - like $self->Dumper(...

=cut

sub NO_AUTOLOAD {
    our ($AUTOLOAD);
    no strict 'refs';
    ( my $action = $AUTOLOAD ) =~ s/.*:://;

    #print STDERR "--- $AUTOLOAD, $action\n";
    *$AUTOLOAD = sub {
        my ( $self, $topic, $args ) = @_;
        return $self->foswikiRequest( $action, $topic, $args );
    };
    goto &$AUTOLOAD;
}

=head2 foswikiRequest($action, $topic, $args)


=cut

sub foswikiRequest {
    my $self   = shift;
    my $action = shift;
    my $topic  = shift;
    my $args   = shift;

    croak "no topic on action=[$action]" unless $topic;
    croak "no cgibin" unless $self->{cgibin};

#login if we havn't already (oh boy this is hacky, but as the AUTOLOAD has to go, there's not much point doing more)
    $self->_templateLogin() unless ( $action eq 'login' );

    $args->{skin} = 'plain';
    ( my $url =
          URI->new("$self->{cgibin}/$action$self->{scriptSuffix}/$topic") )
      ->query_form($args);
    my $response = $self->get($url);

    my $u     = URI->new($url);
    my $error = {};
    if ( grep { /^oops\b/ } $u->path_segments() ) {
        my %form = $u->query_form();
        ( $error->{error} = $form{template} ) =~ s/^oops(.+?)/$1/;

     # convert all the named (semi-) generic param# parameters into a perl array
        map { push @{ $error->{message} }, $form{$_} }
          sort grep { /^param\d+$/ } keys %form;
    }

    return $response;
}

sub DESTROY {
}

=head1 AUTHOR

Sven Dowideit, C<< <SvenDowideit at home.org.au> >>
Will Norris, E<lt>wbniv@cpan.orgE<gt>


=head1 COPYRIGHT AND LICENSE

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-mechanize-foswiki at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Mechanize-Foswiki>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Mechanize::Foswiki


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Mechanize-Foswiki>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Mechanize-Foswiki>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Mechanize-Foswiki>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Mechanize-Foswiki/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2004,2006 Will Norris
Copyright 2010 Sven Dowideit.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of WWW::Mechanize::Foswiki
