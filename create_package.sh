#!/bin/bash
DIR=$(mktemp -d /tmp/mcrouter-packager.XXXXXXX)
LIB_DIR="$DIR/usr/local/lib/mcrouter"
BIN_DIR="$DIR/usr/local/bin"

mkdir -p $LIB_DIR $BIN_DIR

cp lib/* $LIB_DIR
cp bin/mcrouter $BIN_DIR
./copy_deps.sh bin/mcrouter $LIB_DIR

echo "Building package"
VERSION=$1
fpm -s dir -t deb -C "$DIR" -n yammer-mcrouter -v $VERSION -a amd64 --description "mcrouter" --maintainer "bmorton@yammer-inc.com" -C $DIR .
