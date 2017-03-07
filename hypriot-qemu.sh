# pulled from  http://xecdesign.com/qemu-emulating-raspberry-pi-the-easy-way/
# expanded via http://superuser.com/questions/690060/how-to-enable-network-with-a-raspberry-pi-emulated-on-qemu
# tested with  2015-02-16-raspbian-wheezy.zip on OSX Mavericks

# OSX terminal
brew install qemu
# kernel-qemu is a linux kernel compiled with ARM1176 support.
# learn more here: http://xecdesign.com/compiling-a-kernel/
curl -OL https://codeload.github.com/dhruvvyas90/qemu-rpi-kernel/zip/master
VERSION=v1.1.3

DIST=hypriotos-rpi-$(VERSION)
ZIP=$(DIST).zip
IMAGE=$(DIST).img

DL_PATH=https://github.com/hypriot/image-builder-rpi/releases/download/$(VERSION)/hypriotos-rpi-$(VERSION).img.zip
CWD=$(shell pwd)
wget -O images/$(ZIP) -c $(DL_PATH)
unzip -d images/ images/$(ZIP)

# not easily possible to mount ext4 to make the following change to the image, so we load the filesystem by running the image
qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" -hda raspbian_latest.img

# QEMU window (guest) - spawned by previous line
sed -i -e 's/^/#/' /etc/ld.so.preload
# TODO: clean this up with a bash var for path
touch /etc/udev/rules.d/90-qemu.rules
echo 'KERNEL=="sda", SYMLINK+="mmcblk0"' >> /etc/udev/rules.d/90-qemu.rules
echo 'KERNEL=="sda?", SYMLINK+="mmcblk0p%n"' >> /etc/udev/rules.d/90-qemu.rules
echo 'KERNEL=="sda2", SYMLINK+="root"' >> /etc/udev/rules.d/90-qemu.rules
exit

# OSX terminal (host)
#   start the final raspberry pi image and specify a network mapping
#   of local port 5022 to the pi's port 22
qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -hda raspbian_latest.img -redir tcp:5022::22

# QEMU (guest) - raspberry pi emulation
#   @FIXME
#   for some reason it drops out of the startup procedure
#   and dumps you to the terminal prematurely
exit
#   if this is not first-run, we are done..
#   else we are ushered into raspi-config (first run only)
#   select "Finish" when done configuring

# OSX terminal (host)
ssh -p 5022 pi@localhost
