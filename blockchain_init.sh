#!/bin/bash

#Config
sharedPubKey="/mnt/pubkey/"
networkAddress="192.168.80.0/24"



#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened by root"
   exit 1
fi



#Variables
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')
existing_exports=$(cat /etc/exports | grep /mnt/pubkey)



#Verbose
echo "Defined network address : $networkAddress"
echo "Defined public key location : $sharedPubKey"
echo "----------------"



#NFS share
mkdir $sharedPubKey
chmod 777 $sharedPubKey

if [[ existing_exports -eq 0 ]]; then
   echo "/mnt/pubkey $networkAddress(ro,sync,no_subtree_check)" > /etc/exports
fi


exportfs -a
systemctl restart nfs-kernel-server
echo "----------------"



#Creating SSH keys
ssh-keygen -f ~/.ssh/id_rsa -N "" -t rsa
cp ~/.ssh/id_rsa.pub $sharedPubKey


bash ./blockchain_new_device.sh &