#!/usr/bin/env python3
"""Creates the passwords of every player and the files that depend on them.

    python3 generate.py            keep existing passwords, rewrite the other files
    python3 generate.py --force    throw every password away and make new ones

The floor 1 password of each tower is copied from the hard tower
(../bash_tower/players/<tower>.env), so a player's starting login is the same in both.

The floor 1 password of each tower is copied from the hard tower
(../bash_tower/players/<tower>.env), so a player's starting login is the same in both.

Writes:
    players/<tower>.env                     passwords used to build that tower
    docker-compose.yml                      one container per tower
    ../bash_instruction_easy/credentials.csv     every login, for the instructor
    ../bash_instruction_easy/starting_logins.txt the floor 1 login of every player
    ../bash_instruction_easy/starting_logins.md  the same, as a Markdown table
"""
import secrets
import sys
from pathlib import Path

STUDENTS = 17
TEACHERS = 3
FLOORS = 9
FIRST_PORT = 12201
# No look-alike characters (0/O, 1/l/I)
ALPHABET = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789'

repo = Path(__file__).resolve().parent
players_dir = repo / 'players'
instructor_dir = repo.parent / 'bash_instruction_easy'
hard_players_dir = repo.parent / 'bash_tower' / 'players'
force = '--force' in sys.argv

players_dir.mkdir(exist_ok=True)
instructor_dir.mkdir(exist_ok=True)

# Students first, then teachers, then one tower for testing. Ports follow this order.
TOWERS = ([f'player{n:02d}' for n in range(1, STUDENTS + 1)]
          + [f'teacher{n:02d}' for n in range(1, TEACHERS + 1)]
          + ['testuser'])

compose = ['name: bash-tower-easy', '', 'services:']
credentials = ['player,port,floor,user,password']
starting = []
starting_md = ['# Bash Tower (easy) - starting logins', '',
               'Connect with `ssh locstd00@<server> -p <port>`.', '',
               '| Tower | Port | Username | Password |', '|---|---|---|---|']

for index, player in enumerate(TOWERS):
    port = FIRST_PORT + index
    env_file = players_dir / f'{player}.env'

    if env_file.exists() and not force:
        passwords = [line.split('=', 1)[1] for line in env_file.read_text().split()]
    else:
        passwords = [''.join(secrets.choice(ALPHABET) for _ in range(16))
                     for _ in range(FLOORS)]
        hard_env = hard_players_dir / f'{player}.env'
        if hard_env.exists():
            passwords[0] = hard_env.read_text().split()[0].split('=', 1)[1]
        env_file.write_text(''.join(f'PASS{i:02d}={p}\n' for i, p in enumerate(passwords)))

    for i, password in enumerate(passwords):
        credentials.append(f'{player},{port},{i + 1},locstd{i:02d},{password}')
    starting.append(f'{player}  port {port}  user locstd00  password {passwords[0]}')
    starting_md.append(f'| {player} | {port} | locstd00 | `{passwords[0]}` |')

    compose += [
        f'  {player}:',
        '    build:',
        '      context: .',
        '      dockerfile: tower/dockerfile',
        '      args:',
        f'        PLAYER: {player}',
        f'    image: locstd-easy-{player}',
        f'    container_name: locstd-easy-{player}',
        '    hostname: tower',
        '    ports:',
        f'      - "{port}:22"',
        '    init: true',
        '    pids_limit: 300',
        '    mem_limit: 256m',
        '    cpus: 1',
        '    restart: unless-stopped',
        '',
    ]

(repo / 'docker-compose.yml').write_text('\n'.join(compose))
(instructor_dir / 'credentials.csv').write_text('\n'.join(credentials) + '\n')
(instructor_dir / 'starting_logins.txt').write_text('\n'.join(starting) + '\n')
(instructor_dir / 'starting_logins.md').write_text('\n'.join(starting_md) + '\n')
print(f'{STUDENTS} students, {TEACHERS} teachers, 1 testuser: '
      f'ports {FIRST_PORT}-{FIRST_PORT + len(TOWERS) - 1}')
print(f'instructor files: {instructor_dir}')
