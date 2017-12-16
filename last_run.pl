# description and purpose

# 2learn
#
# 2do
# Function definition
use warnings;
use strict;
sub get_last_run
{
   my $datefile = shift; # holds the potential datefile 
   #print "Given list in get_last_run $datefile\n";

   if ( -f $datefile ){ 
      #open (INFILE, '<', $datefile ) or die "Unable to open file $datefile:$!\n"; 
      open (INFILE, "$datefile" ) or die "Unable in get_last_run to open file $datefile:$!\n"; 
      my @conffile = <INFILE> ;
      close INFILE ;
      print "Already date " . $datefile .  " " . @conffile . "\n";
   }
   else { # no lock set, so we do it
      print "No previous run found....\n";
   }
}

sub set_last_run
{
   #http://www.perlmonks.org/?node_id=1043789
   my $datefile = shift; # holds the potential datefile 
   use DateTime; #::localtime;
   #use Time::localtime;
   #my $startTime = time();
   my $today_n_now = DateTime->now;
      open OUTFILE, ">$datefile" or die "Unable in set_last_run to open filee $datefile:$!\n"; 
      print OUTFILE $today_n_now;
      close OUTFILE ;
      print "Set date $datefile with $today_n_now.\n";
   #else {
   #   # no lock set, so we do it
   #   print "No previous run found.";
   #}
}

"1;"