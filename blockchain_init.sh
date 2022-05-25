#!/bin/bash

### Variables
networkAddress="192.168.239.0/24"
time=$(date)
existing_exports=$(cat /etc/exports | grep /mnt/pubkey)
rsa_file=~/.ssh/id_rsa
sharedPubKey="/mnt/pubkey/"
ssh_config="/etc/ssh/sshd_config"
dsh_config="/etc/dsh/dsh.conf"
isSSHSecured=$(cat $ssh_config | grep "Secured for blockchain")
isDSHConfigured=$(cat $dsh_config | grep "Configured for blockchain")

### Verify root privileges
# If the EUID is not 0 (root), notify on prompt and crash
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened with root privileges"
   exit 1
fi

### Net address and key location notification on prompt (what for?)
echo "Current time : $time"
echo "Defined network address : $networkAddress"
echo "Defined public key location : $sharedPubKey"
echo "----------------"

### Network File System sharing
# Create shared folder if it doesn't exist
if [[ ! -d $sharedPubKey ]]; then
   mkdir $sharedPubKey
fi
# Grant every right for everyone to the folder (to redo in read-only)
chmod 777 $sharedPubKey
# Create the NFS share if it doen't exist
if [[ ! -z existing_exports ]]; then
   echo "/mnt/pubkey $networkAddress(ro,sync,no_subtree_check)" >/etc/exports
fi
# Activate sharing
exportfs -a
# Restart NFS server
systemctl restart nfs-kernel-server
echo "----------------"

### Creating SSH keys
# If a key is already there, delete it
if [ -f $rsa_file ]; then
   rm $rsa_file
fi
# Generate a new pair
ssh-keygen -f ~/.ssh/id_rsa -N "" -t rsa
# Copy the public key to the shared folder
cp $rsa_file.pub $sharedPubKey

### SSH configuration
# if SSH is not secured
if [[ -z $isSSHSecured ]]; then
   # Set PasswordAuthentication to no and uncomment it in the ssh configuration
   sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' $ssh_config
   sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' $ssh_config
   # Set ChallengeResponseAuthentication to no and uncomment it in the ssh confifguration
   sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' $ssh_config
   sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' $ssh_config
   # Append ssh config file with tag so we don't run this configuration again
   echo "#Secured for blockchain" >>$ssh_config

   #systemctl reload ssh
   systemctl restart ssh
   #systemctl restart sshd.service
fi

### DSH configuration
# If DSH is not configured
if [[ -z $isDSHConfigured ]]; then
   # Set remoteshell to ssh
   sed -i 's/remoteshell =rsh/remoteshell =ssh/g' $dsh_config
   # Append dsh config file with tag so we don't run this configuration again
   echo "#Configured for blockchain" >>$dsh_config
fi

### Files init/reset
echo "" >~/.ssh/known_hosts
echo "" >~/.ssh/authorized_keys
echo "" >/etc/dsh/group/blockchain