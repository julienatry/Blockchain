#!/bin/bash

randomValue=$RANDOM
nmap_output=$(nmap $1 -n -sP 192.168.80.0/24 | grep report | awk '{print $5}')

echo "Live blockchain hosts :"
for i in $nmap_output
do
   if [ "${i##*.}" -gt "100" ] && [ "${i##*.}" -lt "200" ]
   then
      echo "$i"
      echo "$i" >> /etc/dsh/group/blockchain
   fi
done
cat /etc/dsh/group/blockchain >> /etc/dsh/machines.list
echo "----------------"


for i in $nmap_output
do
   if [ "${i##*.}" -gt "100" ] && [ "${i##*.}" -lt "200" ]
   then
      echo "Working on $i"
   fi
done
echo "----------------"