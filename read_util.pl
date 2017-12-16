
#require 'data_structures.pl';  # ...
#my $separator = "-a-z__b-y-k-q__m-b__e-f-p";   ### this has been defined two times, change at both places - delete .old_hashfile
use warnings;
use strict;

#my $separator = "----";

sub read_single_line 
{
   my $todays_data = $_[0];
   open INFILE, $todays_data or die "Unable in read_single_line to open file $todays_data:$!\n"; 
   my $conffile = <INFILE> ;
   close INFILE;
   $conffile;	
}

sub read_multiple_lines 
{
   my $todays_data = $_[0];
   open INFILE, $todays_data or die "Unable in read_mutliple_lines to open file $todays_data:$!\n"; 
   my @conffile = <INFILE> ;
   close INFILE;	
   @conffile;	
}

sub read_hash_file
{
   my ($myfile) = $_[0];
   my %record;            ########### local hash
   print "Reading $myfile ...";
   print data_structures::LOGFILE "Read_hash_file--1-----$myfile-----------\n";
   if ( -f $myfile ) {
   	   my @allfiles = read_multiple_lines ( $myfile );
       print data_structures::LOGFILE "Read_hash_file--2--------------------------\n";
       my %record;    # new temp hash $LOGFILE 
       foreach(@allfiles){
          my $line = $_;
          chomp $line;
          print data_structures::LOGFILE $line;
          my ($key, $val) = split /$data_structures::separator/, $line, 2;
          #print data_structures::LOGFILE $key . " ---->>$data_structures::separator <<-----> " . $val . "\n";
          $record{$key} = $val if defined $val;
          $data_structures::oldfilehash{$key} = $val if defined $val;
       }
   }
   else {
      print data_structures::LOGFILE "First run, hash file not existent, hash structure empty then, assuming all files new.\n";
   }
   print data_structures::LOGFILE "Read_hash_file-----------3: " . ( keys %data_structures::oldfilehash ) . " ---------------\n";
   use Data::Dumper;
   print data_structures::LOGFILE Dumper (\%data_structures::oldfilehash);
   print data_structures::LOGFILE "Read_hash_file-----------4: " . ( keys %data_structures::oldfilehash ) . " ---------------\n";
   print " with " . ( keys %data_structures::oldfilehash ) . " items \n";
   %record; ########### local hash
}

"1;"