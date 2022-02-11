#!/bin/bash

#Config
networkAddress="192.168.80.0/24"



#Variables
nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')



#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened by root"
   exit 1
fi





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
while true
do

	for i in $nmap_output
	do
		if [ "${i##*.}" -gt "100" ] && [ "${i##*.}" -lt "200" ]
		then
			echo "----------------"
			echo "Working on $i"
			echo "----------------"

			ssh-keyscan $i >> ~/.ssh/known_hosts
			echo "----------------"

			mkdir /var/pubkey${i##*.}
			mount -t nfs $i:/mnt/pubkey /var/pubkey${i##*.}
			cat /var/pubkey${i##*.}/id_rsa.pub >> ~/.ssh/authorized_keys
		fi
	done
	sleep 10
done
echo "----------------"