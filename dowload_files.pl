# description and purpose
#use Cwd qw(chdir);
use File::Basename;
# coplex perl
# http://stackoverflow.com/questions/1003632/how-can-i-see-if-a-perl-hash-already-has-a-certain-key
#
require 'data_structures.pl';  # ...
#
my $local_hash_file = "/var/tmp/.all_files_from_remote";
#
use warnings;
use strict;
sub dowload_all_files 
{
   my ($rootdir) = $_[0];
   my ($workdir) = $_[1];
   my ($remotedir) = $_[2];
   my ($versiondir) = $_[3];

   require 'time_util.pl';
   $data_structures::actual_time_bias = get_remote_time_diff_newer();
   
   #%data_structures::oldfilereversehash = reverse %data_structures::oldfilehash;
   $local_hash_file = $data_structures::all_config{'store_local_hash_file_of_remote_files'}; 

   print "Checking for download with keys " . ( keys %data_structures::oldfilehash) .  " and " . ( keys %data_structures::oldfilereversehash) . "....\n";
 
   # get the list of files from the remote place
   #$rootdir = $rootdir . '/' . $workdir;
   my $cmd = $data_structures::remote_machine{'rsyncmd'} . "   ";
   $cmd = $cmd . $data_structures::remote_machine{'ruser'} . "@" . $data_structures::remote_machine{'rserver'} . ":" . $data_structures::remote_machine{'remote_lock_path'};
   #rsync -r -e 'ssh' -l  ste@62.112.157.54:/tmp/myowncloud | grep "^-\|^d" | sed "s:^\S*\s*\S*\s*\S*\s*\S*\s*:/:" | sed "s:^/\.::"
   $cmd = $cmd . " -l  > $local_hash_file ";
   #print $cmd . "\n"; 
   print data_structures::LOGFILE $cmd . "\n"; 
   system ( $cmd );
   
   # and analyse it ...
   my @allfiles = read_multiple_lines ( $local_hash_file );
   # print @allfiles . "\n";
   foreach(@allfiles){
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
	   if ( check_file ( $new_local_filename )){ next;; }
			
	   # this is the new local name ....
       print data_structures::LOGFILE  $new_local_filename. "\n";
       $data_structures::remotefilehash{ $new_local_filename } = ( $day_of_remote_file . " " . $time_of_remote_file );      ## make a hash of all remote files
       #$data_structures::remotefilereversehash
       
       #print "keys are " . ( keys   %data_structures::remotefilehash ) . "\n";
       
       # does it exist locally by hash?
       if ( exists( $data_structures::oldfilereversehash{$new_local_filename} ) ){
          print data_structures::LOGFILE "Already here $new_remote_filename from remote, time ";
          
          # does it exist locally?
          if ( -f $new_local_filename ){
         	 
             my $newer = remote_file_is_newer ( $day_of_remote_file, $time_of_remote_file, $new_local_filename );
             $newer =  $newer; # - $data_structures::actual_time_bias;
             if ( $newer > 0 ){
                #print_time( $newer ); 
                save_local_file ( $new_local_filename, $rootdir, $versiondir );
                print data_structures::LOGFILE "\n";
                if ( $newer < 10000000 ){
                   print "Already here $new_remote_filename";
                   print ", remote is newer ";
                   print "by $newer sec.\n";
                }
                else{
                   print "Already here $new_remote_filename";
                   print "\n";                
                }
                print data_structures::LOGFILE "Saving local file in versions, downloading newer $new_local_filename remote file to local dir, remote newer by ";
                place_final_file ( $new_remote_filename, $new_local_filename );
                add_to_hash ( $new_local_filename ); # just md5 is new ... need to delete
             }
             else{
                print data_structures::LOGFILE "Not downloading $new_local_filename";
                #print_time( $newer ); 
                print data_structures::LOGFILE "\n";
                 if ( $newer > -10000000 ){
                   print data_structures::LOGFILE "Already here $new_remote_filename";
                   print data_structures::LOGFILE ", remote is older ";
                   print data_structures::LOGFILE "by " . (-1 * $newer)  . "sec.\n";
                }
                else{
                   print data_structures::LOGFILE "Already here $new_remote_filename";
                   print data_structures::LOGFILE "\n";                
                }
             }   
          }
          else {
          	  print "ERROR -- File $new_local_filename has an hash but no instance\n";
          }
       }
       else{   ## there is a new remote file which does not exist here 
         #print "Locally missing  " . $new_remote_filename . " " . $new_local_filename . "\n";
         place_final_file ( $new_remote_filename, $new_local_filename );
         
         if ( -f  $new_local_filename ){
            my $md5 = make_file_string_md5 ( $new_local_filename );
            if ( exists($data_structures::oldfilereversehash{$new_local_filename }) ){
               print "ERROR --     -> Error - found in hash old $new_local_filename ..\n";
            }
            else {
               print data_structures::LOGFILE "SUCCESS - File $new_local_filename arrived!\n";
               print data_structures::LOGFILE "Adding $new_local_filename to hash  ..\n";
               # add to hash
               $data_structures::oldfilehash{$md5} = $new_local_filename; ## bleibt gleich
               $data_structures::oldfilereversehash{$new_local_filename} = $md5; ## groesser
               print "New " . $data_structures::oldfilehash{$md5} . " added to hash\n";
         
            }
         }
         else{
               print "FAILED downloading of $new_local_filename!\n";
         }
       }
     }	 
   }

}

sub add_to_hash # from cp -arp from /tmp
{
   my ($new_local_filename) = $_[0];
   my $md5 = make_file_string_md5 (  $new_local_filename );

   delete $data_structures::oldfilehash{ $data_structures::oldfilereversehash{ $new_local_filename }};
   delete $data_structures::oldfilereversehash{ $new_local_filename }; 
   
   $data_structures::oldfilehash{$md5} = $new_local_filename ;
   $data_structures::oldfilereversehash{ $new_local_filename } = $md5;
}	

sub place_final_file # from cp -arp from /tmp
{
   my ($new_remote_filename) = beautify_file_name( $_[0] );
   my ($new_local_filename) = beautify_file_name( $_[1] );
   
   # just check, maybe it appered recently ....
   if ( -f $new_local_filename ){
      print data_structures::LOGFILE "Downloading remote file first - but local file still there!\n";	
   }
   else {
      print data_structures::LOGFILE "Downloading remote file first to /tmp then to local $new_local_filename ....\n";	 
   }	 
   my $cmd = $data_structures::remote_machine{'rsyncmd'} . "  \""; # put command in "" to make blanc and Sonderzeichen work with rsync
   $cmd = $cmd . $data_structures::remote_machine{'ruser'} . "@" . $data_structures::remote_machine{'rserver'} . ":" . $data_structures::remote_machine{'remote_lock_path'};
   $cmd = $cmd . "/" . $new_remote_filename . "\"   /tmp";
   
   $cmd = beautify_path ( $cmd );
   print data_structures::LOGFILE $cmd . "\n"; 
   print "Placing new downloaded " . $new_remote_filename . " from remote to " . $new_local_filename . "\n";
   system ( $cmd );
   
   my $tmp_file = "/tmp/" . basename ( $new_local_filename ); # löscht basenname die slashes?
   if ( -f remove_slashes_from_file_name ( $tmp_file ) ){
      print data_structures::LOGFILE $tmp_file . " -> " . $cmd . "\n"; 
      $cmd = "cp -ap $tmp_file $new_local_filename; rm -rf $tmp_file"; # ohne r !!!!!///////////////////////////////
      system ( $cmd );
   }
   else{ 
      print  "ERROR when moving " . $tmp_file . " to final destination  $new_local_filename, file disappeared!\n";
   }
}
         
require 'mycopy_mkdir.pl'; 
require 'get_date_file_name.pl'; 

sub save_local_file
{
   my $myfile = $_[0];
   my $rootdir = $_[1];
   my $versiondir = $_[2];
   my $new_filename = get_date_file_name ( $myfile );
   
   $new_filename  =~ s/$rootdir//;
   $new_filename = $rootdir . "/" . $versiondir . "/" . $new_filename;
   mycopy_mkdir ($myfile , $new_filename );
}

############################### new

sub delete_remote_file
{
	   # besser: da wo nich mehr da aber noch im .oldfile_hash, da wurden sie offensichtloch lokal gelöscht und da sollzen sie auch remote gelöscht werden

}

sub delete_local_file
{
   my $myfile = $_[0];
   my $rootdir = $_[1];
   my $versiondir = $_[2];
   my $new_filename = get_date_file_name ( $myfile );
   
   $new_filename  =~ s/$rootdir//;
   #$new_filename  =~ s/ \/ \/ /f/;
   $new_filename = $rootdir . "/" . $versiondir . "/" . $new_filename;
   mycopy_mkdir ($myfile , $new_filename );
   
   #$remotefilehash{$new_local_filename } = done welche bearbeitet
   # da wo nicht done, gibt es sie local nicht (mehr)
   # besser: da wo remote verschwunden sollten sie auch local gelöscht werden, dazu m+sst man sich aber auch eine Kopie der remote hashes local aufbewahren
   #s
   
   
   
}

