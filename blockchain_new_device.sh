#!/bin/bash

#Config
networkAddress="192.168.80.0/24"



#Variables
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')
pubkey_dir="/var/pubkey${i##*.}"



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
	for i in $nmap_output
	do
		if [ "${i##*.}" -gt "100" ] && [ "${i##*.}" -lt "200" ]
		then
			echo "$i"
			echo "$i" >> /etc/dsh/group/blockchain
		fi
	done
	cat /etc/dsh/group/blockchain >> /etc/dsh/machines.list
	echo "----------------"



	#Public SSH keys retrieving
	for i in $nmap_output
	do
		if [ "${i##*.}" -gt "100" ] && [ "${i##*.}" -lt "200" ]
		then
			echo "----------------"
			echo "Working on $i"
			echo "----------------"

			ssh-keyscan $i >> ~/.ssh/known_hosts
			echo "----------------"

			if [ -d $pubkey_dir ]; then
				#statements
			fi
			mkdir $pubkey_dir
			
			mount -t nfs $i:/mnt/pubkey $pubkey_dir
			cat $pubkey_dir/id_rsa.pub >> ~/.ssh/authorized_keys
		fi
	done
	sleep 10
done
echo "----------------"