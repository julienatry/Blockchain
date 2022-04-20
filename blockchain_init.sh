#!/bin/bash

#Config
networkAddress="192.168.80.0/24"



#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened with root privileges"
   exit 1
fi



#Variables
existing_exports=$(cat /etc/exports | grep /mnt/pubkey)
rsa_file=~/.ssh/id_rsa
sharedPubKey="/mnt/pubkey/"
ssh_config="/etc/ssh/sshd_config"
dsh_config="/etc/dsh/dsh.conf"
isSSHSecured=$(cat $ssh_config | grep "Secured for blockchain")
isDSHConfigured=$(cat $dsh_config | grep "Configured for blockchain")


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
   rm $rsa_file
fi

ssh-keygen -f ~/.ssh/id_rsa -N "" -t rsa

cp $rsa_file.pub $sharedPubKey



#Configure SSH
if [[ -z $isSSHSecured ]]; then
   sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' $ssh_config
   sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' $ssh_config
   sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/g' $ssh_config

   sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' $ssh_config
   sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' $ssh_config
   sed -i 's/#ChallengeResponseAuthentication no/ChallengeResponseAuthentication no/g' $ssh_config

   sed -i 's/#UsePAM yes/UsePAM no/g' $ssh_config
   sed -i 's/UsePAM yes/UsePAM no/g' $ssh_config
   sed -i 's/#UsePAM no/UsePAM no/g' $ssh_config

   sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' $ssh_config
   sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication yes/g' $ssh_config
   sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' $ssh_config

   echo "#Secured for blockchain" >> $ssh_config

   systemctl reload ssh
   systemctl restart ssh
fi



#Configure DSH
if [[ -z $isDSHConfigured ]]; then
   sed -i 's/remoteshell =rsh/remoteshell =ssh/g' $dsh_config

   echo "#Configured for blockchain" >> $dsh_config
fi



bash ./blockchain_new_device.sh &