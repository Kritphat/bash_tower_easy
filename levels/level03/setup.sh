#!/bin/bash
# Floor 4: one file somewhere on the filesystem, owned by herobrine, 33 bytes
set -euo pipefail
. /root/build/tower/lib.sh

python3 - <<'PY'
import os, random, shutil

group = os.environ['LEVEL_USER']
places = ['/var/lib/mineshaft/tunnel_1', '/var/lib/mineshaft/tunnel_2',
          '/var/lib/mineshaft/tunnel_3', '/usr/share/caves/dripstone',
          '/usr/share/caves/lush', '/srv/ravine', '/opt/quarry',
          '/var/cache/deepslate', '/usr/local/share/geode', '/var/spool/lavalake']
for place in places:
    os.makedirs(place, exist_ok=True)

used = set()
def drop(owner, content):
    while True:
        path = f'{random.choice(places)}/ore_{random.randint(100, 999)}'
        if path not in used:
            break
    used.add(path)
    with open(path, 'w') as f:
        f.write(content)
    shutil.chown(path, owner, group)
    os.chmod(path, 0o640)

diamond = f"The diamond is: {os.environ['NEXT_PASS']}\n"
assert len(diamond) == 33
drop('herobrine', diamond)

# Right owner, wrong size
for _ in range(15):
    size = random.choice([s for s in range(20, 60) if s != 33])
    drop('herobrine', ('Just cobblestone. ' * 4)[:size - 1] + '\n')
# Right size, wrong owner
for owner in ['root', 'nobody'] * 6:
    drop(owner, 'Only gravel here, keep digging..\n')
PY
