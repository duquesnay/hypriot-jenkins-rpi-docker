#!/bin/bash
sed -i -e 's/^/#/' /etc/ld.so.preload
sed -i -e 's/^snd_bcm/#snd_bcmx/' /etc/modules-load.d/modules.conf
# TODO: clean this up with a bash var for path
touch /etc/udev/rules.d/90-qemu.rules
echo 'KERNEL=="sda", SYMLINK+="mmcblk0"' >> /etc/udev/rules.d/90-qemu.rules
echo 'KERNEL=="sda?", SYMLINK+="mmcblk0p%n"' >> /etc/udev/rules.d/90-qemu.rules
echo 'KERNEL=="sda2", SYMLINK+="root"' >> /etc/udev/rules.d/90-qemu.rules

