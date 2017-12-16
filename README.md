Folder synchronisation by minimum means for all platforms with perl 

Looking for supporters and contributer esp. for debugging and optimising.

Partly based 
on BitPocket which is written in bash. The upload sync as well as the download sync basically works with multiple clients and a central host, however, there are minor bugs with non standard filenames. Syncing in terms of deleting files need a significant review.

Lastly the code needs a complete review and clean-up.

Prerequisites:
- perl
- use cpan to install some perl libs as described in the head of gojosh.shl
- install locally and remote rsync and scp if not available yet
- establish a central hub which is reachable by any scp or rsync command
- make sure all your clients can reach the hub passwordless by scp or rsync (google if this sounds difficult)
- run gojosh.sh to sync the own directory where all this stuff is in
- do some tests with file name like "Sat Dec 16 07:17:01 2017"
- report bugs
- help me ;-)


Features:
- syncing a folder tree by downloading and uploading files from multiple clients
- lock to one active client to make sure a single sync procedure is ongoing, all other clients waiting
- break your own lock in case you have been interrupted
- check if only one instance is running on a client
- adotping sligh time differences between hub and clients by storing the bias
- when deleting move file instead to a versioning tree with date marked outside the folder tree under sync



