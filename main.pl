#!/usr/bin/perl -w
my $num_args = $#ARGV+1;
# quit unless we have the correct number of command-line args
my $versionmynumber = "0.57";

use warnings;
use strict;
 
if ($num_args != 9)
{
    print "\nUsage: go.pl rundir rootdir workdir conffile jasonfile excludefile versiondir machinename no/delete\n";
    exit;
}else{
    main( @ARGV );    
}
# check if last element of $rundir is bin
#
# http://stackoverflow.com/questions/2180554/in-perl-is-it-better-to-use-a-module-than-to-require-a-file
#
#use autodie;
#use Cwd qw(chdir);
#
# load the code before chdir

our $centrallogfile = "/var/tmp/joshcentral.log";

require 'data_structures.pl';  # ...
#use vars qw(%all_config);
#use vars qw(%remote_machine);
#use vars qw($LOGFILE); 

require 'read_config.pl';
require 'time_util.pl';

#require 'make_version_and_backup.pl';
#require 'traverse_over_file_system.pl';  # ...

require 'get_date_file_name.pl';

require 'read_config_from_jason.pl';  # ...#

# Function definition

sub main
{
   my ( $rundir, $rootdir, $workdir, $conffile, $jasonfile, $excludefile, $versiondir, $machine, $todelete) = @_;
   
   #initial log here
   my $logfile = "/var/tmp/josh.log";
   open (data_structures::LOGFILE, '>>', $logfile);
   require 'time_util.pl';
   my $TIME_NOW = get_time_stamp(); print "[$TIME_NOW]:Starting gojosh version $versionmynumber....\n";
      
   print data_structures::LOGFILE "[$TIME_NOW]:Reading config-------------------------------------------------\n";
   
   print "Reading config...\n";
   require 'read_config.pl';
   read_config ( $rundir, $conffile, %data_structures::remote_machine ); 

   # now we have the real log
   close data_structures::LOGFILE;
   $logfile = $data_structures::all_config{'local_log_file'};
   open (data_structures::LOGFILE, '>>', $logfile);
   open (data_structures::CENTRALLOGFILE, '>>', $centrallogfile);
   print data_structures::CENTRALLOGFILE "1";
      
   $TIME_NOW = get_time_stamp(); print data_structures::LOGFILE "[$TIME_NOW]:Preparing------------------------------------------------------\n";
   
   prepare_all ( $machine, $rundir, $excludefile );   

   $TIME_NOW = get_time_stamp(); print data_structures::LOGFILE "[$TIME_NOW]: Excluding " . @data_structures::excludedfiles;
      
   require 'dump_util.pl';
   ###dump_config_file ( "/tmp/all_josh_config.txt" ); ### geht nicht
   #require 'read_config_from_jason.pl';  # ...   
   #read_config_from_jason( ( $rundir . "/" .$jasonfile) ); ########## json nicht da 
   
   $TIME_NOW = get_time_stamp(); print data_structures::LOGFILE "[$TIME_NOW]:Read_hash_file------------------------------------\n";
   
   ### loading
   read_hash_file( $data_structures::all_config{'store_local_hash_file_of_local_files'} );
      
   print data_structures::LOGFILE "[$TIME_NOW]:Found " . ( keys %data_structures::oldfilehash ) . " Files -----------------------------------\n";
   print data_structures::LOGFILE "[$TIME_NOW]:Identify_new_files --$data_structures::all_config{'sync_only'}-----------------------------\n";
   
   require 'util.pl';
   make_reverse();
   
   require 'upload_files.pl';
   identify_new_files_n_upload ( 
      $rootdir, 
      $workdir, 
      $data_structures::all_config{'sync_only'}, 
      $rootdir 
   );
 
   ### dumping
   $TIME_NOW = get_time_stamp();
   print data_structures::LOGFILE "[$TIME_NOW]: Found " . ( keys %data_structures::oldfilehash ) . " Files -----------------------------------\n";
   print data_structures::LOGFILE "Dumping now to ". $data_structures::all_config{'store_local_hash_file_of_local_files'} . "\n"; 
   
   dump_hash_file ( 
      $data_structures::all_config{'store_local_hash_file_of_local_files'}
      #, %all_config  
   );
   
   require 'dowload_files.pl';
   use Data::Dumper;
   
   dowload_all_files ( ### macht irgendwie ein tmp
      $rootdir,                      #
      $workdir,                      #
      $data_structures::remote_machine{'remote_lock_path'},
      $versiondir                    #
   );                             # later rsync -l will not get the entire path just the last dir which is actually the workdir 
   
   
   $TIME_NOW = get_time_stamp(); print data_structures::LOGFILE "[$TIME_NOW]:Dowload_all_files-------------------------------------------------------------\n";
   require 'util.pl';
   make_reverse();
   
   if ( $todelete ) {
      require 'delete.pl';
      #delete_remote ( $rootdir, $workdir );
      #delete_local ( $rootdir, $workdir, $versiondir );
   }
   
   #print Dumper( %data_structures::oldfilehash );
   #print Dumper( %data_structures::oldfilereversehash );
   
   dump_hash_file ( 
      $data_structures::all_config{'store_local_hash_file_of_local_files'}
      #, %all_config  
   );
   
   clear_remote_lock();
         
   #$TIME_NOW = get_time_stamp(); print data_structures::LOGFILE "[$TIME_NOW]:Dump_hash_file------$data_structures::all_config->{'store_local_hash_file_of_remote_files'}.new---------------------------\n";
   #dump_remote_hash_file ( 
   #   $data_structures::all_config{'store_local_hash_file_of_remote_files'}
   #   #, %all_config  
   #);
   
   
   #require 'make_version_and_backup.pl';
   #make_version_and_backup( $rootdir, $versiondir );
   $TIME_NOW = get_time_stamp(); print data_structures::LOGFILE "[$TIME_NOW]:Close_all - gojosh @ $machine with $data_structures::actual_time_bias sec bias - version $versionmynumber ---------------------------------------------------------------\n";
   print "[$TIME_NOW]:Finished gojosh @ $machine with $data_structures::actual_time_bias sec bias - version $versionmynumber....\n";
}


sub prepare_all
{
   my $mymachine = $_[0];
   my $rundir = $_[1];
   my $excludefile = $_[2];
   require 'lock_handling.pl';  # ...
   
   run_once_check_local_lock( ( $data_structures::all_config{'lock'} ) ); # ...with /var/log/run/josh.lock
    
   require 'last_run.pl';
   get_last_run( ($data_structures::all_config{'date'} ) ); # ...with /var/log/run/josh.date
   set_last_run ( $data_structures::all_config{'date'} ); # ...with /var/log/run/josh.date
   
   
   require 'data_structures.pl'; 
   use Data::Dumper;
   #print Dumper( %data_structures::all_config );  
   #print Dumper( %data_structures::remote_machine );  
   
   
   get_remote_lock ( $mymachine );
   
   set_remote_lock ( $mymachine );
   
   my $todays_data = $rundir . "/" . $excludefile;
   open INFILE, $todays_data or die "Unable in main to open file $todays_data:$!\n"; 
   @data_structures::excludedfiles = <INFILE> ; 
   close INFILE ;
   #chomp ( @data_structures::excludedfiles ); 
      
   #print $rundir . "/" . $excludefile . "-------\n"; 
   #print @data_structures::excludedfiles;   
   @data_structures::excludedfiles = read_multiple_lines ( $rundir . "/" . $excludefile );
   print data_structures::LOGFILE @data_structures::excludedfiles; 
   
   local $/ = "\r\n";
   for ( my $i = 0; $i < @data_structures::excludedfiles; $i++ ) {
       chomp $data_structures::excludedfiles[$i] ;
   }   
}

sub close_all
{
   clear_remote_lock ( 
      #%data_structures::remote_machine, 
      $data_structures::remote_machine{'remote_lock_path'}, 
      $data_structures::remote_machine{'remote_lock'}, 
      "nix" 
   );
   clear_local_lock ();
}

sub go_mytest
{

   # test
   chdir ('/cygdrive/c/users/a');
   #print(`ls`);
   chdir ('work/bin');
   #print(`ls`);
   
   # test
   opendir(DIR, "/cygdrive/c/users/a/work");
   my @names = readdir(DIR);
   closedir(DIR);
   #print @names;
   

}
#$numArgs = $#ARGV + 1;
#print "thanks, you gave me $numArgs command-line arguments:\n";
#
#foreach $argnum (0 .. $#ARGV) {
#    print "$ARGV[$argnum]\n";
#}


#
#
#    lunch( \@stooges, \@sandwiches );
#
#    sub lunch {
#        my $stoogeref = shift;
#        my $sandwichref = shift;
#
#        my @stooges = @{$stoogeref};
#        my @sandwichref = @{$sandwichref};
#        ...
#    }

