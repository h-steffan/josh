use warnings;
use strict;
require 'data_structures.pl';  # ...

sub dump_hash_file
{
    
   my ($myfile) = $_[0];  #my (%myfilehash)  = $_[1]; ### functioiter nicht !!
   
   print data_structures::LOGFILE "Filehash is empty------------------------------------------------------\n";
   while (my ($k, $v)=each %data_structures::filehash ){print data_structures::LOGFILE "$k, $v\n"};
   print data_structures::LOGFILE "Oldfilehash - normal----------------------------------------------------\n";
   while (my ($k, $v)=each %data_structures::oldfilehash){print data_structures::LOGFILE  "$k, $v\n"};
   print data_structures::LOGFILE "Myfilehash-----------------------------------------------------\n";
    
   #print "@{[%myfilehash]}"; # hash is empty
    
   use YAML;
   #print "# %filehash\n", Dump \%filehash;  #
   my $cmd = "cp -f " . $myfile . " /tmp; rm -f " . $myfile;
   system ( $cmd );  	
   print data_structures::LOGFILE "Write dump_hash_file raw $myfile------------------------------------------------------\n";
   # '>'. ...
   open OUTFILE, ">$myfile" or die "Unable in dump_hash_file to open file $myfile\n"; 
   while (my ($k, $v)=each %data_structures::oldfilehash ){print OUTFILE "$k$data_structures::separator$v\n"}; 
   close OUTFILE;   
   print "Write dump_hash_file raw " . $myfile . " " . $data_structures::all_config{'store_local_hash_file_of_local_files'} . "\n";
   print "Writing keys " . ( keys %data_structures::oldfilehash ) . "\n";
}

sub dump_remote_hash_file
{
   my ($myfile) = $_[0];
   
   print data_structures::LOGFILE "Write remotehashfile raw $myfile ------------------------------------------------------\n";
   # '>'. ...
   open OUTFILE, ">$myfile" or print "Unable in dump_remote_hash_file to open file $myfile\n"; 
   while (my ($k, $v)=each %data_structures::remotehashfile ){print OUTFILE "$k$data_structures::separator$v\n"}; 
   close OUTFILE;   
}

sub dump_config_file
{
   my ($myfile) = $_[0];
   
   print data_structures::LOGFILE "Write config raw $myfile ------------------------------------------------------\n";
   # '>'. ...
   open (OUTFILE, '>', '$myfile') or print "Unable in dump_config_file to open file $myfile\n"; 
   while (my ($k, $v)=each %data_structures::all_config ){print OUTFILE "$k  $v\n"}; 
   close OUTFILE;   
}

"1;"
