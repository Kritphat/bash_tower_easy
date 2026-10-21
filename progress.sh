#!/bin/bash
# Shows the highest floor each player has logged in to (read from the sshd log).
# The log starts again when a tower is reset.
set -euo pipefail
cd "$(dirname "$0")"

for player in $(docker compose ps --services | sort); do
    top=$(docker logs "locstd-easy-$player" 2>&1 \
        | grep -o 'Accepted [a-z]* for locstd[0-9]*' \
        | grep -o '[0-9]*$' | sort -n | tail -1 || true)
    if [ -z "$top" ]; then
        echo "$player  not logged in yet"
    else
        echo "$player  floor $((10#$top + 1)) of 9"
    fi
done
