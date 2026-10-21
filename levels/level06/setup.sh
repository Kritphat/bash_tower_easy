#!/bin/bash
# Floor 11: two long files that differ in a single line
set -euo pipefail
. /root/build/tower/lib.sh

python3 - <<'PY'
import os, random, secrets

alphabet = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789'
def mark():
    return ''.join(secrets.choice(alphabet) for _ in range(16))

old = [mark() for _ in range(2000)]
new = list(old)
new[random.randint(200, 1800)] = os.environ['NEXT_PASS']

home = os.environ['LEVEL_HOME']
for name, lines in (('map_old.txt', old), ('map_new.txt', new)):
    with open(f'{home}/{name}', 'w') as f:
        f.write('\n'.join(lines) + '\n')
PY
lock "$LEVEL_HOME/map_old.txt" "$LEVEL_HOME/map_new.txt"
