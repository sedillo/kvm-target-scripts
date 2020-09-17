#!/bin/sh
NAME="Ubuntu-Guest"
MAC="00:DE:AD:BE:EF:F1"
MACHINE="q35"
HDD=$DIR/disk/ubuntu.qcow2
ISO=$DIR/iso/ubuntu-20.04.1-desktop-amd64.iso
BIOS=$DIR/fw/OVMF.fd
DEVPT="-device usb-host,hostbus=1,hostport=3.1 -device usb-host,hostbus=1,hostport=3.2"
