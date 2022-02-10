#!/bin/bash

#Config
sharedPubKey="/mnt/pubkey/"
networkAddress="192.168.80.0/24"

#Variables
randomValue=$RANDOM
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')


#Verbose
echo "Defined network address : $networkAddress"
echo "Defined public key location : $sharedPubKey"
echo "----------------"



#NFS share
mkdir $sharedPubKey
chmod 777 $sharedPubKey

echo "/mnt/pubkey $networkAddress(ro,sync,no_subtree_check)" >> /etc/exports

exportfs -a
systemctl restart nfs-kernel-server
echo "----------------"



#Creating SSH keys
ssh-keygen -f ~/.ssh/id_rsa -N "" -t rsa
cp ~/.ssh/id_rsa.pub $sharedPubKey



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
      echo "----------------"

      ssh-keyscan $i >> ~/.ssh/known_hosts
      echo "----------------"

      mkdir /var/pubkey${i##*.}
      mount -t nfs $i:/mnt/pubkey${i##*.} /var/pubkey${i##*.}
      cat /var/pubkey${i##*.} >> ~/.ssh/authorized_keys
   fi
done
echo "----------------"