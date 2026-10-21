#!/bin/bash
# Floor 1: a file with an awkward name inside a hidden directory
set -euo pipefail
. /root/build/tower/lib.sh

echo "This chest is empty. Somebody looted it before you." > "$LEVEL_HOME/chest.txt"
lock "$LEVEL_HOME/chest.txt"

mkdir "$LEVEL_HOME/.tall_grass"
echo "The password for $NEXT_USER is $NEXT_PASS" > "$LEVEL_HOME/.tall_grass/-wooden chest-"
lock "$LEVEL_HOME/.tall_grass/-wooden chest-"
chown root:"$LEVEL_USER" "$LEVEL_HOME/.tall_grass"
chmod 550 "$LEVEL_HOME/.tall_grass"
