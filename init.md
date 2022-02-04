# Install dependencies
sudo apt install openssh-server dsh

# Config files to modify
## Configure DSH to use SSH instead of RSH
sudo nano /etc/dsh/dsh.conf

## Define every computer to join in this file (IP or user@IP)
sudo nano /etc/dsh/group/blockchain

## Copy previous list to DSH's machine list
sudo cat /etc/dsh/group/blockchain >> /etc/dsh/machines.list

## Generate RSA key to be used for SSH
###### We will need to copy this key to every machine in the list
ssh-keygen -t rsa

## Retrieve the SSH key from a machine to the known hosts list on the local machine
ssh-keyscan -f ip_list >> ~/.ssh/known_hosts
