# description and purpose
#use Cwd qw(chdir);
#use File::Basename;
#
# Function definition
#use warning
# http://www.perlmonks.org/bare/?node_id=580141
# http://www.perlmonks.org/?node_id=1059896
# http://stackoverflow.com/questions/17160468/parse-text-file-and-store-fields-in-hash-table-in-perl
# http://www.perlmonks.org/?node_id=1067022
# http://www.perlmonks.org/?node_id=950591
# https://perlmaven.com/how-to-create-a-perl-module-for-code-reuse
#
#
# http://stackoverflow.com/questions/16791921/how-to-get-the-current-time-in-date-time-in-perl
# http://www.perlmonks.org/?node_id=956717
# http://www.perlmonks.org/?node=How%20do%20I%20get%20a%20file%27s%20timestamp%20in%20perl%3F
use warnings;
use strict;

my $mycmd="ssh";
my $myat="@";
my $mydate="date +%s";
my $myssh="ssh ";
my $remote_tmp_file = "/tmp/mydate";
   
require 'data_structures.pl';  # ... 
require 'read_util.pl';  # ... 
sub get_remote_time_diff_newer
{
   my $rsyncmd = $data_structures::remote_machine{'rsyncmd'}; 
   my $ruser =   $data_structures::remote_machine{'ruser'}; 
   my $rserver = $data_structures::remote_machine{'rserver'};
   my $rpath = $data_structures::remote_machine{'remote_lock_path'}; 
   
   my $cmd = $myssh .  $ruser.$myat.$rserver . " '$mydate > " . $remote_tmp_file . "'";
   my $res0 = system( $cmd );
   
   $cmd = $rsyncmd . " " . $ruser.$myat.$rserver . ":" . $remote_tmp_file . " " . $remote_tmp_file;
   $res0 = system( $cmd );
   my $res1 = read_single_line ( $remote_tmp_file);

   my $res2 = system(("date +%s > " . $remote_tmp_file));
   my $res3 = read_single_line ( $remote_tmp_file);
   #print "Time difference is " . ( $res1 - $res3 ) .  ".\n"; 
   $data_structures::actual_time_bias = $res1 - $res3;
   return ( $res1 - $res3 );
}

sub get_time_stamp
{
  	use Time::Piece;
	my $mytime = Time::Piece->new;
    $mytime;
}

sub print_time
{
	my ($mysecs) = $_[0];
	my $minusprefix = "+";
	if ( $mysecs < 0 ){
	  $minusprefix = "";
	  $mysecs = - $mysecs;
	}
	
	
	if ( $mysecs < 60 ){
	   print data_structures::LOGFILE $minusprefix . int( $mysecs + 0.5) ."sec ";
	}
	elsif (( $mysecs/60) < 60 ) {
	   print data_structures::LOGFILE $minusprefix . int( $mysecs/60 + 0.5) ."min ";
    }	   
	elsif (( $mysecs/3600) < 24 ) {
	   print data_structures::LOGFILE $minusprefix . int( $mysecs/3600 + 0.5) ."h ";
    }	   
	elsif (( $mysecs/(3600*24)) < 30 ) {
	   print data_structures::LOGFILE $minusprefix . int( $mysecs/(3600*24) + 0.5) ." Tage ";
    }	   
	elsif (( $mysecs/(3600*24*30)) < 12 ) {
	   print data_structures::LOGFILE $minusprefix . int( $mysecs/(3600*24*30) + 0.5) ." Monate ";
    }	   
    else{
	   print data_structures::LOGFILE $minusprefix . int( $mysecs/(3600*24*30*12) + 0.5) ." Jahre ";
    }
}

sub remote_file_is_newer
{
    my ($day_of_remote_file) = $_[0];
    my ($time_of_remote_file) = $_[1];
    my ($local_file) = $_[2];
    
 	chomp $day_of_remote_file;
 	chomp $time_of_remote_file;
 	
 	my $myinputtime = $day_of_remote_file . " " . $time_of_remote_file;
 	#my $myformat1 = '%Y/%m/%d %T';
 
	# get date / touch and so
	use File::stat;
	#use Time::localtime;
	my $timestamp = stat($local_file)->mtime;
	my $ctimestamp = ctime ( $timestamp );
	
 	use Date::Parse;
    my $mysecs = ( str2time( $myinputtime ) - str2time ( $ctimestamp ) );
    
    # $format2 = '%a %b %d %T %Y'; #  Sun Mar 19 21:59:35 2017 Sun Mar 19 21:59:35 2017 
    
    #use Time::Piece;
    #my $mysecs = - Time::Piece->strptime($myinputtime, $format1) + Time::Piece->strptime($ctimestamp, $format2); 
			   
    $mysecs;
}

# http://www.perlmonks.org/?node_id=956717 # time stamp from remote file via ssh & perl

sub get_time_diff #( $, $, $ )
{
    my ($myfile) = $_[0];
    my ($seconds) = $_[1];
    my ($hours) = $_[2];
    
			# get date / touch and so
			use File::stat;
			#use Time::localtime;
			my $timestamp = stat($myfile)->mtime;
			
			# first way to calculate, get timestamp from file
			my $startTime = time();
			my $ltimestamp = localtime($^T);
			
			my $sec_difference = $^T - $timestamp;
			
			
			# second way to calculate, get timestamp from file
            use File::stat;
            use Time::localtime; # macht warning, was soll das?
			my $ctimestamp = ctime ( $timestamp );
			#print "1: " . $timestamp . "\n"; #Sun Mar  5 11:28:44 2017
			my $format1 =                       '%a %b  %d %T %Y';
			                                                     
			use Time::Piece;
			my $mytime = Time::Piece->new;
			#print "2: " . $mytime->datetime . "\n"; # outputs: 2013-09-26T16:00:00  or  2017-03-07T06:08:22
			my $format2 =                                       '%Y-%m-%dT%T';

			# http://www.perlmonks.org/?node_id=1043789
			my $sec_difference1 = Time::Piece->strptime($mytime->datetime, $format2)
			 - Time::Piece->strptime($ctimestamp, $format1); 
			#print "File: $myfile - diff in sec/h: " . $day_difference . "  " . int( (($day_difference1 / 3600) + 0.5)) . "\n"; 
              
            # this does not work ...  
            $_[1] = $sec_difference;
            $_[2] = int( (($sec_difference1 / 3600) + 0.5));
            
            # both works, usually 10 sec difference
            # print "$day_difference1 $day_difference \n";
            $sec_difference1;
}

sub get_date_file_name
{
   # http://stackoverflow.com/questions/11020812/todays-date-in-perl-in-mm-dd-yyyy-format

   my $myfile = shift; 
   use Date::Calc qw();
   my ($y, $m, $d, $hour, $min, $sec) = Date::Calc::Today_and_Now();
   my $ddmmyyyy = sprintf '%d.%02d.%02d-%02d-%02d', $y, $m, $d, $hour, $min ;
   #print $ddmmyyyy . "\n";

   #use DateTime qw();
   #print DateTime->now->strftime('%m/%d/%Y')
   $ddmmyyyy = $ddmmyyyy . $myfile;
   $ddmmyyyy;
}

sub prepend_date_file_name
{
   # http://stackoverflow.com/questions/11020812/todays-date-in-perl-in-mm-dd-yyyy-format

   my $myfile = shift; 
   use Date::Calc qw();
   my ($y, $m, $d, $hour,$min,$sec) = Date::Calc::Today_and_Now();
   my $ddmmyyyy = sprintf '%d.%02d.%02d-%02d', $y, $m, $d, $hour ;
   #print $ddmmyyyy . "\n";

   #use DateTime qw();
   #print DateTime->now->strftime('%m/%d/%Y')
   $ddmmyyyy = $ddmmyyyy . $myfile;
   $ddmmyyyy;
}
"1;"