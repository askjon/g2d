#!/bin/bash

TARGET=$1
BINARY_DB=$2

echo "[$0] IMPORTING BINARYS"

cp -rf $BINARY_DB $TARGET/var/cache/binpkgs 

