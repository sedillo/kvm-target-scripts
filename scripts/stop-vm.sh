#!/bin/bash
iskvm=$(groups | grep kvm | wc -l)
if [[ $iskvm -ne 1 ]] && [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or user with kvm group" 
   exit 1
fi

CFDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd)"
envconfig="${CFDIR}/env.sh"

if [ -f $envconfig ]; then
        source $envconfig
else
        echo "Could not find necessary environment setting."
        exit 1
fi

# check current dir
CFG=${1}
NOSFX=${CFG%.sh}
VMNAME=${NOSFX##*/}

if [ $# -eq 0 ]
then
        echo "No argument supplied, please pass the name of the vmname specified by cfg/vmname.sh"
        exit 1
fi

# check if configuration exist
if [[ -x "$CFG" ]]
then
        source $CFG
else
        echo "VM configuration file is either not found or not executable"
        exit 1
fi

#This didn't work for me
#if [ ! -z "$MONITOR" ]
#then
	#echo 'system_powerdown' |  nc localhost $MONITOR	
#fi	
PIDFILE=/tmp/qemu_${VMNAME}.pid
if [ ! -z "$PIDFILE" ]; then
	kill -9 `cat $PIDFILE`
fi


