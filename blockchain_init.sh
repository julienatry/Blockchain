#!/bin/bash

#Config
sharedPubKey="/mnt/pubkey/"
networkAddress="192.168.80.0/24"

#Variables
randomValue=$RANDOM
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')




#NFS share
mkdir $sharedPubKey
chmod 777 $sharedPubKey

echo "/mnt/pubkey $networkAddress(ro,sync,no_subtree_check)" >> /etc/exports

exportfs -a
systemctl restart nfs-kernel-server
echo "----------------"



#DSH hosts list
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



#Public SSH keys retrieving
for i in $nmap_output
do
   if [ "${i##*.}" -gt "100" ] && [ "${i##*.}" -lt "200" ]
   then
      echo "Working on $i"
      mkdir /var/pubkey${i##*.}
      mount -t nfs $i:/mnt/pubkey${i##*.} /var/pubkey${i##*.}
      cat /var/pubkey${i##*.} >> ~/.ssh/authorized_keys
   fi
done
echo "----------------"