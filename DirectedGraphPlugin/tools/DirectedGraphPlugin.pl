#!/usr/bin/perl 
#
# This file is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read COPYING in the root of this distribution.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Support script for sandbox security mechanism for DirectedGraphPlugin
# Sets environment variables GV_FILE_PATH and SERVER_NAME and calls dot

use strict;
use warnings;

my $runCmd  = $ARGV[0];    # Command to be executed
my $libDir  = $ARGV[1];    # Library directory
my $inFile  = $ARGV[2];    # Input file
my $ioStr   = $ARGV[3];    # Parameters
my $errFile = $ARGV[4];    # Error file
my $logFile = $ARGV[5];    # Debug file if debug enabled, otherwise null

my $debug = 1 if $logFile;
my $verbose = ( $debug ? '-v' : '' );

if ($debug) {
    open( DEBUGFILE, ">>$logFile" );
    print DEBUGFILE "\n----\nCalling dot; got parameters:\n";
    print DEBUGFILE join( "\n", @ARGV ) . "\n";
    close DEBUGFILE;
}

if ( $#ARGV != 5 ) {
    my $usage = <<EOT;
Usage: DirectedGraphPlugin.pl dot_executable working_dir infile iostring errfile logfile

EOT

    if ($debug) {
        open( DEBUGFILE, ">>$logFile" );
        print DEBUGFILE "Received $#ARGV parameters \n";
        print DEBUGFILE $usage;
        close DEBUGFILE;
    }
    die $usage;
}

open( ERRFILE, ">>$errFile" );
print ERRFILE "";
close ERRFILE;

# SERVER_NAME and GV_FILE_PATH need to be set for dot to load custom icons
# (shapefiles)
$ENV{'SERVER_NAME'} = "localhost" unless ( $ENV{'SERVER_NAME'} );
$ENV{'GV_FILE_PATH'} = "$libDir" . "/";
my $execCmd = "$runCmd $verbose $inFile $ioStr 2> $errFile ";

if ($debug) {
    open( DEBUGFILE, ">>$logFile" );
    print DEBUGFILE "Built command line: " . $execCmd . "\n";
    print DEBUGFILE "  Env GV_FILE_PATH: " . $ENV{'GV_FILE_PATH'} . "\n";
    close DEBUGFILE;
}

my $execError = "";
system("$execCmd");    # Execute the command

if ( $? != 0 ) {
    if ( $? == -1 ) {
        $execError = "failed to execute: $!\n";
    }
    elsif ( $? & 127 ) {
        $execError = sprintf(
            "child died with signal %d, %s coredump\n",
            ( $? & 127 ),
            ( $? & 128 ) ? 'with' : 'without'
        );
    }
    else {
        if ( $? >> 8 == 1 ) {

            # dot could be signalling warnings rather than fatal errors so
            # check if it actually created the output files before we die
            my @dotfiles = $ioStr =~ /-o(\S+)/g;
            foreach my $dotfile (@dotfiles) {
                unless ( -s $dotfile ) {
                    $execError =
                      sprintf( "child exited with value %d\n", $? >> 8 );
                    last;
                }
            }
        }
        else {
            $execError = sprintf( "child exited with value %d\n", $? >> 8 );
        }
    }

    if ($execError) {
        if ($debug) {
            open( DEBUGFILE, ">>$logFile" );
            print DEBUGFILE "$execError\n";
            close DEBUGFILE;
        }

        open( ERRFILE, ">>$errFile" );
        print ERRFILE "Problem executing dot command: '$execCmd', got:\n";
        print ERRFILE "$execError\n ";
        close ERRFILE;
        die "Problem executing dot command";
    }
}

if ($debug) {
    open( DEBUGFILE, ">>$logFile" );
    print DEBUGFILE "dot exited with value ".($? >> 8)."\n";
    close DEBUGFILE;
}
1;
