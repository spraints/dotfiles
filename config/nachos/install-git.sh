#!/bin/bash

set -e
set -o nounset

VERSION=2.27.0
TARBALL=https://github.com/git/git/archive/v${VERSION}.tar.gz
WORKDIR=$HOME/git-build

if /usr/local/bin/git --version 2>/dev/null | grep -q $VERSION; then
  echo Git $VERSION is already installed
  exit 0
fi

#start=$(date +%s)
#rt() {
#  stop=$(date +%s)
#  echo "runtime: $((stop-start)) seconds"
#}
#trap rt EXIT

set -x

rm -rf "$WORKDIR"
mkdir "$WORKDIR"
cd "$WORKDIR"
curl -L -o git.tgz "$TARBALL"
tar xfz git.tgz
cd git-*
make prefix=/usr/local all
sudo make prefix=/usr/local install

cd $HOME
rm -rf $WORKDIR

sudo apt-get remove -y git
