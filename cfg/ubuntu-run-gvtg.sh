#!/bin/sh
NAME="Ubuntu-Guest"
VGPU=${VGPU1}
MAC="00:DE:AD:BE:EF:F1"
MACHINE="q35"
HDD=$DIR/disk/ubuntu.qcow2
BIOS=$DIR/fw/OVMF.fd
#IFUP=$DIR/script/qemu-ifup-bridge
DISPLAY="on"
VGA="none"
#SERIAL="stdio"
VNC=":1"
EGL="egl-headless"
#DEVPT="-device usb-host,hostbus=1,hostport=3.1 -device usb-host,hostbus=1,hostport=3.2"
DEVPT="-device usb-host,hostbus=1,hostaddr=6"
