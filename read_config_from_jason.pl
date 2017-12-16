# description and purpose

# 2learn
#
# 2do
# Function definition
sub read_config_from_jason
{
   my @list = @_;
   #print "Given list in read_config_from_jason @list\n";
   
   open INFILE, $list[0] or die "Unable to open file $list[0]:$!\n"; 
   my @conffile = <INFILE> ;
   close INFILE ;
   #print "JSON is @conffile";
}


package Folder_mapping; # like class
sub new 
{
   my $folder_mapping = shift;
	
   my $self = {
      Source  => shift,
      Destination  => shift,
   };
	
   bless $self, $folder_mapping;
   return $self;
}
sub TO_JSON { return { %{ shift() } }; }

package Machine_mapping; # like class
sub new 
{
   my $machine_mapping = shift;
	
   my $self = {
      machine_name  => shift,
      @Folder_mapping  => shift,
   };
	
   bless $self, $machine_mapping;
   return $self;
}
sub TO_JSON { return { %{ shift() } }; }

package main;
use JSON;

my $JSON = JSON->new->utf8;


"1;"