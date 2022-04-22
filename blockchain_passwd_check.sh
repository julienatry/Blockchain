 #!/bin/bash

username="root"


user_search=$(car /etc/shadow | grep $username)
dsh_output=$(dsh -g blockchain -c "cat /etc/shadow | grep $username")
i=1
valid=0
invalid=0

for response in $dsh_output; do
	response_conv=$response

	if [[ "$response_conv" == "$user_search" ]]; then
		valid=$((valid+1))
		echo "Response $i is valid"
	else
		invalid=$((invalid+1))
		echo "Response $i is invalid"
	fi
done

echo "Valid : $valid"
echo "Invalid : $invalid"