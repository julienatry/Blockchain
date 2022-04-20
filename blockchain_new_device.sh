#!/bin/bash


#Config
networkAddress="192.168.80.0/24"


#Variables
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')
my_ip=$(ifconfig | grep 192.168.80 | awk '{print $2}')
known_hosts_exists=$(cat ~/.ssh/known_hosts | grep $1)
known_hosts_rsa=$(cat ~/.ssh/known_hosts | grep $sshKeyScan)
dsh_group="/etc/dsh/group/blockchain"
pubkey_dir="/var/pubkey${ip##*.}"




#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened with root privileges"
   exit 1
fi




#Functions
dsh_update () {
	dsh_exists=$(cat $dsh_group | grep $1)

	if [[ -z $dsh_exists ]]; then
		echo $1 >> $dsh_group
	fi

	cat $dsh_group > /etc/dsh/machines.list
}

ssh_update () {
	if [[ -z known_hosts_exists ]]; then
		sshKeyScan=$(ssh-keyscan -t rsa $1)

		if [[ -z known_hosts_rsa ]]; then
			sed -i "/$1/d" ~/.ssh/known_hosts
		fi

		echo $sshKeyScan >> ~/.ssh/known_hosts

		systemctl reload ssh
	fi
}




#Infinite loop
while true
do

	#Live hosts list + SSH/DSH updates
	echo "Live blockchain hosts :"
	for ip in $nmap_output
	do
		if [ "${ip##*.}" -gt "100" ] && [ "${ip##*.}" -lt "200" ] && [ "$ip" != "$my_ip" ]
		then
			echo "----------------"
			echo "Working on $ip"
			echo "----------------"

			dsh_update $ip

			ssh_update $ip


			#Remote pubkey retrieving via NFS
			if [ ! -d $pubkey_dir ]; then
				mkdir $pubkey_dir
			fi

			mount -t nfs $ip:/mnt/pubkey $pubkey_dir
			cat $pubkey_dir/id_rsa.pub >> ~/.ssh/authorized_keys
			umount $pubkey_dir
		fi
	done
	sleep 60
done