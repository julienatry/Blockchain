#!/bin/bash

#Config
networkAddress="192.168.80.0/24"



#Variables
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')
known_hosts_exists=$(cat ~/.ssh/known_hosts | grep $ip | grep rsa)
pubkey_dir="/var/pubkey${ip##*.}"



#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened by root"
   exit 1
fi


#Infinite loop
while true
do

	#DSH hosts list
	echo "Live blockchain hosts :"
	for ip in $nmap_output
	do
		if [ "${ip##*.}" -gt "100" ] && [ "${ip##*.}" -lt "200" ]
		then
			echo "$ip"
			echo "$ip" >> /etc/dsh/group/blockchain
		fi
	done
	cat /etc/dsh/group/blockchain >> /etc/dsh/machines.list
	echo "----------------"



	#Public SSH keys retrieving
	for ip in $nmap_output
	do
		if [ "${ip##*.}" -gt "100" ] && [ "${ip##*.}" -lt "200" ]
		then
			echo "----------------"
			echo "Working on $ip"
			echo "----------------"

			if [[ -z $known_hosts_exists ]]; then
				ssh-keyscan $ip >> ~/.ssh/known_hosts
			fi

			echo "----------------"

			if [ ! -d $pubkey_dir ]; then
				mkdir $pubkey_dir
			fi
			
			mount -t nfs $ip:/mnt/pubkey $pubkey_dir
			cat $pubkey_dir/id_rsa.pub >> ~/.ssh/authorized_keys
		fi
	done
	sleep 10
done
echo "----------------"