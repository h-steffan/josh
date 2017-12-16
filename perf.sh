#!/usr/bin/bash
dd if=/dev/urandom of=~/randfile bs=1M count=100
a1=`date`
SECONDS=0
cp randfile $1
duration=$SECONDS
bandwidth=$((100000 * 8 / $duration))
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
a2=`date`
echo $a2 $a1 $bandwidth "kbps"
# https://stackoverflow.com/questions/11065077/eval-command-in-bash-and-its-typical-uses
# 
