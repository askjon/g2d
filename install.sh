#!/bin/bash 

# The u2l installer 1st stage

# Assumes the Target is already mounted like in production

TARGET=/mnt/gentoo
BIN_IMPORT=pkg

echo "[$0] U2L INSTALLER"

echo "[USER] Enter the set you want to install [dsk]"
read SETTINGS

if [ -z $SETTINGS ]
then
	SETTINGS=dsk
fi

USET=sets/$SETTINGS

echo "[$0] USING SET $USET"

if [ ! -d $USET ]
then
	echo "[ERROR] Could not find $USET"
	exit 1
fi

if [ ! -e $USET/stages/stage3*.tar.xz ]
then
	echo "[WARNING] Can\'t find stage3 tarball, now downloading"
	./dl-stage.sh $USET/stages/ || exit 1
	rm $USET/stages/.dirty
fi

if [ -e $USET/stages/.dirty ]
then
	echo "[WARNING] Dirty flag found ! Might be insecure tarball"
	echo "[USER] Redownload? Proceed? r|y|[n]"
	read RESPONSE

	if [ -z $RESPONSE ]
	then 
		RESPONSE=n
	fi

	if [ ! $RESPONSE = "y" ]
	then 
		if [ $RESPONSE = "r" ]
		then
			echo "[WARNING] Redownloading the tarball"
			./dl-stage.sh $USET/stages/ || exit 1
			rm $USET/stages/.dirty
		else
			echo "[ERROR] Dirty flag can not be ignored!"
			exit 1
		fi
	fi
fi

echo "[USER] Should we import binary pkgs? y|[n]"
read RESPONSE

if [ -z $RESPONSE ]
then
	RESPONSE=n
fi

if [ $RESPONSE = "y" ]
then
	echo "[USER] Importing from? [$BIN_IMPORT]"
	read RESPONSE
	if [ ! -z $RESPONSE ]
	then
		BIN_IMPORT=$RESPONSE
	fi
	./import-bin.sh $TARGET $BIN_IMPORT
fi

echo "[$0] EXTRACTING BASE SYSTEM"

tar xpvf $USET/stages/stage3*.tar.xz --xattrs-include='*.*' --numeric-owner -C $TARGET
 
echo "[$0] COPYING INSTALLER FILES TO DISK"

cp $USET/chroot.sh $TARGET
cp $USET/pkgs.lst $TARGET

mkdir $TARGET/overlay
cp -rf $USET/overlay/* $TARGET/overlay

echo "[$0] 1ST STAGE CONFIGURATION"

# Adjust System Clock [leaks ip]
ntpd -q -g

# Copying portage net info
mkdir -p $TARGET/etc/portage/repos.conf
cp $TARGET/usr/share/portage/config/repos.conf $TARGET/etc/portage/repos.conf/gentoo.conf

./gen-fstab.sh $TARGET
cat fstab.gen >> $TARGET/etc/fstab

echo "[$0] CHROOTING"

cp --dereference /etc/resolv.conf $TARGET/etc/resolv.conf

mount --types proc /proc $TARGET/proc
mount --rbind /sys $TARGET/sys
mount --make-rslave $TARGET/sys
mount --rbind /dev $TARGET/dev
mount --make-rslave $TARGET/dev 

chroot $TARGET /chroot.sh

echo "[$0] EXITING CHROOT"

umount -l $TARGET/dev{/shm,/pts,}
umount -R $TARGET{/proc,/sys}

echo "[$0] REMOVING INSTALLER FILES"

rm $TARGET/chroot.sh
rm $TARGET/pkg.lst

