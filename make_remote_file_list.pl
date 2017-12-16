

require 'data_structures.pl';  # ... 
sub make_remote_file_list
{
     my @linearray = split(" ", $_[0] ); 
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
       return $new_local_filename;
     }
}     