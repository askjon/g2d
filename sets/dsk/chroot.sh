#!/bin/bash

# The u2l installer 2nd stage (chroot)

# !!!!!!!!!!!!!!!!!!!
# Not to start on your own this will be handled by 1st stage installer
# because the system has to be in a very prepared state for the
# installer to work


echo "[$0] 2ND STAGE INSTALLER"

source /etc/profile

echo "[$0] UPDATING AND CONFIGURING PORTAGE TREE & WORLD"

emerge-webrsync

emerge dev-util/ccache

cp -rf /overlay/etc/portage/* /etc/portage/

emerge -k --usepkg y --verbose --update --deep --newuse @world >> /install.log

echo "[$0] 2ND STAGE CONFIGURATION"

# TIME
echo "Europe/Berlin" > /etc/timezone
emerge --config sys-libs/timezone-data
# LOCALES
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set en_US.uft8
env-update 
source /etc/profile
echo "sys-kernel/linux-firmware linux-fw-redistributable no-source-code" >> /etc/portage/package.license

echo "[$0] INSTALLING SYSTEM PACKAGES"

emerge -k --usepkg y --verbose $(cat pkg.lst | tr "\n" " ") >> /install.log

echo "[$0] COPYING CONFIGURATION"

cp -rf /overlay/* /

echo "[$0] KERNEL"

genkernel all

echo "[$0] GRUB"

grub-install --target=efi-64 --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

echo "[$0] PASSWORD"
echo "[USER] Enter root password"

passwd




if [ -e root ] 
	then	
	cp -rf /root/etc/portage/* /etc/portage/
	
fi
