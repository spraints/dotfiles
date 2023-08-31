#!/bin/bash

# todo: add 't bitbar' command that outputs a dot and a number
export T_DATA_FILE=${HOME}/.data/t.csv
T=${HOME}/spraints/t/target/release/t
exec "$T" bitbar --wrapper="$0" "$@"
