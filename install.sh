#!/bin/bash

set -ex

env > "$(dirname "$0")/env.capture.$(date +%s)"
script/install-dotfiles
