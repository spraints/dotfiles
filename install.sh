#!/bin/bash

set -e

if [ "${CODESPACES}" = "true" ]; then
  script/install-codespaces
else
  echo This only does anything in Codespaces. Try running one of the install scripts.
  ls script/install-*
fi
