#!/bin/bash
iskvm=$(groups | grep kvm | wc -l)
if [[ $iskvm -ne 1 ]] && [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or user with kvm group" 
   exit 1
fi

envconfig="/var/vm/scripts/env.sh"
if [ -f $envconfig ]; then
        source $envconfig
else
        echo "Could not find necessary environment setting."
        exit 1
fi

# check current dir
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# echo "Current script location: "$DIR
# check if it has argument passed
if [ $# -eq 0 ]
then
        echo "No argument supplied, please pass the name of the vmname specified by cfg/vmname.sh"
        exit 1
fi

# check if configuration exist
CFG="$DIR/cfg/${1}.sh"
#echo "VM configuration path is $CFG"
if [[ -x "$CFG" ]]
then
        source $CFG
else
        echo "VM configuration file is either not found or not executable"
        exit 1
fi

if [ ! -z "$MONITOR" ]
then
	echo 'system_powerdown' |  nc localhost $MONITOR	
fi	
