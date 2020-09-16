#!/bin/sh
NAME="Neverware-Guest"
VGPU="f50aab10-7cc8-11e9-a94b-6b9d8245bfc2"
MAC="00:DE:AD:BE:EF:F2"
MACHINE="q35"
HDD=/var/vm/disk/neverware2.qcow2
BIOS=/var/vm/fw/OVMF.fd
#IFUP=/var/vm/script/qemu-ifup-bridge
DISPLAY="on"
#SERIAL="stdio"
VGA="none"
VNC=":2"
EGL="egl-headless"
#EGL="drm,output=DP-3,gl=on,direct=on,libinput=off"
# local tcp socket for controlling vm
MONITOR=7102
DEVPT="-device usb-host,hostbus=1,hostport=3.1 -device usb-host,hostbus=1,hostport=3.2"
