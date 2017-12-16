# description and purpose
#use Cwd qw(chdir);
#use File::Basename;
#
# Function definition
use warnings;
use strict;

# summary of two functions, could be forbidden by path or by name
sub check_file
{
    my ($myfile) = $_[0];
    #print data_structures::LOGFILE "Checking .....  " .  $forbidden . " " . $pathelements . " --------------------------\n"; 
    my $bfilename = basename ( $myfile );
    return ( check_file_by_name ( $bfilename ) || check_file_by_path ( $myfile ));
}

# check if file is forbidden
sub check_file_by_name
{
   my ($myfile) = $_[0];
   #chomp ( @data_structures::excludedfiles ); 
   # https://perlmaven.com/for-loop-in-perl
   # http://www.perlmonks.org/bare/?node_id=504626
   foreach my $forbidden ( @data_structures::excludedfiles ){
     if( $myfile eq $forbidden ){
        print "Forbidden to handle " .  $forbidden . "\n"; 
        return 1;
        last;
      }
      else{
        0;
       }
    }
}

sub check_file_by_path
{
   my ($myfile) = $_[0];
   my @linearray = split("/", $myfile );
   foreach my $forbidden ( @data_structures::excludedfiles ){
     foreach my $pathelements ( @linearray ) {
       if( $pathelements eq $forbidden ){
        print "Forbidden to handle, path contains " .  $forbidden . "\n"; 
        return 1;
        last;
        last;
       }
       else{
        0;
       }
     }
   }
}

sub check_file_by_extension
{
   my ($myfile) = $_[0];
   #my $ext = $file =~ /\.zip$/i
   foreach my $forbidden ( @data_structures::excludedfiles ){
     if ($myfile =~ /$forbidden/i) {
        print "Forbidden to handle " .  $forbidden . "\n"; 
        return 1;
        last;
      }
      else{
        0;
       }
    }
}

sub write_line_qweqweq 
{
   my $todays_data = $_[0];
   my @myfile = $_[1]; 
   #open INFILE, ">$todays_data" or die "Unable in wite_line to open file $todays_data:$!\n"; 
   open (OUTFILE, '>', '$todays_data') or die "Unable in write_line to open file $todays_data!\n"; 
   print OUTFILE @myfile;
   close OUTFILE;
}

sub make_reverse
{  
   %data_structures::oldfilereversehash = ();
   #$data_structures::remotefilehash{$new_local_filename } = "done";
   #$data_structures::oldfilehash{$md5} .= $new_local_filename ; 
   while ( my ($key, $value) = each %data_structures::oldfilehash )
   {
       $data_structures::oldfilereversehash{$data_structures::oldfilehash{$key}} = $key;
   }
   #print "Keys are " . ( keys %data_structures::oldfilereversehash ) . " " . ( keys %data_structures::oldfilehash ) . "\n"; 
}

sub make_string_histo
{  
   my %seen = ();
   my $string = $_[0];
   foreach my $byte (split //, $string) {
       $seen{$byte}++;
   }
   print "unique chars are: ", sort(keys %seen), "\n";
}

use Digest::MD5::File qw( file_md5_hex );
sub make_file_string_md5
{  
   my $md5 = file_md5_hex( $_[0] )  . "--" . add_string_chars (  $_[0] );
   return $md5;
}  
  
sub add_string_chars
{  
   my $seen =0;
   my $string = $_[0];
   foreach my $byte (split //, $string) {
       $seen += (ord($byte) + 0);
   }
   #print "chars are: ",$seen, "\n";
   return $seen;
}

sub remove_slashes_from_file_name 
{
  my ($source) = $_[0];
   $source =~ s/\\//g;
   $source;
}  

sub beautify_file_name 
{
  my ($source) = $_[0];
   $source =~ s/\s/\\ /g;
   $source =~ s/\!/\\!/g;
   $source =~ s/\(/\\(/g;
   $source =~ s/\)/\\)/g;
   $source =~ s/\[/\\[/g;
   $source =~ s/\]/\\]/g;
   $source =~ s/\-/\\-/g;
   $source =~ s/\,/\\,/g;
   $source =~ s/\:/\\:/g;
   $source =~ s/\@/\\@/g;
   #$source =~ s/\$/\\$/g;
   $source =~ s/\§/\\§/g;
   $source;
}  
 
sub beautify_path
{
  my ($source) = $_[0];
   $source;
   #//$source =~ s/\/\///g;
   #//$source;
}    
sub maximum
{
	if ($_[0] > $_[1])
	{
		$_[0];
	}
	else
	{
		$_[1];
	}
}

1;