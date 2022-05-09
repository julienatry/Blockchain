#!/bin/bash

#Config
username="root"
required_fract=75


#Variables
user_search=$(cat /etc/shadow | grep $username)
dsh_output=$(dsh -g blockchain -c "cat /etc/shadow | grep $username")
i=1
valid=0
invalid=0



#DSH poll for user auth
for response in $dsh_output
do
	response_conv=$response

	if [[ "$response_conv" == "$user_search" ]]; then
		valid=$((valid+1))
		echo "Response $i is valid"
	else
		invalid=$((invalid+1))
		echo "Response $i is invalid"
	fi

	i=$((i+1))
done

echo "Valid : $valid"
echo "Invalid : $invalid"




#Checking if required fract is reached
fract=$(echo "scale=2; $valid/$i*100" | bc -l)
fract_corr=$(echo "${fract%.*}")

if [[ fract_corr -gt required_fract ]]; then
	echo "Autorisé"
else
	echo "Non autorisé"
fi