#!/bin/bash

#Config
networkAddress="192.168.80.0/24"



#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened by root"
   exit 1
fi



#Variables
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
if [ ! -f $rsa_file ]; then
   ssh-keygen -f ~/.ssh/id_rsa -N "" -t rsa
fi


cp $rsa_file.pub $sharedPubKey



#




bash ./blockchain_new_device.sh &