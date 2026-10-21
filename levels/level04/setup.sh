#!/bin/bash
# Floor 5: Base64, then a hex dump
set -euo pipefail
. /root/build/tower/lib.sh

echo "The password for $NEXT_USER is $NEXT_PASS" \
    | base64 \
    | xxd > "$LEVEL_HOME/enchanted_book.txt"
lock "$LEVEL_HOME/enchanted_book.txt"
