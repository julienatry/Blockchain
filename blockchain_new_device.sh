#!/bin/bash


#Config
networkAddress="192.168.80.0/24"


#Variables
my_ip=$(ifconfig | grep 192.168.80 | awk '{print $2}')
known_hosts_exists=$(cat ~/.ssh/known_hosts | grep $2)
known_hosts_rsa=$(cat ~/.ssh/known_hosts | grep $sshKeyScan)
dsh_group="/etc/dsh/group/blockchain"




#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened with root privileges"
   exit 1
fi




#Functions
dsh_update () {
	#DSH entry update
	dsh_exists=$(cat $dsh_group | grep $1)

	if [[ -z $dsh_exists ]]; then
		echo $1 >> $dsh_group
	fi

	cat $dsh_group > /etc/dsh/machines.list
}

ssh_update () {
	case $1 in
		known_hosts )
			#SSH known_hosts key update
			if [[ ! -z known_hosts_exists ]]; then
				local sshKeyScan=$(ssh-keyscan -t rsa $2)

				if [[ ! -z known_hosts_rsa ]]; then
					sed -i "/$2/d" ~/.ssh/known_hosts
				fi

				echo $sshKeyScan >> ~/.ssh/known_hosts
			fi
			;;

		authorized_keys )
			#SSH authorized_keys remote public key update
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

			echo $remote_pubkey >> ~/.ssh/authorized_keys

			umount $pubkey_dir
			;;

		reload )
			systemctl reload ssh
			systemctl restart ssh
			;;
	esac
}




#Infinite loop
while true
do
	#Live hosts list + SSH/DSH updates
	nmap_output=$(nmap $1 -n -sP $networkAddress | grep report | awk '{print $5}')

	for ip in $nmap_output
	do
		if [ "${ip##*.}" -gt "100" ] && [ "${ip##*.}" -lt "200" ] && [ "$ip" != "$my_ip" ]
		then
			echo "----------------"
			echo "Working on $ip"
			echo "----------------"

			dsh_update $ip
			ssh_update known_hosts $ip
			ssh_update authorized_keys $ip
			ssh_update reload
		fi
	done
	sleep 60
done