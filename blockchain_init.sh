#!/bin/bash

#Config
networkAddress="192.168.80.0/24"



#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened by root"
   exit 1
fi



#Variables
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')
existing_exports=$(cat /etc/exports | grep /mnt/pubkey)
rsa_file=~/.ssh/id_rsa
sharedPubKey="/mnt/pubkey/"


#Verbose
echo "Defined network address : $networkAddress"
echo "Defined public key location : $sharedPubKey"
echo "----------------"



#NFS share
if [[ ! -d $sharedPubKey ]]; then
   mkdir $sharedPubKey
fi

chmod 777 $sharedPubKey

if [[ -z existing_exports ]]; then
   echo "/mnt/pubkey $networkAddress(ro,sync,no_subtree_check)" > /etc/exports
fi


exportfs -a
systemctl restart nfs-kernel-server
echo "----------------"



#Creating SSH keys
if [ -f $rsa_file ]; then
   rm $rsa_file $rsa_file.pub
fi

ssh-keygen -f $rsa_file -N "" -t rsa

cp $rsa_file.pub $sharedPubKey


bash ./blockchain_new_device.sh &