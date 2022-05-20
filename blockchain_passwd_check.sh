#!/bin/bash

### Variables
username="root"
# Requiered percentage of valid replies for connection approval
required_fract=75
user_search=$(cat /etc/shadow | grep $username)
dsh_output=$(dsh -g blockchain -c "cat /etc/shadow | grep $username")
index=1
# Quantity of valid replies
valid=0
# Quantity of invalid replies
invalid=0

### Verify root privileges
# If the EUID is not 0 (root), notify on prompt and crash
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened with root privileges"
   exit 1
fi

for response in $dsh_output; do
    response_conv=$response
    # If the username matches the one in /etc/shadow, add a valid reply
    if [[ "$response_conv" == "$user_search" ]]; then
        valid=$((valid + 1))
        echo "Response $index is valid"
        # Else, add an invalid reply
    else
        invalid=$((invalid + 1))
        echo "Response $index is invalid"
    fi
    index=$((index + 1))
done

echo "Valid : $valid"
echo "Invalid : $invalid"
# Calculate the valid/invalid ratio
fract=$(echo "scale=2; $valid/$index*100" | bc -l)
# Keeping the integer part
fract_corr=$(echo "${fract%.*}")

# If the obtained ratio is greater than the minimum required one, autorize the connection
if [[ fract_corr -gt required_fract ]]; then
    echo "Autorisé"
    exit 0
else
    echo "Non autorisé"
    killall -u $username
fi
