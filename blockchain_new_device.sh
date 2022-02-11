#!/bin/bash

#Config
networkAddress="192.168.80.0/24"



#Verify root privileges
if [[ $EUID -ne 0 ]]; then
   echo "I must be opened by root"
   exit 1
fi