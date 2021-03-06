#!/bin/bash

### Config
networkAddress="192.168.134.0/24"
dsh_group="/etc/dsh/group/blockchain"

### Verify root privileges
# If the EUID is not 0 (root), notify on prompt and crash
if [[ $EUID -ne 0 ]]; then
    echo "I must be opened with root privileges"
    exit 1
fi

### Variables
my_ip=$(ifconfig | grep ${networkAddress%.*} | awk '{print $2}')
known_hosts_exists=$(cat ~/.ssh/known_hosts | grep $2)
known_hosts_rsa=$(cat ~/.ssh/known_hosts | grep $sshKeyScan)

### Blacklist init
# Read the "blacklist_ip" file into the "blacklist" var (array)
readarray -t blacklist < /root/scripts/blacklist_ip

### Functions
# Add the IP in the dsh group if it doesn't exist
dsh_update() {
    dsh_exists=$(cat $dsh_group | grep $1)
    if [[ -z $dsh_exists ]]; then
        echo $1 >> $dsh_group
    fi
    # Copy dsh group to machine list
    cat $dsh_group > /etc/dsh/machines.list
}

# Update keys and reload ssh
ssh_update() {
    case $1 in
    known_hosts)
        # If the IP is already in known_hosts
        if [[ ! -z known_hosts_exists ]]; then
            # Retrieve the remote key
            local sshKeyScan=$(ssh-keyscan -t rsa $2)
            # If a key already exists, delete it
            if [[ ! -z known_hosts_rsa ]]; then
                sed -i "/$2/d" ~/.ssh/known_hosts
            fi

            # Write the new key in known_hosts
            echo $sshKeyScan >>~/.ssh/known_hosts
        fi
        ;;
    authorized_keys)
        pubkey_dir="/var/pubkey${2##*.}"
        # Create the folder if it doesn't exist
        if [[ ! -d $pubkey_dir ]]; then
            mkdir $pubkey_dir
        fi
        # Mount the folder using NFS
        mount -t nfs $2:/mnt/pubkey $pubkey_dir

        remote_pubkey=$(<$pubkey_dir/id_rsa.pub)
        current_pc=${remote_pubkey##*@}
        authorized_keys_check=$(cat ~/.ssh/authorized_keys | grep $current_pc)
        authorized_keys_length=${#authorized_keys_check}
        # If the remote key already exists in local "authorized_keys", replace it with the new one
        if [[ authorized_keys_length -gt 1 ]]; then
            sed -i "/$current_pc/d" ~/.ssh/authorized_keys
        fi
        # Indent the remote public key to the authorized keys file
        echo $remote_pubkey >>~/.ssh/authorized_keys

        umount $pubkey_dir
        ;;

    reload)
        #systemctl reload ssh
        systemctl restart ssh
        ;;
    esac
}

### Infinite loop
while true; do
    # Scan for addresses
    nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')
    # For each address in the scan
    for ip in $nmap_output; do
        # If the current processing IP is not mine and not blacklisted
        if [ "$ip" != "$my_ip" ] && [[ ! "${blacklist[*]}" =~ "${ip}" ]]; then
            echo "----------------"
            echo "Working on $ip"
            echo "----------------"
            # Update dsh list with the IP
            dsh_update $ip
            # Update known_hosts file
            ssh_update known_hosts $ip
            # Update authorized_keys file
            ssh_update authorized_keys $ip
            # Reload ssh
            ssh_update reload
        fi
    done
    # Need to be fine-tuned
    sleep 60
done
