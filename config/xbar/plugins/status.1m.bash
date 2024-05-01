#!/bin/bash

set -e
set -o nounset

PLUGIN_DIR="$(/usr/bin/dirname $(/usr/bin/readlink -f "$0"))"/github-status-bar

if [ ! -d "$PLUGIN_DIR" ]; then
  printf "❓\n---\ngithub-status-bar is not checked out.\nTry running config/xbar/install again.\n"
  exit 0
fi

export PATH='/opt/homebrew/bin:/usr/local/bin:$PATH'

cd "$PLUGIN_DIR"
node plugins/status.js
