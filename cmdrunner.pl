#!/usr/bin/perl

use strict;
use warnings;

# Testcase statistics
our $pass  = 0;
our $fail  = 0;
our $total = 0;

# Function - execute
# Description - executes the command in console
# Arguments - log file handle, command, return value, output msg substring, iteration
sub execute {
    my $log = shift;
    my $test = shift;
    my $cmd = shift;
    my $ret = shift;
    my $out = shift;
    my $num = shift;
    my $res;
    my $count = 0;

    while( $count < $num ) {
        $total++ if( $test ); 
        print $log "Executing command : $cmd\n";
        $res = `$cmd `;
        print $log "Return value : $?\n";
        print $log "CLI Output : $res\n";
        if( $? != $ret ) {
            print( "F");
            print $log "Executing $cmd - FAIL\n";
            $fail++ if( $test );
            goto end;
        } 
        if( $out ne "null" and $res !~ /$out/gi ) {
            print( "F\n" );
            print $log "Executing $cmd - FAIL\n";
            $fail++ if( $test );
            goto end;
        }
        print( "." );
        print $log "Executing $cmd - PASS\n";
        $pass++ if( $test );
        end: $count++ if( $test );
        print $log "-"x60;
        print $log "\n";
    }
}

# Function - main
sub main {
    my $file = $ARGV[0];
    my $fileh;
    my $cmd;
    my $testcase;
    my $out;
    my $ret;
    my $num;
    my @time = localtime(time);
    my $logfile = "log$time[2]$time[1]$time[0]_$time[4]$time[3].log";
    my $log;

    # Check for the availability of the required argument
    if( @ARGV != 1 ) {
        print( "Error: missing the recipe file\n" );
        return 1;
    }
    
    # open the logfile
    open( $log, ">>$logfile" ) or die( "Unable to create logfile" );
    
    # open the recipe file
    open( $fileh, $file ) or die( "Unable to open the file" );

    while( <$fileh> ) {
        if( /(0|1)\s+"([\S\s]*)"\s+(0|1)\s+"([\S\s]*)"\s+([0-9]+)/ ) {
            $testcase = $1;
            $command = $2;
            $retval  = $3;
            $outval  = $4;
            $iteration = $5;
            chomp( $cmd );
            chomp( $ret );
            chomp( $out );
            chomp( $num );
            &execute( $log, $testcase, $cmd, $ret, $out, $iteration );
        }
    }
    
    print "-"x80;
    print "\n";
    print( "TOTAL: $total\nPASS : $pass\nFAIL : $fail\n" );

    # close the recipe
    close( $fileh );
    close( $log );
}

# Execution starts from here
&main();
