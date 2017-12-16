# description and purpose
#use Cwd qw(chdir);
#
# Function definition
require 'get_date_file_name.pl';
require 'mycopy_mkdir.pl';

sub make_version_and_backup
{
   my @list = @_;
   #print "Given list in make_version_and_backup @list\n";

    my ($actpath) = $list[0];
    my ($workdir) = $list[1];
    my ($versiondir) = $list[2];
    my ($rootdir) = $list[3];
    $actpath = $actpath . '/';
    my $gopath = $actpath . $workdir; 
    
    opendir(DIR, $go ) or die "Unable in make_version_and_backup to open dir $workdir:$!\n";
    my @myfiles = readdir(DIR) or die "Unable in make_version_and_backup to read $go:$!\n";
    closedir(DIR);
    
    foreach my $actfilename (@myfiles){
    	my $myfile = $gopath .'/'. $actfilename;
        if ( -f  $myfile ){
            #$counter += 1; 
            my $new_filename = get_date_file_name ( $myfile );
            
            $new_filename  =~ s/$rootdir//;
            #$new_filename  =~ s/ \/ \/ /f/;
            $new_filename = $rootdir . "/" . $versiondir . "/" . $new_filename;
			
			if ( -f $myfile ) {
			   mycopy_mkdir ($myfile , $new_filename );
			}
			else {
			  die "File not found in make_version_and_backup.\n";
			}   
        }
    }
    foreach my $actfilename (@myfiles){
        if ((-d $actfilename) && (!($actfilename eq ".") && !($actfilename eq "..")))
        {                  # is this a directory?
            #$counter += 1; 
            make_version_and_backup ( $gopath,  $actfilename, $versiondir, $rootdir );
        }
    }
}
"1;"