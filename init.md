# Install dependencies
sudo apt install openssh-server dsh nmap nfs-kernel-server nfs-common

# Config files to modify
## Configure DSH to use SSH instead of RSH
sudo nano /etc/dsh/dsh.conf