# description and purpose
#use Cwd qw(chdir);
use File::Basename;
use Digest::MD5::File qw( file_md5_hex );
# coplex perl
# http://stackoverflow.com/questions/1003632/how-can-i-see-if-a-perl-hash-already-has-a-certain-key
#
# working on %data_structures::oldfilehash
#
#
require 'data_structures.pl';  # ...
require 'dump_util.pl';
#require Data;
use warnings;
use strict;
sub identify_new_files_n_upload
{
    my @list = @_;
    my ($actpath) = $list[0];
    my ($workdir) = $list[1];
    my ($backlogtime) = 2;
    $backlogtime = $list[2];
    my ($rootdir) = $list[3];
    
    my $backlogtimeweeks = 0;
    if ($backlogtime eq "sync_only_2_weeks") {
      $backlogtimeweeks =2;
    } else {
    if ($backlogtime eq "sync_only_4_weeks") { 
      $backlogtimeweeks =4;
    } else {
    if ($backlogtime eq "sync_only_8_weeks") { 
      $backlogtimeweeks =8;
    } else {
    if ($backlogtime eq "sync_only_100_weeks") { 
      $backlogtimeweeks =100;    
  	}
	else {
		print "Backlog not met the proposal.\n";
		#die "Backlog not met the proposal.\n";
	}}}}
	# preparing, the folder under investigation is the actpath and the working dir combined
    $actpath = $actpath . '/';
    my $go = $actpath . $workdir; 
    
    print "Checking ....\n";
    
    opendir(DIR, $go ) or die "Unable in identify_new_files to open path of workdir $workdir:$!\n";
    my @myfiles = readdir(DIR) or die "Unable in identify_new_files to read $go:$!\n";
    closedir(DIR);

    print data_structures::LOGFILE "Last time only " . ( keys %data_structures::oldfilehash ) . " - now lets see...\n";
    print "Last time only " . ( keys %data_structures::oldfilehash ) . " - now lets see...\n";
       
    foreach my $actfilename (@myfiles){
    	my $myfile = $go .'/'. $actfilename;
        if ( -f ( $myfile ) ){
			my $bfilename = basename ( $myfile );
			
			my $alert_file = read_single_line ( $data_structures::all_config{'alert_me_files'} );
			#print "Alert " . $bfilename  .  "\n";
			chomp $alert_file;
			if ( $bfilename eq $alert_file ){ print "Alert " . $alert_file  .  "\n";}
			
			require 'util.pl';
			if ( check_file ( $myfile )){ next; } # funktioniert 
			
			require 'time_util.pl';
            my $seconds = 0;
            my $hours = 0;
            my $secondss = get_time_diff (  $myfile, \$seconds ,\$hours );
			if ($secondss < 120 ){
			   print data_structures::LOGFILE "Actual: " . $bfilename . ": \n";
			   print "Brand new: " . $bfilename . ": \n";
			   } else {
		       if (($secondss / 3600) < ( $backlogtimeweeks * 24 * 7 )){
			      print data_structures::LOGFILE "Not actual but no really old File: " . $bfilename . ": \n";
               }
            }
            my $md5 = make_file_string_md5 (  $myfile  );
            
            if ( exists($data_structures::oldfilehash{$md5}) ){                                             #Update hash########################## !! 
            	print data_structures::LOGFILE "    -> Found  $myfile in old hash - do nothing ...\n";
            }             
            else {
                print data_structures::LOGFILE "    -> Found md5 not in hash - new $myfile ...\n";

                if ( exists($data_structures::oldfilereversehash{$myfile}) ){                                             #Update hash########################## !! 
            	   print data_structures::LOGFILE "    -> Found  $myfile in old hash - delete...\n";
                   delete $data_structures::oldfilehash{$data_structures::oldfilereversehash{$myfile}};
            	   delete $data_structures::oldfilereversehash{$myfile};
            	}   
                else {
                   # add to hash and check
                   my $last_files_in_hash = keys %data_structures::oldfilehash;
                
                   $data_structures::oldfilehash{$md5}      = $myfile; 									       #Update hash########################## !!
                   $data_structures::oldfilereversehash{$myfile}      = $md5; 
                   print "New " . $data_structures::oldfilehash{$md5} . " found and added to hash\n";                
                
                   #macht neuen hash wenn md5 neu, müsste aber löschen!
                   if ( keys %data_structures::oldfilehash != ( $last_files_in_hash + 1) ){
                      die "Hash can not be updated";
            	   }
            	}
            	
            	# make nice and overwrite all non common letters like blanc and !
            	require 'util.pl';
                my $new_local_filename = beautify_file_name ( $myfile );
                my $new_remote_filename  = $new_local_filename;
                $new_remote_filename  =~ s/$rootdir//;

                print "Uploading " . basename ($new_remote_filename) . "\n";
                my $base = basename ( $new_remote_filename );
				$new_remote_filename =~ s/$base//; #///////////////////////////////////////////
				
                # copy it / rsync to server regardless of date, rely on rsync
                my $cmd = $data_structures::remote_machine{'rsyncmd'} . "  " . $new_local_filename . "        ";
                $cmd = $cmd . $data_structures::remote_machine{'ruser'} . "@" . $data_structures::remote_machine{'rserver'} . ":";
                $cmd = $cmd . $data_structures::remote_machine{'remote_lock_path'} . $new_remote_filename;  # wirhkich in /tmp/myowncloud???
                print data_structures::LOGFILE $cmd . "\n"; 
                #print $cmd . "\n"; 
                
                #print  $cmd . "\n"; 
                
                #print data_structures::CENTRALLOGFILE "machine uploading " . $new_local_filename . "\n";
                system ( $cmd ); 
            }
           
		}
    }
    foreach my $actfilename (@myfiles){
        if ((-d $actfilename) && (!($actfilename eq ".") && !($actfilename eq "..")))            # is this a directory?
        {                  
            #$counter += 1; 
            identify_new_files_n_upload ( $go,  $actfilename, $backlogtime, $rootdir );
        }
    }

    print "Now we have " . ( keys %data_structures::oldfilehash ) . " Files!\n";
}

##################### examples ####################################################################################

sub find_hash_by_value()
{
   %data_structures::reverse_filehash = reverse %data_structures::filehash;
   if( defined( $data_structures::reverse{2} ) ) {
      print "2 is a value in the hash!\n";
   }
}

##################### examples ####################################################################################

sub find_hash_by_key()
{
  # create our perl hash
  my %people = ();
  $people{"Fred"} = "Flinstone";
  $people{"Barney"} = "Rubble";
 
  # specify the desired key
  my $key = "Fred";

  if (exists($people{$key}))
  {
    # if the key is found in the hash come here
    print "Found Fred\n";
  }
  else
  {
    # come here if the key is not found in the hash
    print "Could not find Fred\n";
  }
}


"1;"