# Setting up services

In order to have KVM guest OS properly running with GVTg GPU, we need to have several services in order:
* VGPU service
* Guest OS service

Both services requires configuration which will be defined in an executable script file called /var/vm/scripts/env.sh  Make sure the file is executable.
```
sudo chmod +x /var/vm/scripts/env.sh
```

## VGPU service

VGPU service is responsible for defining display mapping and creation of VGPU. There will be two scripts provided to support the execution of VGPU service, one for creation and one for destruction of VGPUs.

### To create VGPUs (manually)
```
sudo chmod +x /var/vm/scripts/create-vgpu.sh
sudo bash -x /var/vm/scripts/create-vgpu.sh
```
If you see the error: "sh: echo: I/O error"
Make sure your aperture size in BIOS is set to the maximum value.

### To destroy VGPUs (manually)

File (executable): /var/vm/scripts/destroy-vgpu.sh
```
sudo chmod +x /var/vm/scripts/destroy-vgpu.sh
sudo bash -x /var/vm/scripts/destroy-vgpu.sh
```

### To create VGPUs (automatically) using systemd

File:/etc/systemd/system/vgpu.service

Once the files are located in place with the right permission (i.e. executable), we can enable the VGPU service.
```
sudo systemctl enable vgpu.service
sudo systemctl start vgpu.service
```

## QEMU service

### To start QEMU VM (manually)

QEMU service is responsible for starting and stopping VM. It depends on two exectable scripts:
* /var/vm/scripts/start-vm.sh
* /var/vm/scripts/stop-vm.sh

Both scripts require one argument. This argument will be one file stored at /var/vm/cfg/${name}.sh. (See examples below)

### To start QEMU VM (automatically) using systemd


In order to use those scripts and configuration to manage VM in an automated fashion, the following qemu@.service file should be defined to dynamically run the VM based on the configuration.

File: /etc/systemd/system/qemu@.service
Note: edit the "User" to the designated user to run VM.

To ensure the service file is re-read by systemd, please call daemon-reload.
```
$ sudo systemctl daemon-reload
```
Let say we want to enable and to start Ubuntu VM automatically. Here is the step we need to do after we place the configuration file in /var/vm/cfg/:
```
$ sudo systemctl enable qemu@ubuntu.service
$ sudo systemctl start qemu@ubuntu.service
```

### Example CIV 
```
#Create CIV folder
mkdir /var/vm/civ
cd /var/vm/civ

#Download precompiled binaries
wget https://github.com/projectceladon/celadon-binary/raw/master/CIV_00.20.02.24_A10/caas-ota-QMm000000.zip
wget https://github.com/projectceladon/celadon-binary/raw/master/CIV_00.20.02.24_A10/caas-releasefiles-userdebug.tar.gz

#Script setup
chmod +x scripts/*.sh
mkdir sof_audio
mv -t sof_audio ./scripts/sof_audio/configure_sof.sh ./scripts/sof_audio/blacklist-dsp.conf
chmod +x scripts/guest_pm_control
chmod +x scripts/findall.py
chmod +x scripts/thermsys
chmod +x scripts/batsys

#Audio setup
./sof_audio/configure_sof.sh "install" $CIV_WORK_DIR
./scripts/setup_audio_host.sh

#Thermal setup
systemctl stop thermald.service
cp ./scripts/intel-thermal-conf.xml /etc/thermald
cp ./scripts/thermald.service  /lib/systemd/system
systemctl daemon-reload
systemctl start thermald.service

#9p_module setup
modprobe 9pnet
modprobe 9pnet_virtio
modprobe 9p
mkdir ./share_folder

#Flash the file system
tar -xvf caas-releasefiles-userdebug.tar.gz
./scripts/start_flash_usb.sh caas-flashfiles-QMm000000.zip --display-off

#Start up system
./scripts/start_android_qcow2.sh

