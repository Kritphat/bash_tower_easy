#!/bin/bash
# Floor 2: 1000 lines, only one of them appears exactly once
set -euo pipefail
. /root/build/tower/lib.sh

python3 - <<'PY'
import os, random, secrets

alphabet = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789'
def code():
    return ''.join(secrets.choice(alphabet) for _ in range(16))

# 100x2 + 133x3 + 100x4 = 999 repeated offers, plus the single unique one
lines = [os.environ['NEXT_PASS']]
for copies, how_many in ((2, 100), (3, 133), (4, 100)):
    for _ in range(how_many):
        lines += [code()] * copies
random.shuffle(lines)

with open(os.environ['LEVEL_HOME'] + '/trades.txt', 'w') as f:
    f.write('\n'.join(lines) + '\n')
PY
lock "$LEVEL_HOME/trades.txt"
