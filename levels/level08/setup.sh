#!/bin/bash
# Floor 9: the flag
set -euo pipefail
. /root/build/tower/lib.sh

install -o root -g "$LEVEL_USER" -m 440 "$CHALLENGE/flag.txt" "$LEVEL_HOME/flag.txt"
