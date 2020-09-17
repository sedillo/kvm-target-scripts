#!/bin/sh
NAME="Neverware-Guest"
VGPU=${VGPU1}
MAC="00:DE:AD:BE:EF:F3"
MACHINE="q35"
HDD=$DIR/disk/neverware.qcow2
BIOS=$DIR/fw/OVMF.fd
DISPLAY="on"
VGA="none"
VNC=":1"
EGL="egl-headless"
MONITOR=7101
DEVPT="-device usb-host,hostbus=1,hostaddr=14" 

