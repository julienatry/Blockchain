#!/bin/bash

username="root"
required_fract=75.00


user_search=$(cat /etc/shadow | grep $username)
dsh_output=$(dsh -g blockchain -c "cat /etc/shadow | grep $username")
i=1
valid=0
invalid=0

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

fract=$(echo "scale=2; $valid/$i*100" | bc -l)

if [[ fract -gt required_fract ]]; then
	echo "Autorisé"
else
	echo "Non autorisé"
fi