#!/usr/bin/perl -w

#http://www.cs.mcgill.ca/~abatko/computers/programming/perl/howto/hash/
#http://stackoverflow.com/questions/25142882/hash0x1970c80-in-perl-script
#http://stackoverflow.com/questions/1482716/why-does-my-perl-print-show-hash0x100a2d018
#http://www.nntp.perl.org/group/perl.beginners/2007/06/msg92139.html

#use warnings;
#use strict;                 # use all three strictures
$|++;                       # set command buffering
    
use Data::Dumper;
   
package data_structures; 

# test
%data_structures::myhash = ( 1 => 11, 2 => 12 );
 
$data_structures::logfile = "/var/tmp/josh.log";
 
require 'data_structures.pl';  # ...
#use vars qw(%data_structures);
#use vars qw(%remote_machine);
#use vars qw($LOGFILE); 


require 'read_config.pl'; ## -----------------------------------------------------------------------
require 'read_util.pl';



#----------------------------------------------------

my $rundir=`pwd`;
my $conffile=".general.conf";
print $rundir;
chomp $rundir;

open (data_structures::LOGFILE, '>', $data_structures::logfile);

read_config ( $rundir, ( "../bin/" . $conffile), " "  );


   print "\n---------------------------reading config 1a.....\n";
   for my $key (keys %data_structures::myhash) {
      print $key;
   } 
   print "\n---------------------------reading config 1b.....\n";
   $data_structures::myhash{3} .= 13;
   $data_structures::myhash{4} = 14;
   print "\n---------------------------reading config 1c.....\n";
   for my $key (keys %data_structures::myhash) {
      print $key;
   }   

   print "\n---------------------------reading config 1d.....\n";
   print Dumper( %data_structures::myhash );   
   
   print "\n---------------------------reading config 1e.....\n";
   print "@{[%data_structures::myhash]}"; 
   
   print "\n---------------------------reading config 2a.....\n";
   
   
   # hash is empty]}";
   
   print $data_structures::all_config{'store_local_hash_file_of_remote_files'} . "\n";
   print data_structures::LOGFILE $data_structures::all_config{'store_local_hash_file_of_remote_files'} . "\n";
   print "\n---------------------------reading config 2b.....\n";
   
   print "@{[%data_structures::all_config]}"; 
   print "@{[%data_structures::remote_machine]}"; 
   
   print "\n---------------------------reading config 2c.....\n";
      
   while (my ($k, $v)=each %data_structures::remote_machine ){print "($k, $v)\n"};
   while (my ($k, $v)=each %data_structures::all_config ){print "($k, $v)\n"};
   
   print "\n---------------------------reading config 2d.....\n";
   
   print data_structures::LOGFILE  "\n---------------------------reading config 3.....\n";   
   
   $data_structures::all_config{'remote_machine'} = %data_structures::remote_machine;
   
   print "Now the log file .....\n"; 