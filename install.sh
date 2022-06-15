#!/bin/bash

set -e

if [ "${CODESPACES}" = "true" ]; then
  exec script/install-codespaces
fi

case "$(hostname)" in
  *bpdev*github.net)
    exec script/install-bpdev
    ;;
esac

echo This only does anything in Codespaces. Try running one of the install scripts.
ls script/install-*
