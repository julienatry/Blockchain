# Blockchain
L3 pro SRSI, project 

# Dependencies
```
sudo apt update && sudo apt install openssh-server dsh nmap nfs-kernel-server nfs-common net-tools
```

# Config
1. Execute install.sh
2. Change "networkAddress" variable in "blockchain_init" and "blockchain_new_device" with your own network address
3. Change "totoadmin" usernamein "blockchain_passwd_check" with the username you want to check
4. Add non-blockchain hosts to blacklist (Optional)
5. Reboot