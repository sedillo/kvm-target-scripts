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

# check if it has argument passed
if [ $# -eq 0 ]
then
        echo "No argument supplied, please pass the name of the vmname specified by cfg/vmname.sh"
        exit 1
fi

# check if configuration exist
CFG=${1}
NOSFX=${CFG%.sh}
VMNAME=${NOSFX##*/}

if [[ -x "$CFG" ]]
then
        source $CFG
else
        echo "VM configuration file is either not found or not executable"
        exit 1
fi

echo $DIR
$DIR/scripts/rmstalepid.sh ${VMNAME}

QEMU="/usr/bin/qemu-system-x86_64 -enable-kvm "
DEF_MEMORY=2048
DEF_CPU=2
DEF_MACHINE="pc"

QEMU_SCRIPT="$QEMU "
# memory configuration
if [ -z "$MEMORY" ]
then
        MEMORY=$DEF_MEMORY
fi
# core configuration
if [ -z "$CPU" ]
then
        CPU=$DEF_CPU
fi

# machine configuration
if [ -z "$MACHINE" ]
then
        MACHINE=$DEF_MACHINE
fi

QEMU_SCRIPT+=" -m $MEMORY -smp $CPU -M $MACHINE"

if [ ! -z "$NAME" ]
then
        QEMU_SCRIPT+=" -name "$NAME
fi

#BIOS
if [ ! -z "$BIOS" ]
then
        QEMU_SCRIPT+=" -bios "$BIOS
fi


if [ ! -z "$HDD" ]
then
        QEMU_SCRIPT+=" -hda "$HDD
fi

if [ ! -z "$ISO" ]
then
        QEMU_SCRIPT+=" -cdrom "$ISO
fi

if [ -z "$MAC" ]
then
        QEMU_SCRIPT+=" -net nic "
else
        QEMU_SCRIPT+=" -net nic,model=virtio,macaddr="$MAC 
fi


if [ -z "$IFUP" ]
then
        QEMU_SCRIPT+=" -net user"
else
        QEMU_SCRIPT+=" -net tap,script="$IFUP",downscript=no"
fi


if [ ! -z "$VGA" ]
then
        QEMU_SCRIPT+=" -vga "$VGA
fi

if [ ! -z "$EGL" ]
then
        QEMU_SCRIPT+=" -display "$EGL
fi

QEMU_SCRIPT+=" -k en-us"

if [ ! -z "$SERIAL" ]
then
        QEMU_SCRIPT+=" -serial "$SERIAL
fi

if [ ! -z "$VNC" ]
then
        QEMU_SCRIPT+=" -vnc "$VNC
fi

if [ ! -z "$SPICE" ]
then
        QEMU_SCRIPT+=" -spice "$SPICE
fi

QEMU_SCRIPT+=" -machine kernel_irqchip=on "
if [ "$MACHINE" == "q35" ]
then
 	QEMU_SCRIPT+=" -global ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 "
else
 	QEMU_SCRIPT+=" -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 "
fi
QEMU_SCRIPT+=" -cpu host -usb -device usb-tablet "
if [ ! -z "$VGPU" ]
then
        if [ -z "$DISPLAY" ]
        then
                DISPLAY="off"
        fi
        QEMU_SCRIPT+=" -device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:02.0/$VGPU,rombar=0,display=$DISPLAY,x-igd-opregion=on"
fi

if [ ! -z "$DEVPT" ]
then
        QEMU_SCRIPT+=" $DEVPT"
fi

if [ ! -z "$MONITOR" ]
then
	QEMU_SCRIPT+=" -monitor telnet:localhost:$MONITOR,server,nowait,nodelay "
fi
# Daemonize and store PID at /tmp/qemu_filename.pid

QEMU_SCRIPT+=" -daemonize -pidfile /tmp/qemu_${VMNAME}.pid "
#echo "Script: "$QEMU_SCRIPT
#Run qemu
$QEMU_SCRIPT
