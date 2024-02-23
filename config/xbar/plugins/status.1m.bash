#!/bin/bash

set -e
set -o nounset

PLUGIN_DIR="$(/usr/bin/dirname $(/usr/bin/readlink -f "$0"))"/github-status-bar

if [ ! -d "$PLUGIN_DIR" ]; then
  printf "❓\n---\ngithub-status-bar is not checked out.\nTry running config/xbar/install again.\n"
  exit 0
fi

# Only run this plugin at home so that I don't make carbonblack go crazy in
# case I'm tethering.
case "$(ipconfig getifaddr en0)" in
  # too many secrets | too many satellites
  192.168.164.128|192.168.1.27)
    ;;
  *)
    printf '💼\n---\n(github status not available away from home)\n'
    exit 0
    ;;
esac

export PATH='/usr/local/bin:$PATH'

cd "$PLUGIN_DIR"
node plugins/status.js
