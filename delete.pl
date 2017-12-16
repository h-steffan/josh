# description and purpose
#use Cwd qw(chdir);
#use File::Basename;
#
# Function definition 
use warnings;
use strict;

#my $mycmd="ssh";
my $myat="@";
my $myssh="ssh ";
my $myls="find . -name \* -print ";
my $remote_tmp_file = "/tmp/mylist";

require 'data_structures.pl';  # ...
require 'read_util.pl';  # ...

sub delete_local
{  
# if there is a local file and this old and definitely not new  and there is no 
# remote file, than it has been
# deleted by some other clients, then delete or store the local file es well

   my $rootdir = $_[0];
   my $workdir = $_[1];
   my $versiondir = $_[2];
   my $remote_tmp_file = "/tmp/mydate";
   
   my $rsyncmd = $data_structures::remote_machine{'rsyncmd'}; 
   my $ruser =   $data_structures::remote_machine{'ruser'}; 
   my $rserver = $data_structures::remote_machine{'rserver'};
   my $rpath = $data_structures::remote_machine{'remote_lock_path'}; 
   
   print "Checking for delete local with keys " . ( keys   %data_structures::remotefilehash ) . "\n";
   if  (( keys %data_structures::remotefilehash ) eq 0 ){ die; };
     
   my $cmd = $rsyncmd . " " .  $ruser.$myat.$rserver . ":" . $rpath . " -l  > " . $remote_tmp_file;
   #print $cmd . "\n";
   my $res0 = system( $cmd );
   
   my @remotefiles = read_multiple_lines ( $remote_tmp_file );
   #print @remotefiles;
   
   
   %data_structures::remotefilehash = ();
   require 'util.pl';
   foreach(@remotefiles)
   {
     my $remote_filename = $_;
     my @linearray = split(" ", $_ ); 
     my $first = substr $linearray[0], 0, 1;
     if ( $first eq 'd' ){                        # delete all where is d at the beginning
        # delete line
        print data_structures::LOGFILE "Found dir " . $linearray[0] . " " . $linearray[4] . "\n";
     }
     else{
       require 'time_util.pl'; 
       my $day_of_remote_file = $linearray[2];
       my $time_of_remote_file = $linearray[3];
       
       # clean up listing of rsync -l
       $linearray[0] = ""; 
       $linearray[1] = "";
       $linearray[2] = "";
       $linearray[3] = "";
       my $new_remote_filename = join(' ',@linearray);
       @linearray = split("/", $new_remote_filename );
       $linearray[0] = ""; # delete the first, which is myowncloud ...
       $new_remote_filename = join('/',@linearray);
       my $new_local_filename = $rootdir . "/" . $new_remote_filename;
       # remove double //
       $new_local_filename =~ s/\/\//\//g;

       require 'util.pl';
	   #if ( ! check_file ( basename ( $new_local_filename ))){ next;; }
			
	   # this is the new local name ....
       print data_structures::LOGFILE  $new_local_filename. "---------------------------\n";
       
       $data_structures::remotefilehash{ $new_local_filename } = ( $day_of_remote_file . " " . $time_of_remote_file );      ## make a hash of all remote files
       
     }   
   }

   print "Now keys are " . ( keys   %data_structures::remotefilehash ) . ".\n";
   if ( ( keys   %data_structures::remotefilehash ) == 0 )
   {
   	   return 0;
   }
   else {
     foreach my $key (keys %data_structures::oldfilehash)
     {
      # do whatever you want with $key and $value here ...
      my $new_local_filename = $data_structures::oldfilehash {$key};
      # checke the remote file ...
      #print "Cheking " . $new_local_filename . "\n";
      if ( ! exists( $data_structures::remotefilehash{ $new_local_filename } )) { 
       
        print "To be deleted " . $new_local_filename . "\n";
        my $new_version_filename  = $new_local_filename;
        #$data_structures::remote_machine{'remote_lock_path'}
        #$data_structures::all_config{'remote_storage'}
       
        $new_version_filename  =~ s/$rootdir//;
        #$new_version_filename  =~ s/ \/ \/ /f/;
       
        require 'time_util.pl';
        my $mydatefile = beautify_file_name ( get_date_file_name ( $new_version_filename ));
       
        $new_version_filename = $rootdir . "/" . $versiondir . "/" . $mydatefile;
        system ( "cp -arp --parent " . $new_local_filename .  " " .  $new_version_filename );
        system ( "rm -rf ".  $new_local_filename );
       }  
       if ( -f $new_local_filename ){
         print data_structures::LOGFILE "Still here $new_local_filename \n";
       }
       else
       {

       }
     }
   }
}

sub delete_remote
{  
# for each file in the hash: if there is no local 
# real file than is has been deleted, then delete the remote as well
# better / check if th file is in the renote file hash ...
#
#
   #my %seen = ();
   my $rootdir = $_[0];
   my $workdir = $_[1];
   print "Checking for delete remote with keys " . ( keys   %data_structures::oldfilehash ) . "...\n";
   
   foreach my $key (keys %data_structures::oldfilehash)
   {
     # do whatever you want with $key and $value here ...
     my $new_local_filename = $data_structures::oldfilehash {$key};
     if ( -f $new_local_filename ){
        print data_structures::LOGFILE "Still here $new_local_filename \n";
     }
     else
     {
        my $new_remote_filename  = $new_local_filename;
        $new_remote_filename  =~ s/$rootdir//;
        $new_remote_filename = $data_structures::remote_machine{'remote_lock_path'} . $new_remote_filename;
        print "To delete " . $new_local_filename . " " . $new_remote_filename . "\n";
        
        my $ruser =   $data_structures::remote_machine{'ruser'}; 
        my $rserver = $data_structures::remote_machine{'rserver'};        
        my $cmd = $data_structures::remote_machine{'rsyncmd'} . " " .  $ruser.$myat.$rserver . " 'rm  -rf "  .  $new_remote_filename  . " ' ";
        ## ssh und dann rm on remote oder hirgendwo hinpushen - wie war das mit version?
        $cmd = $myssh . $ruser.$myat.$rserver . " 'rm " . $new_remote_filename . " '";
        system ( $cmd );
        delete $data_structures::oldfilehash{$data_structures::oldfilereversehash{$new_local_filename}};
        delete $data_structures::oldfilereversehash{$new_local_filename};
     }
   }
}


1;