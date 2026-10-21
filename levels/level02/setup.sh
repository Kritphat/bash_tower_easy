#!/bin/bash
# Floor 3: find one row in a CSV with two filters, then take one column
set -euo pipefail
. /root/build/tower/lib.sh

python3 - <<'PY'
import os, random, secrets

alphabet = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789'
def word():
    return ''.join(secrets.choice(alphabet) for _ in range(16))

names = ['Orin', 'Bram', 'Tilda', 'Hesper', 'Garrick', 'Mabel', 'Quill', 'Rowan',
         'Sage', 'Thorne', 'Una', 'Wren', 'Yara', 'Zeke', 'Ida', 'Jory', 'Kip',
         'Lark', 'Nell', 'Pim']
villages = ['Mossfield', 'Oakhollow', 'Stonebrook', 'Dunmere', 'Frostpeak',
            'Sandreach', 'Birchwick', 'Redcliff', 'Palegrove', 'Ironford',
            'Mistvale', 'Sunmeadow']
jobs = ['Librarian', 'Farmer', 'Cleric', 'Fletcher', 'Armorer', 'Toolsmith',
        'Butcher', 'Mason', 'Shepherd', 'Cartographer']

rows = [('Orin', 'Librarian', 'Mossfield', os.environ['NEXT_PASS'])]
# Plenty of other Orins and plenty of other Mossfield villagers
for village in villages[1:]:
    rows.append(('Orin', random.choice(jobs), village, word()))
for name in names[1:]:
    rows.append((name, random.choice(jobs), 'Mossfield', word()))
while len(rows) < 500:
    name, village = random.choice(names), random.choice(villages)
    if (name, village) == ('Orin', 'Mossfield'):
        continue
    rows.append((name, random.choice(jobs), village, word()))
random.shuffle(rows)

with open(os.environ['LEVEL_HOME'] + '/ledger.csv', 'w') as f:
    f.write('id,name,profession,village,secret_word\n')
    for i, row in enumerate(rows, 1):
        f.write(f'{i},' + ','.join(row) + '\n')
PY
lock "$LEVEL_HOME/ledger.csv"
