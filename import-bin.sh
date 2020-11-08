#!/bin/bash

TARGET=$1
BINARY_DB=$2

echo "[$0] IMPORTING BINARYS"

mkdir -p $TARGET/var/cache/binpkgs
cp -rf $BINARY_DB $TARGET/var/cache/binpkgs 

