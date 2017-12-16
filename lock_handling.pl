# description and purpose

# 2learn
#
# 2do
# Function definition
use warnings;
use strict;

my $label_for_no_run = "NO_RUN";
my $myat="@";

require 'data_structures.pl';

sub get_remote_lock
{
   #my $remote_machine1 = $_[0]; 
   #my $rpath = $_[0]; my $rlockfile = $_[1]; 
   my $mymachine = $_[0];
   my $rsyncmd = $data_structures::remote_machine{'rsyncmd'}; 
   my $ruser =   $data_structures::remote_machine{'ruser'}; 
   my $rserver = $data_structures::remote_machine{'rserver'};
   my $rpath = $data_structures::remote_machine{'remote_lock_path'}; 
   my $rlockfile = $data_structures::remote_machine{'remote_lock'}; 
   
   my $cmd = "new command to be defined\n";
   $cmd = $rsyncmd . " " . $ruser . $myat . $rserver . ":" . $rpath . "/" . $rlockfile . " /tmp";
   #print "------------------------------ " . $cmd . "\n"; 
   system( $cmd );
   system ( "sleep 1" );
   
   if ( -f "/tmp/$rlockfile" ) {
      open (INFILE, "/tmp/$rlockfile") or print "Unable in get_remote_lock to open file /tmp/$rlockfile:$!\n";  ######################
      my @conffile = <INFILE> ;
      close INFILE;
      chomp $conffile[0];
      my $no_run = $label_for_no_run;
      if ( $conffile[0] eq $no_run ){ 
         print "Running allone ...\n";
      }
      else{ 
      	 if ( $conffile[0] eq $mymachine ) {
            print "Hmmmmm, this looks like my onwn lock, lets discard this ...\n";
         }
         else {
            print "Running NOT allone, there is already >> $conffile[0] << ...\n";
            die;
         }
     }
   }
   else{
      print data_structures::LOGFILE "Last run din't make a proper lock, pls check, we just continue asuming we are alone!\n";
   }
   print data_structures::LOGFILE "Get_remote_lock $cmd ....................\n";     
}

sub set_remote_lock
{
   #my $rpath = $_[0]; my $rlockfile = $_[1]; 
   my $mymachine = $_[0];
   my $rsyncmd = $data_structures::remote_machine{'rsyncmd'}; 
   my $ruser =   $data_structures::remote_machine{'ruser'}; 
   my $rserver = $data_structures::remote_machine{'rserver'};
   my $rpath = $data_structures::remote_machine{'remote_lock_path'}; 
   my $rlockfile = $data_structures::remote_machine{'remote_lock'}; 
   my $cmd = "echo " . $mymachine . " > /tmp/" . $rlockfile;
   system( $cmd );
      
   $cmd = $rsyncmd . " /tmp/" . $rlockfile . " " . $ruser . "@" . $rserver . ":" . $rpath;
   system( $cmd );
   print data_structures::LOGFILE "Set_remote_lock $cmd ....................\n";  
}

sub clear_remote_lock
{
   #my $remote_machine1 = $_[0]; my $rpath = $_[1]; my $rlockfile = $_[2]; my $mymachine = $_[3];
   my $rsyncmd = $data_structures::remote_machine{'rsyncmd'}; 
   my $ruser =   $data_structures::remote_machine{'ruser'}; 
   my $rserver = $data_structures::remote_machine{'rserver'};
   my $rpath = $data_structures::remote_machine{'remote_lock_path'}; 
   my $rlockfile = $data_structures::remote_machine{'remote_lock'}; 
   
   my $cmd = "echo " . $label_for_no_run . " > /tmp/" . $rlockfile;
   system( $cmd );
   
   $cmd = $rsyncmd . " /tmp/" . $rlockfile . " " . $ruser . "@" . $rserver . ":" . $rpath;
   system( $cmd );
}

sub clear_local_lock
{
   my $lockfile = "";
   $lockfile = shift; # holds the potential lockfile
   #print "Given list in run_once1 $lockfile\n";
   my $mylockfile = $lockfile;
   my $cmd = "rm . $mylockfile"; # wo definiter????
   system( $cmd );
}

sub run_once_check_local_lock
{
   my $lockfile = "";
   $lockfile = shift; # holds the potential lockfile
   #print "Given list in run_once1 $lockfile\n";
   my $mylockfile = $lockfile;
  #if ( -e $lockfile ) {
   	  if ( -f $lockfile ){ 
         #open (INFILE, '<', $lockfile) or die "Unable to open file $lockfile:$!\n"; 
         open (INFILE, '<', $lockfile) or die "Unable in run_once_check_local_lock to open file $lockfile:$!\n"; 
         my @conffile = <INFILE> ;
         close INFILE ;
         print "Already locked by PID @conffile.";
         1
      }
      else {
         # no lock set, so we do it
         create_lock_with_pid( $lockfile );
         0;
      }
   #}  
   #else {
   #  # no lock set, so we do it
   #  create_lock_with_pid( $lockfile );
   #
}


sub create_lock_with_pid
{
   my $lockfile = $_[0]; # holds the future lockfile
   my $process_chk_command = `ps -ef | grep ssh`;	
   my (undef,$pid) = split(' ', $process_chk_command, -1); # needs to be changed - abd passed  
   
   #https://learn.perl.org/examples/read_write_file.html
   #http://stackoverflow.com/questions/318789/whats-the-best-way-to-open-and-read-a-file-in-perl
   #http://alvinalexander.com/perl/perl-write-file-example-read-file-array
   open (OUTFILE, '>', '$lockfile') or die "Unable in create_lock_with_pid to open file $lockfile!\n"; 
   print OUTFILE $pid;
   close OUTFILE;
}


"1;"
