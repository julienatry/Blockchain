#!/bin/bash

randomValue=$RANDOM
nmap_output=$(nmap $1 -n -sP 192.168.80.0/24 | grep report | awk '{print $5}')

echo "Live blockchain hosts :"
for i in $nmap_output
do
   if [ "${i##*.}" -gt "100" ]
   then
      echo "$i"
      echo "$i" >> /etc/dsh/group/blockchain
   fi
done
cat /etc/dsh/group/blockchain >> /etc/dsh/machines.list
echo "----------------"

last_ip="${nmap_output##*$'\n'}"
last_ip_oct=${last_ip##*.}
new_ip=$(($last_ip_oct + 1))
echo "ip : 192.168.80.$new_ip"
echo "----------------"

#ifconfig ens33 192.168.80.$new_ip/24

for i in $nmap_output
do
   if [ "${i##*.}" -gt "100" ]
   then
      echo "Working on $i"
   fi
done
echo "----------------"


echo "user$randomValue:PaSsWd$randomValue"
echo "user$randomValue:PaSsWd$randomValue" > /tmp/user.txt

#useradd user$randomValue
#chpasswd </tmp/user.txt

sleep 5