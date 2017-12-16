#!/bin/bash
#
#start with general seeting, we do this in bash
# apt-get install rsync gcc make
# yast install rsync rsync gcc make
#
#ste@debian8l:~$ cd /mkdir /tmp/myowncloud
#-bash: cd: /mkdir: Datei oder Verzeichnis nicht gefunden
#ste@debian8l:~$ mkdir /tmp/myowncloud
#ste@debian8l:~$ echo "NO_RUN" > /tmp/myowncloud/myowncloud.lock
#ste@debian8l:~$ mkdir /tmp/myowncloud/bin


#cpan -f Params::ValidationCompiler
#cpan DateTime::Locale Params::ValidationCompiler DateTime::TimeZone DateTime Date::Calc Time:Piece Digest:MD5:File YAML
#
RUNTIMEBREAK=177
#
MACHINE=`hostname`

RUNDIR=`pwd`
cd ..
ROOTDIR=`pwd`
cd $RUNDIR

WORKDIR="bin"

CONFFILE=".general.conf"

JASONFILE=".mapping_JSON"

excludefile=".excluded_files.conf"

VERSIONDIR="0Versions"

# now run stuff in perl
for i in `seq 1 3`;
do
    ./main.pl $RUNDIR $ROOTDIR $WORKDIR "$CONFFILE" "$JASONFILE" "$excludefile" "$VERSIONDIR" $MACHINE 0
    sleep $RUNTIMEBREAK
done

for i in `seq 1 100`;
do
    ./main.pl $RUNDIR $ROOTDIR $WORKDIR "$CONFFILE" "$JASONFILE" "$excludefile" "$VERSIONDIR" $MACHINE 1
    sleep $RUNTIMEBREAK
done
./gojosh.sh &

# done:
# run in a loop
# check if locally and/or remote only one istance is running
# upload when new since last run
# check all remote files and download when locally not available
#  ..  and save local file in version when it is available assuming the remote file is newer and the local older (master wins)
# all file names are taken including blancs and ! - but difficulties witj () still

# 2 do
# local hash only grows, not cleant
# filder & files mit ! werde nicht berücksichigt ,,,
# exlude files not to transfer
# when dowload and if available locally  check which file is newer
# when upload check if file is available (take newer)
#
# delete locally when remote file disapperad, better put locally into version
# delete remote when local file disappered
#
#
#Several such libraries include:
#
#    Net::BitTorrent or here , with documentation here
#    Protocol::BitTorrent
#
#Several existing Perl BitTorent clients include:
#
#    Bitflu
#    AnyEvent::BitTorrent
#    Basic Net::BitTorrent Client
#
#Also see this related question.














