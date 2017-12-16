# description and purpose

# 2learn
#
# 2do
# Function definition
#
use warnings;
use strict;
#use Exporter qw(import);
#@EXPORT_OK = qw(%data_structures::all_config);
#@EXPORT_OK = qw(%data_structures::remote_machine);
#
package data_structures;
# https://www.tutorialspoint.com/perl/perl_modules.htm
# http://stackoverflow.com/questions/4543934/how-to-share-export-a-global-variable-between-two-different-perl-scripts

# Global Variables
$data_structures::LOGFILE =''; ## 
$data_structures::CENTRALLOGFILE =''; ## 
#$data_structures::logfile = "/var/tmp/josh.log";

@data_structures::excludedfiles = (); ## 
%data_structures::remotefilehash = ();
%data_structures::remotefilereversehash = ();

%data_structures::oldfilehash = (); ### !
%data_structures::oldfilereversehash = ();
#@data_structures::/home/ste/work/bin/.excluded_files.conf- = ();

our $mylockfile;

#my $separator = "-a-z__b-y-k-q__m-b__e-f-p";   ### this has been defined two times, change at both places - delete .old_hashfile
# ohne my
$data_structures::separator = "----";

#
$data_structures::actual_time_bias = 0; 
# OO Stuff
#http://www.perlmonks.org/?node_id=1067022
#
#define a struct or  an hash
%data_structures::remote_machine = ();                                   # new anonymous hash
$data_structures::remote_machine{'rsyncmd'}  = "rsyncmd--------";
$data_structures::remote_machine{'ruser'}  = "ruser--------";                # set field AGE to 24
$data_structures::remote_machine{'rserver'} = "rserver--------";             # set field NAME to "Nat"
$data_structures::remote_machine{'remote_lock_path'} = "remote_lock_path--------";
$data_structures::remote_machine{'remote_lock'} = "remote_lock--------";

#define a struct or  an hash
%data_structures::all_config = ();                                        # new anonymous hash
$data_structures::all_config{'lock'}  = "lock--------";
$data_structures::all_config{'date'}  = "date--------"; 
                              # set field AGE to 24
$data_structures::all_config{'nixnix'} = "nixnix--------";                            # this is a file with all hashed from last run, this is kept locally!
$data_structures::all_config{'keep_file_versions'} = "keep_file_versions--------";

$data_structures::all_config{'sync_only'} = "sync_only--------";
$data_structures::all_config{'use_simple_perl'} = "use_simple_perl--------";
$data_structures::all_config{'date_format_for_versioning'}  = "date_format_for_versioning--------";                 #us_date_format - no used

$data_structures::all_config{'local_log_file'}  = "local_log_file--------";                              #/var/tmp/josh.log
$data_structures::all_config{'remote_storage'}  = "remote_storage--------";                                #/myowncloud
$data_structures::all_config{'store_local_hash_file_of_local_files'}  = "store_local_hash_file_of_local_files--------";                #/var/tmp/.old_hash  -- hash s.o.
$data_structures::all_config{'store_local_hash_file_of_remote_files'}  = "store_local_hash_file_of_remote_files--------";                  #/var/tmp/.all_file_from_remote
$data_structures::all_config{'alert_me_files'}  = "alert_me_files--------"; 

$data_structures::all_config{'remote_machine'} = $data_structures::remote_machine;

#
############## examples and to learn
#	
# http://docstore.mik.ua/orelly/perl/cookbook/ch13_06.htm	
use Class::Struct;          # load struct-building module

struct Remote_Machine => {          # create a definition for a "Person"
    lock   => '$',                 #    name field is a scalar
    date   => '$',                 #    age field is also a scalar
    par1   => '$',                 #    age field is also a scalar
    keep_file_versions   => '$',        #    age field is also a scalar
    sync_only   => '$',                 #    age field is also a scalar
    use_simple_perl   => '$',           #    age field is also a scalar
    remote_machine   => '$',            #    age field is also a scalar
    #peers  => '@',                     #    but peers field is an array (reference)
    rest => '$'
};

sub set_all
{
	
  my $p = Person->new();      # allocate an empty Person struct

  $p->name("Jason Smythe");                   # set its name field
  $p->age(13);                                # set its age field
  $p->peers( ["Wilbur", "Ralph", "Fred" ] );  # set its peers field

  # or this way:
  @{$p->peers} = ("Wilbur", "Ralph", "Fred");
  
  # fetch various values, including the zeroth friend
  printf "At age %d, %s's first friend is %s.\n",
  $p->age, $p->name, $p->peers(0);

}

	
1;
__END__