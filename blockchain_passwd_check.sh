#!/bin/bash

### Config
# Requiered percentage of valid replies for connection approval
required_fract=60

### Verify root privileges
# If the EUID is not 0 (root), notify on prompt and crash
if [[ $EUID -ne 0 ]]; then
    echo "I must be opened with root privileges"
exit 1
fi

### Infinite loop
while true; do
    ### Wait for a user to connect
    while true; do
        connected_username=$(who | grep totoadmin)
        # When the user tries to connect
        if [[ ! -z $connected_username ]]; then
            echo $connected_username
            username=$(echo $connected_username | awk '{print $1}')
            echo username
            # Leave the loop
            break
        fi
    done

    ### Variables
    local_hash=$(cat /etc/shadow | grep $username)
    dsh_output=$(dsh -g blockchain -c "cat /etc/shadow | grep $username")
    index=1
    # Quantity of valid replies
    valid=0
    # Quantity of invalid replies
    invalid=0

    for response in $dsh_output; do
        response_conv=$response
        # If the username associated hash matches the one our /etc/shadow, add a valid reply
        if [[ "$response_conv" == "$local_hash" ]]; then
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
    else
        echo "Non autorisé"
        killall -u $username
    fi
done