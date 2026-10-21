# Bash Tower (easy)

The easy version of `bash_tower`: 9 floors, from Spawn to the Ender Dragon.
It drops the Nether floors (processes, signals, ports) and the dragon that logs you out.
Every player gets their own container with the users `locstd00` - `locstd08`.
The floor 1 login of each player is the same as in `bash_tower`.
Each floor hides the password of the next user; the last floor holds the flag.

**Keep this repository private.** `players/` contains every password and
`levels/level08/challenge/flag.txt` contains the flag.

## Deploy

Needs Docker with the compose plugin.

```
git clone <this repo>
cd bash_tower
./deploy.sh
```

This starts 21 containers on ports 12201 - 12221:

| Towers | Ports |
|---|---|
| `player01` - `player17` (students) | 12201 - 12217 |
| `teacher01` - `teacher03` | 12218 - 12220 |
| `testuser` | 12221 |

A player connects with `ssh locstd00@<server> -p <port>`.

| Script | What it does |
|---|---|
| `./deploy.sh` | Build and start every tower. Safe to run again. |
| `./reset.sh player07` | Give one player a fresh tower with the same passwords. |
| `./progress.sh` | Show the highest floor each player has logged in to. |
| `docker compose down` | Stop and remove every tower. |

## Layout

```
base/                    Ubuntu 22.04 + sshd + the tools the floors need
tower/                   dockerfile, build script and entrypoint of a player's tower
levels/levelNN/          setup.sh builds the floor, challenge/README is what the player reads
players/<tower>.env      the 9 passwords of that tower
generate.py              creates players/ and docker-compose.yml
```

`levelNN` is the home of `locstdNN`, so floor 1 is `level00` and floor 9 is `level08`.

## Changing passwords or the number of players

`python3 generate.py --force` makes new passwords for everybody and rewrites
`docker-compose.yml` and the instructor files in `../bash_instruction_easy/`.
The number of students and teachers and the first port are at the top of `generate.py`.
Run it without `--force` to add towers and keep the passwords that already exist.

Both towers use the same ports and the user names `locstd00`, ... so run only one of them
on a server at a time (`docker compose down` in the other folder first).
