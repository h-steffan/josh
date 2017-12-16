Folder synchronisation by minimum means for all platforms with perl 

Looking for supporters and contributer esp. for debugging and optimising.

Partly based 
on BitPocket which is written in bash. The upload sync as well as the download sync basically works with multiple clients and a central host, however, there are minor bugs with non standard filenames. Syncing in terms of deleting files need a significant review.

Lastly the code needs a complete review and clean-up.

Prerequisites:
- perl
- use cpan to install some perl libs as described in the head of gojosh.shl
- install locally and remote rsync and scp if not available yet
- establish a central hub which is reachable by any scp or rsync command by all clients intended (I use a remote vm)
- make sure all your clients can reach the hub passwordless (google if this sounds difficult)
- create an user which could be used on all systems, all clients and the hub
- edit the .general conf file and add an IP address you can reach, delete my address, add your user
- run gojosh.sh to sync the own directory where all this stuff is in
- do some tests with file names like "Sat Dec 16 07:17:01 2017"
- report bugs
- help me ;-)


Features:
- syncing a folder tree by downloading and uploading files from multiple clients
- new file wins over the older file
- lock to one active client to make sure a single sync procedure is ongoing, all other clients waiting
- break your own lock in case you have been interrupted
- check if only one instance is running on a client
- adotping sligh time differences between hub and clients by storing the bias
- when deleting move file instead to a versioning tree with date marked outside the folder tree under sync
- exclude files which are considered to be client only using the .exclude* file
- getting alerted when files are uploaded by using the .alert* file
- running on all windows having perl or cygwin with perl
- low memory required, can run on pis which are problematic to run java on
- written in simple perl each and every c or c++ programmer will understand
- messy code ;-)

Remarks of Dec 2017, 16th:
- the main routine gojosh usually can do a sequence of runs without deleting just to sync all the system, later
after some runs deleting is enabled
- delete routines are generally decommented / disabled to do debugging
- gojosh.sh calls main.pl, then several sub routines are called covering the main features, names are explaining what the function is or what feaure is covered 
- not all of the code is actually used, file perf.sh just used as another test file, there might be some other.
- code has still many examples and links included to check and learn
- check the issue and bug section for issues I am working on

