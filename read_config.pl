# description and purpose

# 2learn
#
# 2do
# Function definition
#
use warnings;
use strict;
require 'data_structures.pl';  # ... sonst verliert er in main beim Übergang eines der Hashes
require 'read_util.pl';

sub read_config 
{
   my $rundir = shift;
   my $conffile = shift;
   #print $rundir . "/" . $conffile;  ## remark, there is a tird argument provided which is not taken here
   
   # get all params
   my $todays_data = $rundir . "/" . $conffile;      #'/var/tmp/somefile' ;
   open INFILE, $todays_data or die "Unable in read_config to open file $todays_data:$!\n"; 
   my @conffile = <INFILE> ;
   close INFILE;
   
   print data_structures::LOGFILE @conffile;
      
   # delete the comments from the array with splice
   for my $index (reverse 0..$#conffile) {
      if ( $conffile[$index] =~ /\#/ ) {
        splice(@conffile, $index, 1, ());
      }
   }
   #$conffile[0]; # .hashtree
   $conffile[1] = clean ( $conffile[1] );
   $data_structures::all_config{'lock'} = $conffile[1]; # ...with /var/log/run/josh.lock
   $conffile[2] = clean ( $conffile[2] );
   $data_structures::all_config{'date'} = $conffile[2]; # ...with /var/log/run/josh.date
   $conffile[3] = clean ( $conffile[3] );
   $data_structures::all_config{'hashfile'} = $conffile[3]; # ...with ???
   $conffile[4] = clean ( $conffile[4] );
   $data_structures::all_config{'keep_file_versions'} = $conffile[4]; # ...with keep_2_file_versions
   $conffile[5] = clean ( $conffile[5] );
   $data_structures::all_config{'sync_only'} = $conffile[5]; # ...with sync_only_2_weeks
   $conffile[6] = clean ( $conffile[6] );
   $data_structures::all_config{'use_simple_perl'} = $conffile[6]; # ...with use_simple_perl
   
   $conffile[7] = clean ( $conffile[7] );
   $data_structures::remote_machine{'rsyncmd'} = $conffile[7]; # ...with rsync -r -e 'ssh'
   $conffile[8] = clean ( $conffile[8] );
   $data_structures::remote_machine{'ruser'} = $conffile[8]; # ...with ste
   $conffile[9] = clean ( $conffile[9] );
   $data_structures::remote_machine{'rserver'} = $conffile[9]; # ...with 62.112.157.54
   
   # 2 mal lock
   $conffile[10] = clean ( $conffile[10] );
   $data_structures::remote_machine{'remote_lock_path'} = $conffile[10]; # ...with /tmp/myowncloud
   $conffile[11] = clean ( $conffile[11] );
   $data_structures::remote_machine{'remote_lock'} = $conffile[11]; # ...with myowncloud.lock
   
   # 2 mal divers
   $conffile[12] = clean ( $conffile[12] );
   $data_structures::all_config{'local_log_file'} = $conffile[12]; # ...with /var/tmp/josh.log
   
   $conffile[13] = clean ( $conffile[13] );
   $data_structures::all_config{'remote_storage'} = $conffile[13]; # ...with /myowncloud
   
   # 2 mal hash
   $conffile[14] = clean ( $conffile[14] );
   $data_structures::all_config{'store_local_hash_file_of_local_files'} = $conffile[14]; # ...with /var/tmp/.oldfilehash
   
   $conffile[15] = clean ( $conffile[15] );
   $data_structures::all_config{'store_local_hash_file_of_remote_files'} = $conffile[15]; # ...with /var/tmp/.all_file_from_remote
   
   $conffile[16] = clean ( $conffile[16] );
   $data_structures::all_config{'alert_me_files'} = $conffile[16];
   
   print data_structures::LOGFILE  "\n---------------------------reading config 2.....\n";
   #print data_structures::LOGFILE "@{[%data_structures::all_config]}"; 
   #print data_structures::LOGFILE "@{[%data_structures::remote_machine]}"; 
   
   use Data::Dumper;
   print data_structures::LOGFILE Dumper( %data_structures::all_config );  
   print data_structures::LOGFILE Dumper( %data_structures::remote_machine );  
         
   # hash is empty]}";
   while (my ($k, $v)=each %data_structures::remote_machine ){print data_structures::LOGFILE "$k\n"};
   while (my ($k, $v)=each %data_structures::all_config ){print data_structures::LOGFILE "$k\n"};
   
   print data_structures::LOGFILE  "\n---------------------------reading config 3.....\n";   
      
   $data_structures::all_config{'remote_machine'} = %data_structures::remote_machine;
   
   %data_structures::all_config;
}

sub clean # remove msft stuffs and crs
{
  my $mystr = $_[0];
  $mystr =~ s/\r//g;	
  chomp $mystr;	
  $mystr;
}

#-----------------test --
sub goo
{
   my $rsyncmd = $data_structures::remote_machine{'rsyncmd'};
   my $cmd = ""; 
   print $rsyncmd  .  "\n"; ####################
   $cmd = $rsyncmd;
   $cmd = $cmd . " herb";# . $rlockfile . " " . $ruser . "@" . $rserver . ":" . $rpath;
   print $cmd . "\n";
   print $rsyncmd  .  "\n"; ####################	
}

"1;"