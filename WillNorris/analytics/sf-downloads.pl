#! /usr/bin/perl -w
use strict;
use Data::Dumper qw( Dumper );

use List::Util;
use URI::file;
use WWW::Mechanize;
use HTML::TableExtract;
use Spreadsheet::WriteExcel;

my $project_info = {
    foswiki => {
	name => 'Foswiki',
	download_report_url => 'http://sourceforge.net/project/stats/detail.php?group_id=245751&ugn=foswiki&type=prdownload&mode=alltime&file_id=0',
    },
    twiki => {
	name => 'TWiki',
	download_report_url => 'http://sourceforge.net/project/stats/detail.php?group_id=3657&ugn=twiki&type=prdownload&mode=alltime&file_id=0',
    },
};

my $workbook = Spreadsheet::WriteExcel->new( 'foswiki-downloads.xls' ) or die $!;

my @projects_names = qw( foswiki twiki );
my @projects = map { $project_info->{$_} } @projects_names;
foreach my $project ( @projects ) {
    my $idxFile = 0;
    my $uri = $project->{download_report_url};
    while ( $uri ) {

#	my $cache = 'sf-downloads.html';
#	if ( -e $cache ) {
#	    $uri = URI::file->new_abs( $cache );
#	}
	
	my $mech = WWW::Mechanize->new( autocheck => 1,
					agent => 'Foswiki Web Analytics Team',
					cookie_jar => {},
	    ) or die $!;
	$mech->get( $uri ) or die $!;
	my $html = $mech->content();
	
	# SMELL: doesn't work because HTML::TableExtract doesn't work with "funky" characters (like parenthesis)
	#my $te = HTML::TableExtract->new( headers => [ 'Date (UTC)', 'Downloads', 'Bytes Served' ] );
	my $te = $project->{_te} = HTML::TableExtract->new( depth => 0, count => 1 );
	$te->parse( $html );
	
	my $worksheet = $project->{_worksheet} = $workbook->add_worksheet( $project->{name} );
	my $idxRow = 0;
	
	foreach my $ts ( $te->tables ) {
	    $project->{_ts} = $ts;
	    my @r = $ts->rows;
	    my $header_row = shift @r;
	    $project->{_rows} = \@r;
	    foreach my $row ( @r ) {
		next unless $row->[0] =~ /^\w{3}\s\d{4}/;	# ^MMM YYYY
		my $downloads = $row->[1];
		$downloads =~ s/,//g;
		$worksheet->write( $idxRow, 0, [ $row->[0] ] );
		$worksheet->write( $idxRow, 1+$idxFile, [ $downloads ] );
		++$idxRow;
	    }
	}
	$project->{num_months} = $idxRow;

	# TODO: continue looping though each "file_id" of the files presented in the "fmode" form
	++$idxFile;
	undef $uri;
    } # uri
} # project

# find project with the most number of entries
my $max_project = ( sort { $b->{num_months} <=> $a->{num_months} } @projects )[0];
#warn Dumper( $max_project );
my $worksheet = $workbook->add_worksheet( 'versus' );
my $y = 0;
$worksheet->write( $y++, 0, [ 'Month', 'TWiki downloads', 'Foswiki downloads' ] );

my $_y = $y + $max_project->{num_months} - 1;
foreach my $r ( 1 .. $max_project->{num_months} ) {
    $worksheet->write( $_y--, 0, [ $max_project->{_rows}->[$r-1]->[0] ] );
}

# TODO: sort by highest number to show on top, or learn how to control ordering of the columns on the charts better
my @chart_projects = ( $projects[1], $projects[0] );
my $x = 1;
foreach my $project ( @chart_projects ) {
    my $_y = $y + $max_project->{num_months} - 1;	# place numbers in reverse chronological order
    foreach my $r ( 1 .. $max_project->{num_months} ) {
	my $value;
	if ( $r <= $project->{num_months} ) {
	    $value = $project->{_rows}->[$r-1]->[1];
	    $value =~ s/,//g;
	}
	$worksheet->write( $_y--, $x, [ $value ] );
    }
    ++$x;
}

