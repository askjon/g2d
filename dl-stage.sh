#!/bin/bash

TARGET=$1

# Downloading Tarball
wget -r -np -nH --cut-dirs=7 -P $TARGET -A stage3-amd64-hardened-[0-9]*T[0-9]*Z.tar.xz* https://ftp-stud.hs-esslingen.de/pub/Mirrors/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened/

# Downloading Keys
wget -O- https://gentoo.org/.well-known/openpgpkey/hu/wtktzo4gyuhzu8a4z5fdj3fgmr1u6tob?l=releng | gpg --import

echo "[$0] VERIFICATION"

gpg --verify $TARGET/stage3*.tar.xz.DIGESTS.asc
grep -A 1 -i sha512 $TARGET/stage3*tar.xz.DIGESTS.asc
sha512sum $TARGET/stage3*.tar.xz

echo "[USER] Everything checks out? y|[n]"
read RESPONSE

if [ -z $RESPONSE ]
then 
	RESPONSE=n
fi

if [ ! $RESPONSE = "y" ]
then
	echo "[$0] Adding dirty flag"
	touch $TARGET/.dirty
	echo "[$0] Stopping installation got wrong response"
	exit 1
fi

