# description and purpose

# 2learn
# http://stackoverflow.com/questions/9600395/how-to-traverse-all-the-files-in-a-directory-if-it-has-subdirectories-i-want-t
# http://www.perlmonks.org/?node_id=600456
#
# http://www.perlmonks.org/?node_id=912799
#
#use File;
#use Cwd qw(chdir);
#use Digest::MD5::File qw( file_md5_hex );
#
# 2do
# Function definition
sub traverse_over_file_system
{
	my @list = @_;
    my ($path) = $list[0];
    my ($workdir) = $list[1];
    my ($count) = $list[3];
    
    # prepare ...
    $path = $path . '/';
    my $go = $path . $workdir; 
    
    # open dir under investigation 
    opendir(DIR, $go ) or die "Unable in traverse_over_file_system to open path$workdir:$!\n";
    my @myfiles = readdir(DIR) or die "Unable in traverse_over_file_system to read $go:$!\n";
    closedir(DIR);
    
    #print "File names in Folder " . $workdir . ": ";
    #print @myfiles;
    foreach my $actfilename (@myfiles){
    	my $myfile = $go .'/'. $actfilename;
        if ( -f ( $myfile ) ){
            $counter += 1; 
            $count += 1; 
            #print "File: $myfile \n";      # is this a file?
            #my $md5 = file_md5_hex( $myfile );
        }
    }
    foreach my $actfilename (@myfiles){
        if ((-d $actfilename) && (!($actfilename eq ".") && !($actfilename eq "..")))
        {                  # is this a directory?
            #print "Dir: $actfilename \n";
            $counter += 1; 
            $count += 1; 
            traverse_over_file_system ( $go ,  $actfilename, \$count );
        }
    }
    #chdir ('..');
}


"1;"
