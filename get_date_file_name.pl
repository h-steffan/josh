use warnings;
use strict;
sub get_date_file_namegkgkjkh
{
   # http://stackoverflow.com/questions/11020812/todays-date-in-perl-in-mm-dd-yyyy-format

   my $myfile = shift; 
   use Date::Calc qw();
   my ($y, $m, $d) = Date::Calc::Today();
   my $ddmmyyyy = sprintf '%02d.%02d.%d', $d, $m, $y;
   #print $ddmmyyyy . "\n";


   
   #use DateTime qw();
   #print DateTime->now->strftime('%m/%d/%Y')
   $ddmmyyyy = $ddmmyyyy . $myfile;
   $ddmmyyyy;
}

"1;"