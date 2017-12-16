use strict;
use warnings;
use autodie;
use features qw(say);   #Allows you to use `say` instead of `print:

my $log_file = "/usr/bin/log.txt";    #You have write permission to this directory?

open my $log_fh, ">", $log_file;

my test ( $log_fh ) or die qq(Can't write to the log);   #Pass the file handle to log
my test2 ( $log_fh ) or die qq(Can't write to the log);

close $log_fh;

sub test {
    return write_to_log ( $log_fh, "Hello World!" );
}
sub test2 {
    return write_to_log ( $log_fh, "Goodbye World!" );
}

sub write_to_log {
    my $file_handle  = shift;
    my $message      = shift;

    use Time::Piece;

    my $time = localtime->cdate;
    return say {$file_handle} "$time: $message";
}
