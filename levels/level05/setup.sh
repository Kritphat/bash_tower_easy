#!/bin/bash
# Floor 6: bzip2 > tar > gzip > a binary file with the password inside
set -euo pipefail
. /root/build/tower/lib.sh

work=$(mktemp -d)
cd "$work"

head -c 1500 /dev/urandom > loot
printf '\0LOOT: the password for %s is %s\0' "$NEXT_USER" "$NEXT_PASS" >> loot
head -c 1500 /dev/urandom >> loot

gzip -c loot > inner_box
tar -cf middle_box inner_box
bzip2 -c middle_box > "$LEVEL_HOME/shulker_box"

cd /
rm -rf "$work"
lock "$LEVEL_HOME/shulker_box"
