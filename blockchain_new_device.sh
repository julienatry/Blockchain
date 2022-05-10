#!/bin/bash

### Variables
networkAddress="192.168.80.0/24"
my_ip=$(ifconfig | grep 192.168.80 | awk '{print $2}')
known_hosts_exists=$(cat ~/.ssh/known_hosts | grep $2)
known_hosts_rsa=$(cat ~/.ssh/known_hosts | grep $sshKeyScan)
dsh_group="/etc/dsh/group/blockchain"

### Verify root privileges
# If EUID empty or unreacheable, notify on prompt and crash
if [[ $EUID -ne 0 ]]; then
	echo "I must be opened with root privileges"
	exit 1
fi

### Functions
# Add the IP in the dsh group if it doesn't exist
dsh_update() {
	dsh_exists=$(cat $dsh_group | grep $1)
	if [[ -z $dsh_exists ]]; then
		echo $1 >>$dsh_group
	fi
	# Copy dsh group to machine list
	cat $dsh_group >/etc/dsh/machines.list
}

#
ssh_update() {
	case $1 in
	known_hosts)
		# If the IP is already known
		if [[ ! -z known_hosts_exists ]]; then
			# Search for its key
			local sshKeyScan=$(ssh-keyscan -t rsa $2)
			# If a key already exists, replace it (used when computers reboot)
			if [[ ! -z known_hosts_rsa ]]; then
				sed -i "/$2/d" ~/.ssh/known_hosts
			fi

			echo $sshKeyScan >>~/.ssh/known_hosts
		fi
		;;
	authorized_keys)
		pubkey_dir="/var/pubkey${2##*.}"

		if [[ ! -d $pubkey_dir ]]; then
			mkdir $pubkey_dir
		fi

		mount -t nfs $2:/mnt/pubkey $pubkey_dir

		remote_pubkey=$(<$pubkey_dir/id_rsa.pub)
		current_pc=${remote_pubkey##*@}
		authorized_keys_exists=$(cat ~/.ssh/authorized_keys | grep $current_pc)
		response_length=${#authorized_keys_exists}

		if [[ response_length -gt 1 ]]; then
			sed -i "/$current_pc/d" ~/.ssh/authorized_keys
		fi

		echo $remote_pubkey >>~/.ssh/authorized_keys

		umount $pubkey_dir
		;;

	reload)
		systemctl reload ssh
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
		# If the last number of the IP is between 100 and 200 and it isn't my IP
		if [ "${ip##*.}" -gt "100" ] && [ "${ip##*.}" -lt "200" ] && [ "$ip" != "$my_ip" ]; then
			echo "----------------"
			echo "Working on $ip"
			echo "----------------"
			# Update dsh list with the IP
			dsh_update $ip
			# Updated ssh list with IP
			ssh_update known_hosts $ip
			#Remote pubkey retrieving via NFS

			ssh_update authorized_keys $ip
			ssh_update reload
		fi
	done
	sleep 60
done
