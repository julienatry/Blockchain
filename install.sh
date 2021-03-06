#!/bin/bash

sudo apt update && sudo apt install -y openssh-server dsh nmap nfs-kernel-server nfs-common net-tools git

git clone https://github.com/julienatry/Blockchain.git

mv Blockchain/blockchain_* Blockchain/blacklist_ip /root/scripts
mv Blockchain/services/* /etc/systemd/system/

chmod +x /root/scripts/blockchain_*

rm -rf Blockchain

systemctl enable blockchain
systemctl enable blockchain_new_device
systemctl enable blockchain_passwd_check
