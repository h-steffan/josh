# description and purpose

# 2learn
#
# 2do
# Function definition
use warnings;
use strict;
sub mycopy_mkdir
{
   my @list = @_;
   my ($source) = $list[0];
   my ($destination) = $list[1];
   
   $source = beautify_file_name ( $source );
   $destination = beautify_file_name ( $destination );
   
   #print $source . "   "  . $destination . "\n";
   use File::Basename;
   my $destination_dirname = dirname $destination;
   
   my $cmd1 = "mkdir -p $destination_dirname";
   my $cmd2 = "cp $source $destination";

   my $r = system($cmd1);
   if ($r) {
    if ($? == -1) {
        die "failed to execute '$cmd1': $!\n";
    }
    elsif ($? & 127) {
        my $msg
          = sprintf "'$cmd1' failed with signal %d, %s coredump\n",
          ($? & 127), ($? & 128) ? 'with' : 'without';
        die $msg;
    }
    else {
        die "'$cmd1' exited with value %d\n", $? >> 8;
    }
   }
   
   $r = system($cmd2);
   if ($r) {
    if ($? == -1) {
        die "failed to execute '$cmd1': $!\n";
    }
    elsif ($? & 127) {
        my $msg
          = sprintf "'$cmd1' failed with signal %d, %s coredump\n",
          ($? & 127), ($? & 128) ? 'with' : 'without';
        die $msg;
    }
    else {
        die "'$cmd2' exited with value %d\n", $? >> 8;
    }
   }
}


sub mycopy_mkdir_mytest
{
   my $cmd = "echo '' > aaa";
   system ( $cmd );
   mycopy_mkdir ( "aaa", "bbb" );
   system ( "ls bbb" );
}
#mytest

"1;"