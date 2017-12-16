#!/usr/bin/perl -w
# description and purpose

# 2do
# Function definition

sub main
{
	my $curdir = `pwd`;
	use File::Basename;
	my $destination_dirname = dirname $curdir;
	my $destination_filename = basename $curdir;
	chomp $destination_dirname;
	chomp $destination_filename; 
	print $destination_dirname .  " " . $destination_filename . "\n";
	make_call_flows ( $destination_dirname, $destination_filename, "--" ); 
}

sub make_call_flows
{
	my @list = @_;
    my ($path) = $_[0];
    my ($workdir) = $_[1];
    my ($adddstring) = "-";
    $adddstring = $_[2];
    
    # prepare ...
    $path = $path . '/';
    my $go = $path . $workdir; 
    print $go . "\n"; 
    
    # open dir under investigation 
    opendir(DIR, $go ) or die "Unable in make_call_flows to open dir $workdir:$!\n";
    my @myfiles = readdir(DIR) or die "Unable in make_call_flows to read $go:$!\n";
    closedir(DIR);
    
    foreach my $actfilename (@myfiles){
        my $safestring = $adddstring; 
        $adddstring = $adddstring . "--";
        if ((-d $actfilename) && (!($actfilename eq ".") && !($actfilename eq "..")))
        {                  # is this a directory?
            make_call_flows ( $go ,  $actfilename, $adddstring );
        }
       $adddstring = $safestring;
    }
    # delete non pl from the array with splice
    for my $index (reverse 0..$#myfiles) {
      if ( $myfiles[$index] !~ /\.pl/ ) {
        splice(@myfiles, $index, 1, ());
      }
    }
   
    foreach my $actfilename (@myfiles){
    	my $myfile = $go .'/'. $actfilename;
        if ( -f ( $myfile ) ){
            my $basefile = basename $myfile; # 
            print "File: ". $adddstring  . $basefile . "\n";      # is this a file?
        }
    }

}

main;

"1;"
