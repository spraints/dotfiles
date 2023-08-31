#!/bin/bash

exec "$(dirname "$(readlink -f "$0")")/up-or-not/xbar-plugin.rb"
