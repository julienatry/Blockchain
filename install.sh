#!/bin/bash

sudo apt update && sudo apt install -y openssh-server dsh nmap nfs-kernel-server nfs-common net-tools

git clone https://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@github.com/TakaFrey/Blockchain.git

mv Blockchain/blockchain_* Blockchain/blacklist_ip /root/scripts
mv Blockchain/services/* /etc/systemd/system/

chmod +x /root/scripts/blockchain_*

rm -rf Blockchain

systemctl enable blockchain
systemctl enable blockchain_new_device
systemctl enable blockchain_passwd_check